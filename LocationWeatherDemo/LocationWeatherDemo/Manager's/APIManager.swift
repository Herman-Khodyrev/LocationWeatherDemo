//
//  APIManager.swift
//  LocationWeatherDemo1
//
//  Created by Герман on 24.11.21.
//

import Foundation
import Alamofire

class APIManager{
    
    private init(){}
    
    static let shared = APIManager()
    
    func getContent(lat: String, lon: String, exclude: String,_ completion: @escaping(OpenWeather?, String?) -> Void){
        let unit = "imperial".localized()
        let apiLink = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=\(unit)&exclude=\(exclude)&appid=0ef71b04e7ad7e37d639d422b4ee8eed"
        print(apiLink)
        AF.request(apiLink).responseDecodable(of: OpenWeather.self){
            
            (responce) in
            guard let object = responce.value
            else{
                completion(nil, "Parsing Error")
                return
            }
            completion(object, nil)
        }
        
    }
    
}
