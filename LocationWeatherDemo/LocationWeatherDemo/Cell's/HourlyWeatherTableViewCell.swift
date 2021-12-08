//
//  HourlyWeatherTableViewCell.swift
//  LocationWeatherDemo
//
//  Created by Герман on 22.11.21.
//

import UIKit
import CoreData


class HourlyWeatherTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var hourlyWeather = [Hourly]()
    var archiveOfHourlyWeather : [NSManagedObject] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if archiveOfHourlyWeather != []{
            return archiveOfHourlyWeather.count
        }
        return hourlyWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollectionView", for: indexPath) as! CollectionViewCell
        if archiveOfHourlyWeather != []{
            cell.labelTemperature.text = archiveOfHourlyWeather[indexPath.row].value(forKey: "temperature") as? String
            cell.labelDate.text = archiveOfHourlyWeather[indexPath.row].value(forKey: "date") as? String
            cell.iconWeather.image = UIImage(named: archiveOfHourlyWeather[indexPath.row].value(forKey: "icon") as! String)
        }else if let date = hourlyWeather[indexPath.row].dt, let iconString = hourlyWeather[indexPath.row].weather?[0].icon, let temp = hourlyWeather[indexPath.row].temp{
            cell.labelTemperature.text = "\(String(describing: temp))" + "ºF".localized()
            cell.labelDate.text = DateFormat.shared.dateFormat(dateDouble: Double(date), format: "HH:mm")
            cell.iconWeather.image = UIImage(named: iconString)
        }
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
        return CGSize(width: 181.0, height: 222.0)
        }

}
