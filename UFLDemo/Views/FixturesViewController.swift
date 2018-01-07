//
//  FixturesViewController.swift
//  UFLDemo
//
//  Created by Truong Vo on 1/5/18.
//  Copyright © 2018 Truong Vo. All rights reserved.
//

import UIKit

let filterMenuHeight: CGFloat = 64
let headerSectionHeight: CGFloat = 44
let cellHeight: CGFloat = 50

class FixturesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var leagueFilterContainer: UIView!
    @IBOutlet weak var leagueFilterContainerTopConstraint: NSLayoutConstraint!
    var pullToRefresh: UIRefreshControl!
    var filterButton: UIButton!
    var isFilterMenuDisplayed = false
    var animatingFilterMenu: Bool = false
    var firstLoad: Bool = true
    var leagueFilterViewController: LeagueFilterViewController?
    
    lazy var viewModel: FixturesViewModel = {
        return FixturesViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init the static view
        initView()
        
        // Init view model
        initVM()
    }
    
    func initView() {
        self.navigationItem.title = "Games"
        
        // Nav Bar's Left Button
        let btnMenu: UIButton = UIButton()
        btnMenu.setImage(UIImage(named: "icon_menu"), for: .normal)
        btnMenu.addTarget(self, action: #selector(menuButtonTapped(_:)), for: .touchUpInside)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        btnMenu.contentHorizontalAlignment = .left
        btnMenu.showsTouchWhenHighlighted = true
        let menuBarButton = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = menuBarButton
        
        // Nav Bar's Right Buttons
        filterButton = UIButton()
        filterButton.setImage(UIImage(named: "icon_filter"), for: .normal)
        filterButton.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        filterButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        filterButton.contentHorizontalAlignment = .right
        filterButton.showsTouchWhenHighlighted = true
        let filterBarButton = UIBarButtonItem(customView: filterButton)
        navigationItem.rightBarButtonItem = filterBarButton
        
        // Pull to refresh
        pullToRefresh = UIRefreshControl()
        tableView.addSubview(pullToRefresh)
        pullToRefresh.tintColor = UIColor.white
        pullToRefresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        // Image BG
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.clear
        
        // League Filter
        leagueFilterContainer.dropShadow()
    }
    
    func initVM() {
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(message)
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    if self!.firstLoad {
                        self!.firstLoad = false
                        self?.tableView.alpha = 0
                        self?.loadingIndicatorView.startAnimating()
                    }
                    else {
                        self?.pullToRefresh.beginRefreshing()
                    }
                }
                else {
                    self?.tableView.alpha = 1
                    self?.loadingIndicatorView.stopAnimating() // if loading
                    self?.pullToRefresh.endRefreshing()
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.initFetch()
    }
    
    @objc func refreshData() {
        viewModel.initFetch()
    }
    
    @objc func menuButtonTapped(_ sender: AnyObject) {
        
    }
    
    @objc func filterButtonTapped(_ sender: AnyObject) {
        isFilterMenuDisplayed = !isFilterMenuDisplayed
        if isFilterMenuDisplayed {
            filterButton.setImage(UIImage(named: "icon_filter_selected"), for: .normal)
            showFilterMenu()
        }
        else {
            filterButton.setImage(UIImage(named: "icon_filter"), for: .normal)
            hideFilterMenu()
        }
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideFilterMenu() {
        let yAlign: CGFloat = -filterMenuHeight
        self.animateDropDownToFrame(y: yAlign, tableEdgeInsetTop: 0) {
            self.isFilterMenuDisplayed = false
        }
    }
    
    func showFilterMenu() {
        let yAlign: CGFloat = 0.0
        self.animateDropDownToFrame(y: yAlign, tableEdgeInsetTop: filterMenuHeight) {
            self.isFilterMenuDisplayed = true
        }
    }
    
    func animateDropDownToFrame(y: CGFloat, tableEdgeInsetTop: CGFloat, completion:@escaping () -> Void) {
        if !self.animatingFilterMenu {
            self.animatingFilterMenu = true
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: { () -> Void in
                self.leagueFilterContainerTopConstraint.constant = y // change the position of filter menu
                self.tableView.contentInset = UIEdgeInsetsMake(tableEdgeInsetTop, 0, 0, 0)
                self.view.layoutIfNeeded() // essential for animation carry out if not view changes suddenly
            }, completion: { (completed: Bool) -> Void in
                self.animatingFilterMenu = false
                if (completed) {
                    completion()
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedFilterMenu" {
            if let viewController = segue.destination as? LeagueFilterViewController {
                self.leagueFilterViewController = viewController
                self.leagueFilterViewController?.delegate = self
            }
        }
    }

}

extension FixturesViewController: LeagueFilterViewControllerDelegate {
    
    func filterApplied(leagueIds: [Int]) {
        print(leagueIds)
        viewModel.applyFilter(leagueIds: leagueIds)
    }
    
}

extension FixturesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerSectionHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "sectionHeader") as? FixtureTableViewSectionHeader else {
            fatalError("Cell not exists in storyboard")
        }
        
        cell.dateLabel.text = viewModel.getSectionTitle(at: section)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfCellViewModels(at: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "fixtureCellIdentifier", for: indexPath) as? FixtureTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        
        cell.homeTeamNameLabel.text = cellVM.homeTeamText
        cell.timeLabel.text = cellVM.timeText
        cell.awayTeamNameLabel.text = cellVM.awayTeamText
        
        return cell
    }
    
}
