//
//  League.swift
//  UFLDemo
//
//  Created by Truong Vo on 1/6/18.
//  Copyright © 2018 Truong Vo. All rights reserved.
//

import Foundation

class League: NSObject {
    
    let id: String
    let name: String
    let leagueCode: String
    let region: String
    
    init(id: String, name: String, leagueCode: String, region: String) {
        self.id = id
        self.name = name
        self.leagueCode = leagueCode
        self.region = region
    }
    
}
