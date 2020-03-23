//
//  WeatherDetail.swift
//  WeatherGift
//
//  Created by 张泽华 on 2020/3/24.
//  Copyright © 2020 张泽华. All rights reserved.
//

import Foundation
class WeatherDetail: WeatherLocation{
    func getData(){
         let coordinates = "\(latituide),\(longitutde)"
         let urlString = "https://api.darksky.net/forecast/0123456789abcdef9876543210fedcba/42.3601,-71.0589"

         print("we are accessing the url \(urlString)")
         guard let url = URL(string: urlString) else{
             print("error. cannot create a url form \(urlString)")
             return
         }
         let session = URLSession.shared
         
         let task = session.dataTask(with: url){(data, response, error) in
             if let error = error{
                 print("error \(error.localizedDescription)")
             }
             
         
         do{
             let json = try JSONSerialization.jsonObject(with: data!, options: [])
             print("\(json)")
         }catch{
             print("JSON error: \(error.localizedDescription)")
         }
         }
         task.resume()
     }
}
