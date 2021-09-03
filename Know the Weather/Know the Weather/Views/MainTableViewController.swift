//
//  MainTableViewController.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/08/27.
//

import UIKit
import CoreLocation

class MainTableViewController: UITableViewController {
    private let mainTableViewModel = MainTableViewModel()
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?

    
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var conditionImage: UIImageView!
    @IBOutlet private weak var currentTempLabel: UILabel!
    @IBOutlet private weak var summaryLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "DaytimeBackground"))

        tableView.register(DailyWeatherTableViewCell.nib(), forCellReuseIdentifier: DailyWeatherTableViewCell.identifier)
        tableView.register(HourlyWeatherTableViewCell.nib(), forCellReuseIdentifier: HourlyWeatherTableViewCell.identifier)
        setupLocation()
    }
    
    //MARK: - Location
    
    private func setupLocation() {
        locationManager.delegate = self
        if locationManager.authorizationStatus == .denied {
            // Check for the weather in the default location set
        } else if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            } else {
                // Check for the weather in the default location set
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    private func requestWeatherForLocation(){
        guard let location = currentLocation else {
            return
        }
        mainTableViewModel.fetchWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                guard let current = self.mainTableViewModel.currentWeather else { return }
                self.currentTempLabel.text = "\(current.temp)°"
                self.summaryLabel.text = current.weather[0].description
                self.mainTableViewModel.currentCity(from: self.currentLocation!, completion: { city in
                    print("\n\(self.currentLocation!)\n")
                    print("\n\(city)\n")
                    self.locationLabel.text = city
                })
            }
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return mainTableViewModel.dailyCount
        }
    }

    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyWeatherTableViewCell.identifier, for: indexPath) as! HourlyWeatherTableViewCell
            cell.configure(with: mainTableViewModel.hourlyWeather)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DailyWeatherTableViewCell.identifier, for: indexPath) as! DailyWeatherTableViewCell
            cell.configure(with: mainTableViewModel.dailyWeather[indexPath.row])
            
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        return 80
    }
    
}

extension MainTableViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .denied && status != .notDetermined && CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        } else {
            // Check for the weather in the default location set
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil{
            print("\n\(locations)\n")
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
