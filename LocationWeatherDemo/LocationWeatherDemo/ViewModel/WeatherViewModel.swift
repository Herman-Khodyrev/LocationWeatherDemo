//
//  WeatherViewModel.swift
//  LocationWeatherDemo1
//
//  Created by Герман on 24.11.21.
//

import Foundation
import UIKit

protocol WeatherViewModelDelegate: class {
    func reloadData()
    func showError(error: String)
}

class WeatherViewModel{
    
    weak var delegate: WeatherViewModelDelegate?
    
    private var weather: OpenWeather?
    
    init(delegate: WeatherViewModelDelegate){
        self.delegate = delegate
    }
    
    func getWeather(lat: String, lon: String, exclude: String){
        APIManager.shared.getContent(lat: lat, lon: lon, exclude: exclude){
            (currentWeather, error) in
            if let error = error{
                self.delegate?.showError(error: error)
            } else if let currentWeather = currentWeather{
                self.weather = currentWeather
                self.delegate?.reloadData()
            }
        }
    }
    
    func getOpenWeather() -> OpenWeather?{
        return weather
    }
    
    func getCurrentWeather() -> Current?{
        return weather?.current
    }
    
    func getCountOfCurrentWeather() -> Int{
        if weather != nil {
            return 1
        } else {
            return 0
        }
    }
    
    func getCurrentTempereture() -> Double? {
        return weather?.current?.temp
    }
    
    func getIconCurrentWeather(index: Int) -> UIImage?{
        return UIImage(named: weather?.current?.weather?[0].icon ?? "")
    }
    
    func getCountOfHourlyWeather() -> Int{
        if weather?.hourly != nil{
            return 1
        }else {
            return 0
        }
    }
    
    func getHourlyWeather() -> [Hourly]?{
        if let _ = self.weather?.current{
            if let hourly = self.weather?.hourly{
                var hourlyWeather = [Hourly]()
                for i in hourly.indices{
                    if let date = hourly[i].dt{
                        if date - Int(Date().timeIntervalSince1970) > 0 && date - Int(Date().timeIntervalSince1970) <= 21600{
                            hourlyWeather.append(hourly[i])
                        }
                    }
                }
                return hourlyWeather
            }
        } else {
            delegate?.reloadData()
        }
        return nil
    }
    
    func getCountOfDailyWeather() -> Int?{
        return weather?.daily?.count
    }
    
    func getDailyWeather() -> [Daily]?{
        return weather?.daily
    }
    
    func getDailyTemperature(index: Int) -> Double{
        return weather?.daily?[index].temp?.day ?? 0
    }
    
    func getDayOfDailyWeather(index: Int) -> Double?{
        return Double(weather?.daily![index].dt ?? 0)
    }
    
    func getIconDailyWeather(index: Int) -> UIImage?{
        print("")
        return UIImage(named: weather?.daily?[index].weather?[0].icon ?? "")
    }
    
}
