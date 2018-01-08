//
//  FixturesViewModel.swift
//  UFLDemo
//
//  Created by Truong Vo on 1/6/18.
//  Copyright © 2018 Truong Vo. All rights reserved.
//

import Foundation

class FixturesViewModel {
    
    let apiService: APIServiceProtocol
    
    private var fixtures: [Fixture] = [Fixture]()

    private var cellViewModels: [DateSection] = [DateSection]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfSections: Int {
        return cellViewModels.count
    }
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func initFetch() {
        self.isLoading = true
        apiService.fetchAllFixtures { [weak self] (success, fixtures, error) in
            self?.isLoading = false
            if let error = error {
                self?.alertMessage = error.rawValue
            }
            else {
                self?.processFetchedFixtures(fixtures: fixtures)
            }
        }
    }
    
    func getNumberOfCellViewModels(at section: Int) -> Int {
        return cellViewModels[section].leagueFixtures.count
    }
    
    func getSectionTitle(at section: Int) -> String {
        return cellViewModels[section].dateText
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> FixtureCellViewModel {
        return cellViewModels[indexPath.section].leagueFixtures[indexPath.row]
    }
    
    // Apply filter on the cached fixtures
    func applyFilter(leagueIds: [Int]) {
        var filteredFixtures = [Fixture]()
        for fixture in self.fixtures {
            if leagueIds.contains(0) || leagueIds.contains(fixture.league.id) {
                filteredFixtures.append(fixture)
            }
        }
        groupFetchexFixturesByDateAndLeague(filteredFixtures)
    }
    
    func createCellViewModel(fixture: Fixture) -> FixtureCellViewModel {
        let homeTeamLogoName = fixture.homeTeam.shortName
        let homeTeamText = fixture.homeTeam.name
        let dateText = fixture.gameDateTime.formatGameDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeText = dateFormatter.string(from: fixture.gameDateTime)
        let awayTeamLogoName = fixture.awayTeam.shortName
        let awayTeamText = fixture.awayTeam.name
        
        return FixtureCellViewModel(isLeagueCell: false,
                                    leagueLogoName: fixture.league.region,
                                    leagueName: fixture.league.name,
                                    homeTeamLogoName: homeTeamLogoName,
                                    homeTeamText: homeTeamText,
                                    dateText: dateText,
                                    timeText: timeText,
                                    awayTeamLogoName: awayTeamLogoName,
                                    awayTeamText: awayTeamText)
    }
    
    private func processFetchedFixtures(fixtures: [Fixture]) {
        let sortedFixtures = fixtures.sorted(by: {$0.gameDateTime.compare($1.gameDateTime) == .orderedAscending})
        self.fixtures = sortedFixtures // cache
        groupFetchexFixturesByDateAndLeague(sortedFixtures)
    }
    
    private func groupFetchexFixturesByDateAndLeague(_ fixtures: [Fixture]) {
        var vms = [FixtureCellViewModel]()
        for fixture in fixtures {
            vms.append(createCellViewModel(fixture: fixture))
        }
        
        let groupedVMSByDate = vms.groupBy { $0.dateText } // group fixtures by date
        print("--> Group by date [\(groupedVMSByDate.count)] items \(groupedVMSByDate)")
        
        var groupedVMSByDateAndLeague = [DateSection]()
        for gVMS in groupedVMSByDate {
            let groupedLeagueVMS = gVMS.groupBy { $0.leagueName }
            
            var allLeagueFixturesPerDate = [FixtureCellViewModel]()
            for glVMS in groupedLeagueVMS {
                // this cell view model is to display the league name only
                let fixtureCVM = FixtureCellViewModel(isLeagueCell: true,
                                                      leagueLogoName: glVMS[0].leagueLogoName,
                                                      leagueName: glVMS[0].leagueName,
                                                      homeTeamLogoName: "",
                                                      homeTeamText: "",
                                                      dateText: "",
                                                      timeText: "",
                                                      awayTeamLogoName: "",
                                                      awayTeamText: "")
                allLeagueFixturesPerDate.append(fixtureCVM)
                allLeagueFixturesPerDate.append(contentsOf: glVMS)
            }
            
            let dateSection = DateSection(dateText: gVMS[0].dateText, leagueFixtures: allLeagueFixturesPerDate)
            groupedVMSByDateAndLeague.append(dateSection)
        }
        print("--> Group by date & league [\(groupedVMSByDateAndLeague.count)] items \(groupedVMSByDateAndLeague)")
        
        self.cellViewModels = groupedVMSByDateAndLeague
    }
    
}

struct DateSection {
    let dateText: String
    var leagueFixtures: [FixtureCellViewModel]
}

struct FixtureCellViewModel {
    var isLeagueCell: Bool
    let leagueLogoName: String
    let leagueName: String
    let homeTeamLogoName: String
    let homeTeamText: String
    let dateText: String
    let timeText: String
    let awayTeamLogoName: String
    let awayTeamText: String
}
