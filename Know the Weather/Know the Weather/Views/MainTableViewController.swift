//
//  MainTableViewController.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/08/27.
//

import UIKit
import CoreLocation

class MainTableViewController: UITableViewController {
    private let viewModel = MainTableViewModel()
    
    @IBOutlet private weak var currentWeatherView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var conditionImage: UIImageView!
    @IBOutlet private weak var currentTempLabel: UILabel!
    @IBOutlet private weak var summaryLabel: UILabel!
    @IBOutlet private weak var otherLocationsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCurrentWeather))
        currentWeatherView.addGestureRecognizer(tap)
        
        viewModel.setDefaultLocation(location: CLLocation(latitude: +37.33233141, longitude: -122.03121860))
        
        viewModel.delegate = self
        viewModel.registerLocalNotification()
        activateActivityIndicator()
        
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "DaytimeBackground"))
        
        tableView.register(DailyWeatherTableViewCell.nib(), forCellReuseIdentifier: DailyWeatherTableViewCell.identifier)
        tableView.register(HourlyWeatherTableViewCell.nib(), forCellReuseIdentifier: HourlyWeatherTableViewCell.identifier)
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(viewModel.self, action: #selector(viewModel.fetchWeather), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc private func didTapCurrentWeather() {
        guard let current = viewModel.currentWeather else { return }
        viewModel.scope = WeatherScope.current(current)
        navigateToWeatherDetailViewController()
    }
    
    @IBAction func didTapLocationButton(_ sender: UIButton) {
        viewModel.setupLocation()
    }
    
    @IBAction func didTapOtherLocationsButton(_ sender: UIButton) {
        let locationsVC = LocationsTableViewController()
        locationsVC.checkIfLocationIsInList(location: viewModel.currentSelectedLocation!)
        locationsVC.completion = { location in
            self.viewModel.currentSelectedLocation = CLLocation(latitude: location.lat, longitude: location.lon)
            self.viewModel.fetchWeather()
        }
        let navVC = UINavigationController(rootViewController: locationsVC)
        present(navVC, animated: true)
    }
    
    func navigateToWeatherDetailViewController() {
        if let weatherDetailVC = storyboard?.instantiateViewController(identifier: "WeatherDetail") as? WeatherDetailViewController {
            weatherDetailVC.conditionImageString = viewModel.conditionImage()
            weatherDetailVC.isDay = viewModel.isDayTime
            weatherDetailVC.scope = viewModel.scope
            weatherDetailVC.chanceOfRainToday = "\(viewModel.percentageChanceOfRain)%"
            navigationController?.pushViewController(weatherDetailVC, animated: true)
        }
    }
    
    private func activateActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    private func setupLabels() {
        self.currentTempLabel.text = viewModel.currentTemp
        self.summaryLabel.text = viewModel.currentWeatherDescription
        
        self.viewModel.currentCity() { result in
            switch result {
            case .success(let city):
                self.locationLabel.text = city
            case .failure(let error):
                self.displayErrorAlert(errorString: "An error occurred when trying to retrieve the location's name. ", error: error)
            }
        }
    }
    
    private func displayErrorAlert(errorString: String, error: Error){
        var alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Error", style: .default, handler: { (action) in
            alertController = UIAlertController(title: "Display error", message: "\(error)", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
        }))
        present(alertController, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : viewModel.dailyCount
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyWeatherTableViewCell.identifier, for: indexPath) as! HourlyWeatherTableViewCell
            guard let current = viewModel.currentWeather else { return UITableViewCell()}
            guard let daySunrise = viewModel.dailyWeatherSunrise(at: 1) else { return UITableViewCell() }
            cell.configure(with: viewModel.hourlyWeather, current: current, nextDaySunrise: daySunrise)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DailyWeatherTableViewCell.identifier, for: indexPath) as! DailyWeatherTableViewCell
            guard let weather = viewModel.dailyWeather(at: indexPath.row) else { return UITableViewCell() }
            viewModel.scope = WeatherScope.daily(weather)
            cell.configure(with: weather, conditionImageString: viewModel.conditionImage())
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 0 ? 100 : 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let day = viewModel.dailyWeather(at: indexPath.row) else { return }
        viewModel.scope = WeatherScope.daily(day)
        navigateToWeatherDetailViewController()
    }
    
}

extension MainTableViewController: MainTableViewModelDelegate {
    func didFetchWeather() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            guard let current = self.viewModel.currentWeather else { return }
            self.viewModel.scope = WeatherScope.current(current)
            self.conditionImage.image = UIImage(named: self.viewModel.conditionImage())
            
            self.setupLabels()
            
            if current.isDayTime == false {
                self.tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "NighttimeBackground"))
            }
            self.activityIndicator.stopAnimating()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func didFailWithError(errorString: String, error: Error) {
        displayErrorAlert(errorString: errorString, error: error)
    }
}
