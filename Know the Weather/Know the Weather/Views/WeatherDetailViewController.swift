//
//  WeatherDetailViewController.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/16.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    var scope: WeatherScope?
    var isDay: Bool?
    var conditionImageString: String?
    var chanceOfRainToday: String?
    
    private let viewModel = WeatherDetailViewModel()
    
    @IBOutlet private weak var conditionImageView: UIImageView!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var feelsLikeLabel: UILabel!
    @IBOutlet private weak var summaryLabel: UILabel!
    @IBOutlet private weak var feelsLikeInfoLabel: UILabel!
    @IBOutlet private weak var windInfoLabel: UILabel!
    @IBOutlet private weak var pressureInfoLabel: UILabel!
    @IBOutlet private weak var chanceOfRainInfoLabel: UILabel!
    @IBOutlet private weak var humidityInfoLabel: UILabel!
    @IBOutlet private weak var cloudsInfoLabel: UILabel!
    @IBOutlet private weak var sunriseInfoLabel: UILabel!
    @IBOutlet private weak var sunsetInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let dayTimeCheck = isDay else { return }
        guard let imageString = conditionImageString else { return }
        view.backgroundColor = (dayTimeCheck ? UIColor(patternImage: #imageLiteral(resourceName: "DaytimeBackground")) : UIColor(patternImage: #imageLiteral(resourceName: "NighttimeBackground")))
        
        setupHeaderLabels(with: imageString)
        setupInfoLabels()
        
    }
    
    private func setupHeaderLabels(with imageString: String) {
        switch scope {
        case .current(let current):
            title = viewModel.getTitleFromDate(Date(timeIntervalSince1970: Double(current.time)))
            conditionImageView.image = UIImage(named: imageString)
            viewModel.setupHeaderLabelsText(with: current)
        case .daily(let dayWeather):
            title = viewModel.getTitleFromDate(Date(timeIntervalSince1970: Double(dayWeather.time)))
            conditionImageView.image = UIImage(named: imageString)
            viewModel.setupHeaderLabelsText(with: dayWeather)
        case .none:
            return
        }
        tempLabel.text = viewModel.tempInfo
        feelsLikeLabel.text = viewModel.feelsLikeInfo
        summaryLabel.text = viewModel.summary
    }
    
    private func setupInfoLabels() {
        switch scope {
        case .current(let weatherInfo):
            viewModel.setupInfoLabelsText(with: weatherInfo, chanceOfRain: chanceOfRainToday!)
        case .daily(let weatherInfo):
            viewModel.setupInfoLabelsText(with: weatherInfo)
        case .none:
            return
        }
        
        feelsLikeInfoLabel.text = viewModel.feelsLikeInfo
        windInfoLabel.text = viewModel.windInfo
        pressureInfoLabel.text = viewModel.pressureInfo
        chanceOfRainInfoLabel.text = viewModel.chanceOfRainInfo
        humidityInfoLabel.text = viewModel.humidityInfo
        cloudsInfoLabel.text = viewModel.cloudsInfo
        sunriseInfoLabel.text = viewModel.sunriseInfo
        sunsetInfoLabel.text = viewModel.sunsetInfo
        
    }
}
