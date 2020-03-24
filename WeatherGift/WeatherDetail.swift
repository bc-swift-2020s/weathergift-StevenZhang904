//
//  WeatherDetail.swift
//  WeatherGift
//
//  Created by 张泽华 on 2020/3/24.
//  Copyright © 2020 张泽华. All rights reserved.
//

import Foundation
class WeatherDetail: WeatherLocation{
    
    struct Result:Codable{
        var timezone : String
        var currently: Currently
        var daily: Daily
    }
    
    struct Currently: Codable{
        var temperature:Double
    }
    
    struct Daily: Codable{
        var summary: String
        var icon: String
    }
    
    var timezone = ""
    var temperature = 0
    var summary = ""
    var dailyIcon = ""
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
            self.temperature = Int(result.currently.temperature.rounded())
            self.summary = result.daily.summary
            self.dailyIcon = result.daily.icon
            
         }catch{
             print("JSON error: \(error.localizedDescription)")
         }
            completed()
         }
         task.resume()
     }
}
