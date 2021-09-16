//
//  HourlyWeatherTableViewCell.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/03.
//

import UIKit

class HourlyWeatherTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var models = [Hourly]()
    private var model: Current?

    @IBOutlet private weak var collectionView: UICollectionView!
    
    static let identifier = "HourlyWeatherTableViewCell"
    
    static func nib() -> UINib {
        UINib(nibName: "HourlyWeatherTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(HourWeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: HourWeatherCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configure (with models: [Hourly], and model: Current) {
        self.models = models
        self.model = model
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourWeatherCollectionViewCell.identifier, for: indexPath) as! HourWeatherCollectionViewCell
        cell.configure(with: models[indexPath.row], currentSunriseTime: model!.sunrise, currentSunsetTime: model!.sunset)
        return cell
    }
    
}
