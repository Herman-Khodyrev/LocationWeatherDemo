//
//  DailyWeatherTableViewCell.swift
//  LocationWeatherDemo
//
//  Created by Герман on 22.11.21.
//

import UIKit

class DailyWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconWeather: UIImageView!
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
