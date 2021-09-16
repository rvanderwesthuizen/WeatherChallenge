//
//  CurrentWeatherDetailsTableViewController.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/08.
//

import UIKit

class WeatherDetailsTableViewController: UITableViewController {
    var isDay: Bool?
    var current: Current?
    var daily: [Daily]?
    var index: Int = 0
    var conditionImageString: String?
    var scope: WeatherScope?
    
    @IBOutlet private weak var conditionImageView: UIImageView!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var feelsLikeLabel: UILabel!
    @IBOutlet private weak var summaryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let dayTimeCheck = isDay else { return }
        guard let imageString = conditionImageString else { return }
        tableView.backgroundView = (dayTimeCheck ? UIImageView(image: #imageLiteral(resourceName: "DaytimeBackground")) : UIImageView(image: #imageLiteral(resourceName: "NightimeBackground")))
        tableView.register(DetailWeatherTableViewCell.nib, forCellReuseIdentifier: DetailWeatherTableViewCell.identifier)
        
        switch scope {
        case .current(let current):
            title = getTitleFromDate(Date(timeIntervalSince1970: Double(current.time)))
            tempLabel.text = "\(current.temp)°"
            feelsLikeLabel.text = "Feels: \(current.feelsLike)°"
            summaryLabel.text = current.weather[0].description
            conditionImageView.image = UIImage(named: imageString)
        case .daily(_):
            guard let weather = daily else { return }
            title = getTitleFromDate(Date(timeIntervalSince1970: Double(weather[index].time)))
            tempLabel.text = "\(weather[index].temp.day)°"
            feelsLikeLabel.text = "Feels: \(weather[index].feelsLike.day)°"
            summaryLabel.text = weather[index].weather[0].description
            conditionImageView.image = UIImage(named: imageString)
        case .none:
            return
        }
    }
    
    func getTitleFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailWeatherTableViewCell.identifier, for: indexPath) as! DetailWeatherTableViewCell

        cell.configureWith(scope: scope!, day: daily![index], index: indexPath.row)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

 }
