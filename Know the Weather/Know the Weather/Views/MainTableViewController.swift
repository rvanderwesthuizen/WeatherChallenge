//
//  MainTableViewController.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/08/27.
//

import UIKit
import CoreLocation

class MainTableViewController: UITableViewController {
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    //MARK: - Table view delegate
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
