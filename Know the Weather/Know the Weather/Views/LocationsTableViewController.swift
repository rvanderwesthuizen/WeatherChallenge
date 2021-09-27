//
//  LocationsTableViewController.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/06.
//

import UIKit
import CoreLocation

class LocationsTableViewController: UITableViewController {
    var completion: ((Location) -> Void)?
    private lazy var viewModel = LocationsTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Previous Locations"
        
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "DaytimeBackground"))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func checkIfLocationIsInList(location: CLLocation) {
        viewModel.checkIfLocationIsInList(location: location) { result in
            switch result{
            case .success(let bool):
            if bool == false {
                self.viewModel.addLocation(from: location) { result in
                    switch result{
                    case .success(_):
                        break
                    case .failure(let error):
                        self.displayErrorAlert("An error happened while trying to retrieve the location's name: \(error)")
                        return
                    }
                }
            }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
        return viewModel.counts
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let location = viewModel.location(at: indexPath.row) else { return UITableViewCell()}
        cell.textLabel?.text = location.cityName
        cell.backgroundColor = .clear
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let location = viewModel.location(at: indexPath.row) else { return }
        completion?(location)
        
        dismiss(animated: true, completion: nil)
    }

}
