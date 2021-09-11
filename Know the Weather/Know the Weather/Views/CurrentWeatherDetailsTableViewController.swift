//
//  CurrentWeatherDetailsTableViewController.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/08.
//

import UIKit

class CurrentWeatherDetailsTableViewController: UITableViewController {
    var isDay: Bool?
    var currentWeather: Current?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let dayTimeCheck = isDay else { return }
        tableView.backgroundView = (dayTimeCheck ? UIImageView(image: #imageLiteral(resourceName: "DaytimeBackground")) : UIImageView(image: #imageLiteral(resourceName: "NightimeBackground")))
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
