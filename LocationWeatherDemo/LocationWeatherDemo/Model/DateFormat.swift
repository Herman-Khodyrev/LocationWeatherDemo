//
//  DateFormat.swift
//  LocationWeatherDemo1
//
//  Created by Герман on 25.11.21.
//

import Foundation

class DateFormat{
    
    static let shared = DateFormat()
    
    func dateFormat(dateDouble: Double, format: String) -> String{
        let date = Date(timeIntervalSince1970: dateDouble)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let dateTime = formatter.string(from: date)
        return dateTime
    }
    
    func timeFromLastCall(recent: Date, previous: Date) -> String {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second
        guard let second = second else {return ""}
        guard let minute = minute else {return ""}
        guard let hour = hour else {return ""}
        guard let day = day else {return ""}
        guard let month = month else {return ""}
        if second >= 60{
            return "\(minute) минут"
        } else if minute >= 60 {
            return "\(hour) часов"
        }else if hour >= 24{
            return "\(day) дней"
        } else if day >= 31{
            return "\(month) месяцев"
        }
        return "\(second) секунд"
    }
    
    
}
