//
//  LocationDetailViewController.swift
//  WeatherGift
//
//  Created by 张泽华 on 2020/3/23.
//  Copyright © 2020 张泽华. All rights reserved.
//

import UIKit

class LocationDetailViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //var weatherLocation: WeatherLocation!
    var locationIndex = 0
    //var weatherDetail: WeatherDetail!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

          updateUserInterface()
    }
    

    
    func updateUserInterface(){
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        let weatherLocation = pageViewController.weatherLocations[locationIndex]
        let weatherDetail = WeatherDetail(name: weatherLocation.name, latitude: weatherLocation.latituide, longtitude: weatherLocation.longitutde)
        dateLabel.text = ""
        placeLabel.text = weatherLocation.name
        temperatureLabel.text = "--°"
        summaryLabel.text = ""
        pageControl.numberOfPages = pageViewController.weatherLocations.count
        pageControl.currentPage = locationIndex
        weatherDetail.getData{
            DispatchQueue.main.async {
                self.dateLabel.text = weatherDetail.timezone
                self.placeLabel.text = weatherLocation.name
                self.temperatureLabel.text = "\(weatherDetail.temperature)°"
                self.summaryLabel.text = weatherDetail.summary
                self.imageView.image = UIImage(named: weatherDetail.dailyIcon)
            }
           
        }
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        let destination = segue.destination as! LocationListViewController
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        destination.weatherLocations = pageViewController.weatherLocations
    }
    
    @IBAction func unwindFromLocationListViewController(segue: UIStoryboardSegue){
        let source = segue.source as! LocationListViewController
        locationIndex = source.selectedLocationIndex
        
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController

        
        pageViewController.weatherLocations = source.weatherLocations
        pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: locationIndex)], direction: .forward, animated: false, completion: nil)
    }
    
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        
        var direction : UIPageViewController.NavigationDirection = .forward
        if sender.currentPage < locationIndex{
            direction = .reverse
        }
        pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: sender.currentPage)], direction: .forward, animated: true, completion: nil)

    }
    
}
