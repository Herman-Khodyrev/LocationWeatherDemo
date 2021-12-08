//
//  PlaceWeatherViewController.swift
//  LocationWeatherDemo
//
//  Created by Герман on 26.11.21.
//

import UIKit
import CoreLocation

class PlaceWeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WeatherViewModelDelegate, SearchViewControllerDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    var weather: WeatherViewModel?
    
    let searchVC = UISearchController.init(searchResultsController: SearchViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weather = WeatherViewModel(delegate: self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather?.getCountOfCurrentWeather() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
           let cell = tableView.dequeueReusableCell(withIdentifier: "cellFirst", for: indexPath) as! CurrentWeatherTableViewCell
            if let currentTemperature = weather?.getCurrentTempereture(){
                cell.labelTemperature.text = "\(currentTemperature)" + "ºF".localized()
                cell.iconWeather.image = weather?.getIconCurrentWeather(index: indexPath.row)
            }
            return cell
        } 
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            return 262
        }
        return 0
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showError(error: String) {
        let alert = UIAlertController(title: "Error", message: "404", preferredStyle: .alert)
        let buttonOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(buttonOk)
        present(alert, animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let searchVC = searchController.searchResultsController as? SearchViewController else {
            return
        }
        
        searchVC.delegate = self

        GooglePlacesManager.shared.findPlaces(query: query){
            result in
            switch result{
            case .success(let places):
                DispatchQueue.main.async {
                    searchVC.update(with: places)
                }
            case .failure(let error): print(error)
            }
        }
    }
    
    func didTapPlace(with coordinates: CLLocationCoordinate2D) {
        searchVC.searchBar.resignFirstResponder()
        searchVC.dismiss(animated: true, completion: nil)
        weather?.getWeather(lat: "\(coordinates.latitude)", lon: "\(coordinates.longitude)", exclude: "minutely,alert,daily")
        tableView.reloadData()
    }

}
