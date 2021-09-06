//
//  LocationsTableViewController.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/06.
//

import UIKit
import CoreLocation

class LocationsTableViewController: UITableViewController {
    var completion: ((CLLocation) -> Void)?
    private lazy var locationTableViewModel = LocationsTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Previous Locations"
        
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "DaytimeBackground"))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func checkIfLocationIsInList(location: CLLocation) {
        locationTableViewModel.checkIfLocationIsInList(location: location) { result in
            switch result{
            case .success(let bool):
            if !bool {
                self.locationTableViewModel.addLocation(from: location) { result in
                    switch result{
                    case .success(_):
                        print()
                    case .failure(let error):
                        self.displayErrorAlert("An error happened while trying to retrieve the location's name: \(error)")
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            case .failure(let error):
                self.displayErrorAlert("An error happened while checking if the location exists: \(error)")
            }
        }
    }
    
    private func displayErrorAlert(_ errorString: String){
        let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationTableViewModel.counts
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = locationTableViewModel.locations[indexPath.row].cityName
        
        return cell
    }

}
