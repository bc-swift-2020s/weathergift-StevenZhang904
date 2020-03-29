//
//  WeatherDetail.swift
//  WeatherGift
//
//  Created by 张泽华 on 2020/3/24.
//  Copyright © 2020 张泽华. All rights reserved.
//

import Foundation

private let dateFormatter: DateFormatter = {
    print("I just created a date formatter in WeatherDetail.swift")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter
}()

private let hourlyFormatter: DateFormatter = {
    print("I just created a hourly formatter in WeatherDetail.swift")
    let hourlyFormatter = DateFormatter()
    hourlyFormatter.dateFormat = "ha"
    return hourlyFormatter
}()


struct DailyWeather: Codable{
    var dailyIcon: String
    var dailyWeekday: String
    var dailySummary: String
    var dailyHigh: Int
    var dailyLow: Int
}

struct HourlyWeather: Codable{
    var hour: String
    var hourlyIcon: String
    var hourlyTemperature: Int
    var hourlyPrecipProbability: Int
}

class WeatherDetail: WeatherLocation{
    
    private struct Result:Codable{
        var timezone : String
        var currently: Currently
        var daily: Daily
        var hourly: Hourly
    }
    
    private struct Currently: Codable{
        var temperature:Double
        var time: TimeInterval
    }
    
    private struct Daily: Codable{
        var summary: String
        var icon: String
        var data: [DailyData]
    }
    
    private struct DailyData: Codable{
        var icon: String
        var time: TimeInterval
        var summary: String
        var temperatureHigh: Double
        var temperatureLow: Double
    }
    
    private struct Hourly: Codable{
        var data: [HourlyData]
    }
    
    private struct HourlyData: Codable{
        var time: TimeInterval
        var icon: String
        var precipProbaility: Double
        var temperature: Double
    }
    
    var timezone = ""
    var currentTime = 0.0
    var temperature = 0
    var summary = ""
    var dailyIcon = ""
    var dailyWeatherData: [DailyWeather] = []
    var hourlyWeatherData: [HourlyWeather] = []

    
    func getData(completed: @escaping  () -> ()){
         let coordinates = "\(latituide),\(longitutde)"
        
        let urlString = "\(APIurls.darkSkyURL)\(APIkeys.darkSkyKey)/\(coordinates)"

         print("we are accessing the url \(urlString)")
         guard let url = URL(string: urlString) else{
             print("error. cannot create a url form \(urlString)")
            completed()
             return
         }
         let session = URLSession.shared
         
         let task = session.dataTask(with: url){(data, response, error) in
             if let error = error{
                 print("error \(error.localizedDescription)")
             }
         
         do{
            let result = try JSONDecoder().decode(Result.self, from: data!)
            self.timezone = result.timezone
            self.currentTime = result.currently.time
            self.temperature = Int(result.currently.temperature.rounded())
            self.summary = result.daily.summary
            self.dailyIcon = result.daily.icon
            
            for index in 0..<result.daily.data.count{
                let weekDayDate = Date(timeIntervalSince1970: result.daily.data[index].time)
                dateFormatter.timeZone = TimeZone(identifier: result.timezone)
                let dailyWeekday = dateFormatter.string(from: weekDayDate)
                let dailyIcon = result.daily.data[index].icon
                let dailySummary = result.daily.data[index].summary
                let dailyHigh = Int(result.daily.data[index].temperatureHigh.rounded())
                let dailyLow = Int(result.daily.data[index].temperatureLow.rounded())
                let dailyWeather = DailyWeather(dailyIcon: dailyIcon, dailyWeekday: dailyWeekday, dailySummary: dailySummary, dailyHigh: dailyHigh, dailyLow: dailyLow)
                self.dailyWeatherData.append(dailyWeather)
                //print("Day: \(dailyWeather.dailyWeekday) High: \(dailyWeather.dailyHigh) Low:\(dailyWeather.dailyLow)")
            }
            let lastHour = min(24, result.hourly.data.count)
            for index in 0..<lastHour{
                let hourlyDate = Date(timeIntervalSince1970: result.hourly.data[index].time)
                hourlyFormatter.timeZone = TimeZone(identifier: result.timezone)
                let hour = hourlyFormatter.string(from: hourlyDate)
                let hourlyIcon = result.hourly.data[index].icon
                let precipProbability = Int((result.hourly.data[index].precipProbaility * 100).rounded())
                let temperature = Int(result.hourly.data[index].temperature.rounded())
                let hourlyWeather = HourlyWeather(hour: hour, hourlyIcon: hourlyIcon, hourlyTemperature: temperature, hourlyPrecipProbability: precipProbability)
                self.hourlyWeatherData.append(hourlyWeather)
                print("Hour: \(hourlyWeather.hour), Icon: \(hourlyWeather.hourlyIcon), Temperature: \(hourlyWeather.hourlyTemperature), PrecipProbaility: \(hourlyWeather.hourlyPrecipProbability)")
            }
            
         }catch{
            print("JSON error: \(error.localizedDescription)")
         }
            completed()
         }
         task.resume()
     }
}
