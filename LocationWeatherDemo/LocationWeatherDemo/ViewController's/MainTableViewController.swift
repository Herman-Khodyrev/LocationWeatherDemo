//
//  TableViewController.swift
//  LocationWeatherDemo
//
//  Created by Герман on 22.11.21.
//

import UIKit
import GooglePlaces
import CoreLocation
import CoreData

class MainTableViewController: UITableViewController, WeatherViewModelDelegate{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var archiveOfDate : [NSManagedObject] = []
    var archiveOfCurrentWeather : [NSManagedObject] = []
    var archiveOfHourlyWeather : [NSManagedObject] = []
    var archiveOfDailyWeather : [NSManagedObject] = []

    
    var weather: WeatherViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        weather = WeatherViewModel(delegate: self)
        if NetworkMonitor.shared.isConnected{
            deleteData(entity: "DateForSave")
            deleteData(entity: "CurrentWeatherForSave")
            deleteData(entity: "HourlyWeatherForSave")
            deleteData(entity: "DailyWeatherForSave")
            saveDate()
            LocationManager.shared.getUserLocation{ location in
                DispatchQueue.global().async {
                    self.weather?.getWeather(lat: "\(location.coordinate.latitude)", lon: "\(location.coordinate.longitude)", exclude: "minutely,alert")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            fetchDate()
            if archiveOfDate != []{
                let timeFromLastCall = DateFormat.shared.timeFromLastCall(recent: Date(), previous: archiveOfDate[0].value(forKey: "dateForSave") as! Date)
                present(ErrorManager.shared.warningForLastCall(timeFromLastCall: timeFromLastCall), animated: true, completion: nil)
            } else {
                present(ErrorManager.shared.warningWasNoConnect(), animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if NetworkMonitor.shared.isConnected{
            saveCurrent()
            saveHourly()
            saveDaily()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if NetworkMonitor.shared.isConnected{
            let count = (weather?.getCountOfCurrentWeather() ?? 0) + (weather?.getCountOfHourlyWeather() ?? 0) + (weather?.getCountOfDailyWeather() ?? 0)
            return count
        }else{
            return 2 + archiveOfDailyWeather.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if NetworkMonitor.shared.isConnected{
            if indexPath.row == 0{
               let cell = tableView.dequeueReusableCell(withIdentifier: "cellFirst", for: indexPath) as! CurrentWeatherTableViewCell
                if let currentTemperature = weather?.getCurrentTempereture(){
                    cell.labelTemperature.text = "\(currentTemperature)" + "ºF".localized()
                    cell.iconWeather.image = weather?.getIconCurrentWeather(index: indexPath.row)
                }
                return cell
            } else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellSecond", for: indexPath) as! HourlyWeatherTableViewCell
                    if let hourlyWeather = weather?.getHourlyWeather(){
                        cell.hourlyWeather = hourlyWeather
                    }
                return cell
            } else if indexPath.row >= 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellThird", for: indexPath) as! DailyWeatherTableViewCell
                if let dailyTemperature = weather?.getDailyTemperature(index: indexPath.row - 2){
                    cell.iconWeather.image = weather?.getIconDailyWeather(index: indexPath.row - 2)
                    cell.labelDay.text = DateFormat.shared.dateFormat(dateDouble: weather?.getDayOfDailyWeather(index: indexPath.row - 2) ?? 0.0, format: "E, d MMM yyyy")
                    cell.labelTemperature.text = "\(dailyTemperature)" + "ºF".localized()
                }
                return cell
            }
        } else if !NetworkMonitor.shared.isConnected {
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellFirst", for: indexPath) as! CurrentWeatherTableViewCell
                cell.iconWeather.image = UIImage(named: archiveOfCurrentWeather[0].value(forKey: "icon") as! String)
                cell.labelTemperature.text = archiveOfCurrentWeather[0].value(forKey: "temperature") as? String
                return cell
            } else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellSecond", for: indexPath) as! HourlyWeatherTableViewCell
                cell.archiveOfHourlyWeather = archiveOfHourlyWeather
                return cell
            } else if indexPath.row >= 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellThird", for: indexPath) as! DailyWeatherTableViewCell
                cell.iconWeather.image = UIImage(named: archiveOfDailyWeather[indexPath.row - 2].value(forKey: "icon") as! String)
                cell.labelDay.text = archiveOfDailyWeather[indexPath.row - 2].value(forKey: "date") as? String
                cell.labelTemperature.text = archiveOfDailyWeather[0].value(forKey: "temperature") as? String
                return cell
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if NetworkMonitor.shared.isConnected{
            if indexPath.row == 0{
                return 262
            } else if indexPath.row == 1{
                return 282
            } else if indexPath.row >= 2{
                return 120
            }
        } else if !NetworkMonitor.shared.isConnected{
            if indexPath.row == 0{
                return 262
            } else if indexPath.row == 1{
                return 282
            } else if indexPath.row >= 2{
                return 120
            }
        }
        return 1
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showError(error: String) {
        present(ErrorManager.shared.errorParsing(), animated: true, completion: nil)
    }
    
    func saveDate(){
        let managedContext = appDelegate.persistentContainer.viewContext // убрал ! после appDelegate
        let entityDate = NSEntityDescription.entity(forEntityName: "DateForSave", in: managedContext)!
        let archiveOfDate = NSManagedObject(entity: entityDate, insertInto: managedContext)
        archiveOfDate.setValue(Date(), forKey: "dateForSave")
        do {
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveCurrent(){
        let managedContext = appDelegate.persistentContainer.viewContext
        let entityCurrentWeather = NSEntityDescription.entity(forEntityName: "CurrentWeatherForSave", in: managedContext)!
        let archiveOfCurrentWeather = NSManagedObject(entity: entityCurrentWeather, insertInto: managedContext)
        guard let temperature = weather?.getCurrentTempereture() else {return}
        guard let icon = weather?.getOpenWeather()?.current?.weather?[0].icon else {return}
        archiveOfCurrentWeather.setValue(String(temperature), forKey: "temperature")
        archiveOfCurrentWeather.setValue(icon, forKey: "icon")
        do {
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveHourly(){
        let managedContext = appDelegate.persistentContainer.viewContext
        let entityHourlyWeather = NSEntityDescription.entity(forEntityName: "HourlyWeatherForSave", in: managedContext)!
        if let weatherHourly = weather?.getHourlyWeather(){
            for i in weatherHourly.indices{
                let archiveOfHourlyWeather = NSManagedObject(entity: entityHourlyWeather, insertInto: managedContext)
                guard let temperature = weatherHourly[i].temp else {return}
                archiveOfHourlyWeather.setValue(String(temperature), forKey: "temperature")
                archiveOfHourlyWeather.setValue(weatherHourly[i].weather?[0].icon, forKey: "icon")
                archiveOfHourlyWeather.setValue(DateFormat.shared.dateFormat(dateDouble: Double(weatherHourly[i].dt!), format: "HH:mm"), forKey: "date")
                do {
                    try managedContext.save()
                } catch let error as NSError{
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func saveDaily(){
        let managedContext = appDelegate.persistentContainer.viewContext
        let entityDailyWeather = NSEntityDescription.entity(forEntityName: "DailyWeatherForSave", in: managedContext)!
        if let weatherDaily = weather?.getDailyWeather(){
            for i in weatherDaily.indices{
                let archiveOfDailyWeather = NSManagedObject(entity: entityDailyWeather, insertInto: managedContext)
                guard let temperature = weatherDaily[i].temp?.day else {return}
                archiveOfDailyWeather.setValue(String(temperature), forKey: "temperature")
                archiveOfDailyWeather.setValue(weatherDaily[i].weather?[0].icon, forKey: "icon")
                archiveOfDailyWeather.setValue(DateFormat.shared.dateFormat(dateDouble: Double(weatherDaily[i].dt!),format: "E, d MMM yyyy"), forKey: "date")
                do {
                    try managedContext.save()
                } catch let error as NSError{
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
        
    
    func fetchDate(){
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequestDate = NSFetchRequest<NSManagedObject>(entityName: "DateForSave")
        let fetchRequestCurrentWeather = NSFetchRequest<NSManagedObject>(entityName: "CurrentWeatherForSave")
        let fetchRequestHourlyWeather = NSFetchRequest<NSManagedObject>(entityName: "HourlyWeatherForSave")
        let fetchRequestDailyWeather = NSFetchRequest<NSManagedObject>(entityName: "DailyWeatherForSave")
        do {
            self.archiveOfDate = try managedContext.fetch(fetchRequestDate)
            self.archiveOfCurrentWeather = try managedContext.fetch(fetchRequestCurrentWeather)
            self.archiveOfHourlyWeather = try managedContext.fetch(fetchRequestHourlyWeather)
            self.archiveOfDailyWeather = try managedContext.fetch(fetchRequestDailyWeather)
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteData(entity: String) {
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for managedObject in results {
                if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                    context.delete(managedObjectData)
                }
            }
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
    }

}

extension String{
    func localized() -> String{
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
