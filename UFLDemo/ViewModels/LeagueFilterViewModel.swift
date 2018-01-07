//
//  LeagueFilterViewModel.swift
//  UFLDemo
//
//  Created by Truong Vo on 1/7/18.
//  Copyright © 2018 Truong Vo. All rights reserved.
//

import Foundation

class LeagueFilterViewModel {
    
    let apiService: APIServiceProtocol
    
    private var leagues: [League] = [League]()
    
    private var cellViewModels: [LeagueCellViewModel] = [LeagueCellViewModel]() {
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
        apiService.fetchAllLeagues { [weak self] (success, leagues, error) in
            self?.isLoading = false
            if let error = error {
                self?.alertMessage = error.rawValue
            }
            else {
                self?.processFetchedLeagues(leagues: leagues)
            }
        }
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> LeagueCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel(league: League) -> LeagueCellViewModel {
        let leagueLogoName = league.region
        let leagueText = league.name
        
        return LeagueCellViewModel(leagueLogoName: leagueLogoName,
                                   leagueText: leagueText)
    }
    
    private func processFetchedLeagues(leagues: [League]) {
        self.leagues = leagues // cache
        var vms = [LeagueCellViewModel]()
        for league in leagues {
            vms.append(createCellViewModel(league: league))
        }
        self.cellViewModels = vms
    }
    
}

struct LeagueCellViewModel {
    let leagueLogoName: String
    let leagueText: String
}
