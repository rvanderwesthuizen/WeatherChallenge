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
    
    var currentSelectedLocation: CLLocation?
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var conditionImage: UIImageView!
    @IBOutlet private weak var currentTempLabel: UILabel!
    @IBOutlet private weak var summaryLabel: UILabel!
    @IBOutlet private weak var otherLocationsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activateActivityIndicator()
        
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "DaytimeBackground"))

        tableView.register(DailyWeatherTableViewCell.nib(), forCellReuseIdentifier: DailyWeatherTableViewCell.identifier)
        tableView.register(HourlyWeatherTableViewCell.nib(), forCellReuseIdentifier: HourlyWeatherTableViewCell.identifier)
        setupLocation()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(requestWeatherForLocation), for: .valueChanged)
    }
    
    @IBAction func didTapLocationButton(_ sender: UIButton) {
        setupLocation()
    }
    
    @IBAction func didTapOtherLocationsButton(_ sender: UIButton) {
        let locationsVC = LocationsTableViewController()
        locationsVC.checkIfLocationIsInList(location: currentSelectedLocation!)
        locationsVC.completion = { location in
            self.currentSelectedLocation = location
            self.requestWeatherForLocation()
        }
        let navVC = UINavigationController(rootViewController: locationsVC)
        present(navVC, animated: true)
    }
    
    //MARK: - Location
    
    private func setupLocation() {
        locationManager.delegate = self
        if locationManager.authorizationStatus == .denied {
            mainTableViewModel.fetchLastKnownLocation() { result in
                switch result {
                case .success(let location):
                    self.currentSelectedLocation = CLLocation(latitude: location.lat, longitude: location.lon)
                    self.requestWeatherForLocation()
                case .failure(let error):
                    self.displayErrorAlert("There was an error loading a default location: \(error)")
                }
            }
        } else if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            } else {
                mainTableViewModel.fetchLastKnownLocation() { result in
                    switch result {
                    case .success(let location):
                        self.currentSelectedLocation = CLLocation(latitude: location.lat, longitude: location.lon)
                        self.requestWeatherForLocation()
                    case .failure(let error):
                        self.displayErrorAlert("There was an error loading a default location: \(error)")
                    }
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    private func activateActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    @objc private func requestWeatherForLocation(){
        guard let location = currentSelectedLocation else {
            return
        }
        mainTableViewModel.fetchWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude) { result in
            switch result {
            case .failure(let error):
                self.displayErrorAlert("An error happened when fetching weather: \(error)")
            case .success(_):
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    guard let current = self.mainTableViewModel.currentWeather else { return }
                    self.conditionImage.image = UIImage(named: self.mainTableViewModel.conditionImage(conditionID: current.weather[0].id, model: current))
                    self.currentTempLabel.text = "\(current.temp)°"
                    self.summaryLabel.text = current.weather[0].description
                    self.mainTableViewModel.currentCity(from: self.currentSelectedLocation!, completion: { result in
                        switch result {
                        case .success(let city):
                            self.locationLabel.text = city
                        case .failure(let error):
                            self.displayErrorAlert("An error happened when trying to retrieve the location's name: \(error)")
                        }
                    })
                    if self.mainTableViewModel.dayTimeFlag(time: current.time,
                                                           sunriseTime: current.sunrise,
                                                           sunsetTime: current.sunset) {
                        self.tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "DaytimeBackground"))
                    } else {
                        self.tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "NightimeBackground"))
                    }
                    self.activityIndicator.stopAnimating()
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    private func displayErrorAlert(_ errorString: String){
        let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController, animated: true)
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
            cell.selectionStyle = .none
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension MainTableViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .denied && status != .notDetermined && CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        } else {
            mainTableViewModel.fetchLastKnownLocation() { result in
                switch result {
                case .success(let location):
                    self.currentSelectedLocation = CLLocation(latitude: location.lat, longitude: location.lon)
                    self.requestWeatherForLocation()
                case .failure(let error):
                    self.displayErrorAlert("There was an error loading a default location: \(error)")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentSelectedLocation == nil{
            currentSelectedLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
