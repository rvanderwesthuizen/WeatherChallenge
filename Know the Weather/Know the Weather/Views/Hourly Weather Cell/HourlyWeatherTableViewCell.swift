//
//  HourlyWeatherTableViewCell.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/03.
//

import UIKit

class HourlyWeatherTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var hourly = [Hourly]()
    private var current: Current?
    private var nextDaySunrise: Int?

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
    
    func configure (with hourly: [Hourly], current: Current, nextDaySunrise: Int) {
        self.hourly = hourly
        self.current = current
        self.nextDaySunrise = nextDaySunrise
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hourly.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourWeatherCollectionViewCell.identifier, for: indexPath) as! HourWeatherCollectionViewCell
        cell.configure(with: hourly[indexPath.row], currentSunriseTime: current!.sunrise, currentSunsetTime: current!.sunset, nextDaySunriseTime: nextDaySunrise!)
        return cell
    }
    
}
