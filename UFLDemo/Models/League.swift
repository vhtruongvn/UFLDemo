//
//  League.swift
//  UFLDemo
//
//  Created by Truong Vo on 1/6/18.
//  Copyright © 2018 Truong Vo. All rights reserved.
//

import Foundation

class League: NSObject {
    
    let id: Int
    let name: String
    let region: String
    
    init(id: Int, name: String, region: String) {
        self.id = id
        self.name = name
        self.region = region
    }
    
}
