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

    private var cellViewModels: [[FixtureCellViewModel]] = [[FixtureCellViewModel]]() {
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
        return cellViewModels[section].count
    }
    
    func getSectionTitle(at section: Int) -> String {
        return cellViewModels[section][0].dateText
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> FixtureCellViewModel {
        return cellViewModels[indexPath.section][indexPath.row]
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
        
        return FixtureCellViewModel(homeTeamLogoName: homeTeamLogoName,
                                    homeTeamText: homeTeamText,
                                    dateText: dateText,
                                    timeText: timeText,
                                    awayTeamLogoName: awayTeamLogoName,
                                    awayTeamText: awayTeamText)
    }
    
    private func processFetchedFixtures(fixtures: [Fixture]) {
        self.fixtures = fixtures // cache
        var vms = [FixtureCellViewModel]()
        for fixture in fixtures {
            vms.append(createCellViewModel(fixture: fixture))
        }
        let groupedVMS = vms.groupBy { $0.dateText }
        print(groupedVMS)
        self.cellViewModels = groupedVMS
    }
    
}

struct FixtureCellViewModel {
    let homeTeamLogoName: String
    let homeTeamText: String
    let dateText: String
    let timeText: String
    let awayTeamLogoName: String
    let awayTeamText: String
}
