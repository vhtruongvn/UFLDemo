//
//  LeagueFilterViewModel.swift
//  UFLDemo
//
//  Created by Truong Vo on 1/7/18.
//  Copyright © 2018 Truong Vo. All rights reserved.
//

import Foundation

let AllLeaguesId = 0

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
    
    func selectCellViewModel(at indexPath: IndexPath) -> LeagueCellViewModel {
        let cellVM = cellViewModels[indexPath.row]
        
        // "All Leagues" is selected
        if cellVM.id == AllLeaguesId {
            if cellVM.isSelected {
                // "All Leagues" is already selected
            }
            else {
                cellViewModels = cellViewModels.map { (leagueCellViewModel: LeagueCellViewModel) -> LeagueCellViewModel in
                    var mutableCellVM = leagueCellViewModel
                    mutableCellVM.isSelected = leagueCellViewModel.id == AllLeaguesId ? true : false
                    return mutableCellVM
                }
            }
        }
        else {
            // other league is selected
            cellViewModels[0].isSelected = false // un-select "All Leagues"
            cellViewModels[indexPath.row].isSelected = !cellViewModels[indexPath.row].isSelected
        }
        
        return cellVM
    }
    
    func getSelectedLeagueIds() -> [Int] {
        var leagueIds = [Int]()
        for cellVM in cellViewModels {
            if cellVM.isSelected {
                leagueIds.append(cellVM.id)
            }
        }
        return leagueIds
    }
    
    func createCellViewModel(league: League) -> LeagueCellViewModel {
        let leagueLogoName = league.region
        let leagueText = league.name
        let selected = league.id == AllLeaguesId ? true : false // "All Leagues" is selected by default
        
        return LeagueCellViewModel(leagueLogoName: leagueLogoName,
                                   leagueText: leagueText,
                                   id: league.id,
                                   isSelected: selected)
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
    let id: Int
    var isSelected: Bool
}
