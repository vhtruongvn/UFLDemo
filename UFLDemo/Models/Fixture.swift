//
//  Fixture.swift
//  UFLDemo
//
//  Created by Truong Vo on 1/6/18.
//  Copyright © 2018 Truong Vo. All rights reserved.
//

import Foundation

class Fixture: NSObject {
    
    let id: Int
    let gameDateTime: Date
    let league: League
    let homeTeam: Team
    let awayTeam: Team
    
    init(id: Int, gameDateTime: Date, league: League, homeTeam: Team, awayTeam: Team) {
        self.id = id
        self.gameDateTime = gameDateTime
        self.league = league
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
    }
    
}
