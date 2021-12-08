//
//  Errors.swift
//  LocationWeatherDemo1
//
//  Created by Герман on 30.11.21.
//

import Foundation
import UIKit

class ErrorManager{
    private init(){}
    static let shared = ErrorManager()
    
    func warningForLastCall(timeFromLastCall: String) -> UIAlertController{
        let alert = UIAlertController(title: "Warning", message: "Соединение с сетью отсутсвует. Показана погода последнего соединения с сетью. Последнее соединение было \(timeFromLastCall) назад.", preferredStyle: .alert)
        let buttonOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(buttonOk)
        return alert
    }
    
    func warningWasNoConnect() -> UIAlertController{
        let alert = UIAlertController(title: "Warning", message: "Соединение с сетью отсутсвует. Подключите интернет для отображения погоды.", preferredStyle: .alert)
        let buttonOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(buttonOk)
        return alert
    }
    
    func errorParsing() -> UIAlertController{
        let alert = UIAlertController(title: "Error", message: "404", preferredStyle: .alert)
        let buttonOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(buttonOk)
        return alert
    }
    

}
