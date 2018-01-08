//
//  LeagueTableViewCell.swift
//  UFLDemo
//
//  Created by Truong Vo on 1/7/18.
//  Copyright © 2018 Truong Vo. All rights reserved.
//

import UIKit

class LeagueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leagueLogoImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    
    var leagueName: String {
        didSet {
            leagueNameLabel.text = leagueName
        }
    }
    
    var leagueLogoName: String {
        didSet {
            leagueLogoImageView.image = UIImage(named: leagueLogoName)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.leagueName = ""
        self.leagueLogoName = ""
        super.init(coder: aDecoder)
    }
    
}
