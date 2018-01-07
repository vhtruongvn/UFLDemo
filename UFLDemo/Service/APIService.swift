//
//  APIService.swift
//  UFLDemo
//
//  Created by Truong Vo on 1/6/18.
//  Copyright © 2018 Truong Vo. All rights reserved.
//

import Foundation

enum APIError: String, Error {
    case noNetwork = "No network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

protocol APIServiceProtocol {
    func fetchAllLeagues(complete: @escaping (_ success: Bool, _ leagues: [League], _ error: APIError? ) -> ())
    func fetchAllFixtures(complete: @escaping (_ success: Bool, _ fixtures: [Fixture], _ error: APIError? ) -> ())
}

class APIService: APIServiceProtocol {
    
    func fetchAllLeagues(complete: @escaping (_ success: Bool, _ leagues: [League], _ error: APIError? ) -> ()) {
        DispatchQueue.global().async {
            sleep(1) // simulate a long waiting for fetching
            
            do {
                if let file = Bundle.main.url(forResource: "leagues", withExtension: "json") {
                    let data = try Data(contentsOf: file)
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let object = json as? [String: Any] {
                        let leagueObjects = object["data"] as! [[String: Any]]
                        print(leagueObjects)
                        var leagues = [League]()
                        for leagueObject in leagueObjects {
                            let leagueId = leagueObject["id"] as! Int
                            let leagueName = leagueObject["name"] as! String
                            let leagueRegion = leagueObject["region"] as! String
                            
                            let league = League(id: leagueId, name: leagueName, region: leagueRegion)
                            leagues.append(league)
                        }
                        complete(true, leagues, nil)
                    }
                    else {
                        print("JSON is invalid")
                        complete(false, [], nil)
                    }
                }
                else {
                    print("File not found")
                    complete(false, [], nil)
                }
            }
            catch {
                print(error.localizedDescription)
                complete(false, [], nil)
            }
        }
    }
    
    func fetchAllFixtures(complete: @escaping (_ success: Bool, _ fixtures: [Fixture], _ error: APIError? ) -> ()) {
        DispatchQueue.global().async {
            sleep(3) // simulate a long waiting for fetching
            
            do {
                if let file = Bundle.main.url(forResource: "fixtures", withExtension: "json") {
                    let data = try Data(contentsOf: file)
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let object = json as? [String: Any] {
                        let fixtureObjects = object["data"] as! [[String: Any]]
                        print(fixtureObjects)
                        var fixtures = [Fixture]()
                        for fixtureObject in fixtureObjects {
                            let fixtureId = fixtureObject["id"] as! Int
                            
                            let dateString = fixtureObject["gameDate"] as! String
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // 2015-08-08T14:00:00+0000
                            let gameDateTime = dateFormatter.date(from: dateString)
                            
                            let leagueObject = fixtureObject["league"] as! [String: Any]
                            let leagueId = leagueObject["id"] as! Int
                            let leagueName = leagueObject["name"] as! String
                            let leagueRegion = leagueObject["region"] as! String
                            let league = League(id: leagueId, name: leagueName, region: leagueRegion)
                            
                            let teamsObject = fixtureObject["teams"] as! [String: Any]
                            let homeTeamObject = teamsObject["home"] as! [String: Any]
                            let homeTeamId = homeTeamObject["id"] as! Int
                            let homeTeamName = homeTeamObject["name"] as! String
                            let homeTeamShortName = homeTeamObject["shortName"] as! String
                            let homeTeam = Team(id: homeTeamId, name: homeTeamName, shortName: homeTeamShortName)
                            
                            let awayTeamObject = teamsObject["away"] as! [String: Any]
                            let awayTeamId = awayTeamObject["id"] as! Int
                            let awayTeamName = awayTeamObject["name"] as! String
                            let awayTeamShortName = awayTeamObject["shortName"] as! String
                            let awayTeam = Team(id: awayTeamId, name: awayTeamName, shortName: awayTeamShortName)
                            
                            let fixture = Fixture(id: fixtureId, gameDateTime: gameDateTime!, league: league, homeTeam: homeTeam, awayTeam: awayTeam)
                            fixtures.append(fixture)
                        }
                        complete(true, fixtures, nil)
                    }
                    else {
                        print("JSON is invalid")
                        complete(false, [], nil)
                    }
                }
                else {
                    print("File not found")
                    complete(false, [], nil)
                }
            }
            catch {
                print(error.localizedDescription)
                complete(false, [], nil)
            }
        }
    }
    
}
