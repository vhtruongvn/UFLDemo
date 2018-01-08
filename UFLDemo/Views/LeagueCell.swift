//
//  LeagueCell.swift
//  UFLDemo
//
//  Created by Truong Vo on 1/7/18.
//  Copyright © 2018 Truong Vo. All rights reserved.
//

import UIKit

class LeagueCell : UICollectionViewCell {
    
    @IBOutlet weak var leagueLogoImage: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    
    var leagueName: String {
        didSet {
            leagueNameLabel.text = leagueName.uppercased()
        }
    }
    
    var leagueLogoName: String {
        didSet {
            leagueLogoImage.image = UIImage(named: leagueLogoName)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            leagueNameLabel.textColor = isSelected ? UIColor.white : UIColor.white.withAlphaComponent(0.5)
            leagueLogoImage.alpha = isSelected ? 1 : 0.5
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.leagueName = ""
        self.leagueLogoName = ""
        super.init(coder: aDecoder)
    }
}

