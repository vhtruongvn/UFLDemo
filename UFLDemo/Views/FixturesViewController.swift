//
//  FixturesViewController.swift
//  UFLDemo
//
//  Created by Truong Vo on 1/5/18.
//  Copyright © 2018 Truong Vo. All rights reserved.
//

import UIKit

class FixturesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var pullToRefresh: UIRefreshControl!
    var filterButton: UIButton!
    var isFilterMenuOpen = false
    
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
        pullToRefresh.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        pullToRefresh.tintColor = UIColor.white
        pullToRefresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        // Image BG
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.clear
    }
    
    func initVM() {
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.pullToRefresh.beginRefreshing()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 0.0
                    })
                }
                else {
                    self?.pullToRefresh.endRefreshing()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
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
        isFilterMenuOpen = !isFilterMenuOpen
        if isFilterMenuOpen {
            filterButton.setImage(UIImage(named: "icon_filter_selected"), for: .normal)
        }
        else {
            filterButton.setImage(UIImage(named: "icon_filter"), for: .normal)
        }
    }
    
    func showAlert(_ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension FixturesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
