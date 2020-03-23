 //
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by 张泽华 on 2020/3/8.
//  Copyright © 2020 张泽华. All rights reserved.
//

import UIKit
 
 class WeatherLocation: Codable {
    var name: String
    var latituide: Double
    var longitutde: Double
    
    init(name: String, latitude: Double, longtitude: Double) {
        self.name = name
        self.latituide = latitude
        self.longitutde = longtitude
    }
 
 }

