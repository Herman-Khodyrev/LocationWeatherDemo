//
//  CurrentWeatherTableViewCell.swift
//  LocationWeatherDemo
//
//  Created by Герман on 22.11.21.
//

import UIKit

class CurrentWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconWeather: UIImageView!
    @IBOutlet weak var labelTemperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
