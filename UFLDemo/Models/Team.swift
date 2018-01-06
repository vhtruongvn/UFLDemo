//
//  Team.swift
//  UFLDemo
//
//  Created by Truong Vo on 1/6/18.
//  Copyright © 2018 Truong Vo. All rights reserved.
//

import Foundation

class Team: NSObject {
    
    let id: String
    let name: String
    let shortName: String
    
    init(id: String, name: String, shortName: String) {
        self.id = id
        self.name = name
        self.shortName = shortName
    }
    
}
