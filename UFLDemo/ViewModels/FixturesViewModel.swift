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

    private var cellViewModels: [FixtureCellViewModel] = [FixtureCellViewModel]() {
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
    
    var numberOfCells: Int {
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
    
    func getCellViewModel(at indexPath: IndexPath) -> FixtureCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel(fixture: Fixture) -> FixtureCellViewModel {
        let homeTeamLogoName = fixture.homeTeam.shortName
        let homeTeamText = fixture.homeTeam.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeText = dateFormatter.string(from: fixture.gameDate)
        let awayTeamLogoName = fixture.awayTeam.shortName
        let awayTeamText = fixture.awayTeam.name
        
        return FixtureCellViewModel(homeTeamLogoName: homeTeamLogoName,
                                    homeTeamText: homeTeamText,
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
        self.cellViewModels = vms
    }
    
}

struct FixtureCellViewModel {
    let homeTeamLogoName: String
    let homeTeamText: String
    let timeText: String
    let awayTeamLogoName: String
    let awayTeamText: String
}
