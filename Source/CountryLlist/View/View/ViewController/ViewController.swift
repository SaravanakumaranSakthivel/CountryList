//
//  ViewController.swift
//  CountryList
//
//  Created by Saravanakumaran Sakthivel on 3/17/24.
//

import UIKit

protocol CountryListType {
    func reloadTable(contryList: [Country])
    func showError()
}

class ViewController: UIViewController {
        
    // UITableview lazy intialization
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // Search controller lazy intialization
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    // Declare all other necessary variables
    var viewModel: CountryListViewModelProtocol!
    var dataSource = [Country]()
    var isAlertPresent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define View model and setup view
        viewModel = CountryListViewModel(viewController: self)
        setupView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // Load the initial data from the web.
    private func loadIntialData() {
        Task {
            await viewModel.getCountryList()
        }
    }
    
    private func setupView() {
        // Read the title from the VM and update in UI
        title = viewModel.title
        
        // Add search controller in UINavigationItem and set all necessary property
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = viewModel.placeHolder

        // Add tableview in the view and register the cell.
        self.view.addSubview(tableView)
        tableView.register(CountryListTableViewCell.self,
                           forCellReuseIdentifier: CountryListTableViewCell.reusuableIdentifier)
        tableView.rowHeight = 80.0
        
        // Add necessary contraints
        setupConstraints()
        
        // Load the intial data from the web
        loadIntialData()
        
    }
    
    // Method helps to add constraints
    private func setupConstraints() {
        tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
                                            constant: 0.0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
                                           constant: 0.0).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                       constant: 0.0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                          constant: 0.0).isActive = true
    }
    

}

// Search Result updating delegate
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        viewModel.filterCountry(searchText: text)
    }

}

// UITableviewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// UITableView data source delegate
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryListTableViewCell.reusuableIdentifier) as! CountryListTableViewCell
        cell.updateCountryDetails(country: dataSource[indexPath.row])
        return cell
    }
}

extension ViewController: CountryListType {
    
    // Method helps to reload the tableview in the main thread
    func reloadTable(contryList: [Country]) {
        dataSource = contryList
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // This method helps to display Error alart when the searched text is not avilable in the original list
    func showError() {
        if !isAlertPresent {
            isAlertPresent = true
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: CountryListScreen.searchErrorTitle,
                                                        message: CountryListScreen.searchErrorMessage,
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",
                                             style: .default) { [weak self] action in
                    self?.isAlertPresent = false
                    self?.searchController.isActive = false
                    self?.tableView.reloadData()
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
        }
        
    }
}
