//
//  FixtureTableViewCell.swift
//  UFLDemo
//
//  Created by Truong Vo on 1/6/18.
//  Copyright © 2018 Truong Vo. All rights reserved.
//

import UIKit

class FixtureTableViewCell: UITableViewCell {
    
    @IBOutlet weak var homeTeamLogoImageView: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var awayTeamLogoImageView: UIImageView!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    
    var homeTeamLogoName: String {
        didSet {
            homeTeamLogoImageView.image = UIImage(named: homeTeamLogoName)
        }
    }
    
    var homeTeamName: String {
        didSet {
            homeTeamNameLabel.text = homeTeamName
        }
    }
    
    var timeText: String {
        didSet {
            timeLabel.text = timeText
        }
    }
    
    var awayTeamLogoName: String {
        didSet {
            awayTeamLogoImageView.image = UIImage(named: awayTeamLogoName)
        }
    }
    
    var awayTeamName: String {
        didSet {
            awayTeamNameLabel.text = awayTeamName
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.homeTeamLogoName = ""
        self.homeTeamName = ""
        self.timeText = ""
        self.awayTeamLogoName = ""
        self.awayTeamName = ""
        super.init(coder: aDecoder)
    }
    
}
