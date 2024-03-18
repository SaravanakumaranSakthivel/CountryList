//
//  CountryListViewModel.swift
//  CountryList
//
//  Created by Saravanakumaran Sakthivel on 3/18/24.
//

import Foundation

// Text strings thats used in the CountryListScreen
struct CountryListScreen {
    static let title = "Search Country"
    static let placeHolder = "Enter country name or captial"
    static let searchErrorTitle = "No Result Found!!"
    static let searchErrorMessage = "Please Enter Country Name or Captial of the Country"
}

// View model protocol
protocol CountryListViewModelProtocol {
    var title: String { get }
    var placeHolder: String { get }
    func getCountryList() async
    func filterCountry(searchText: String)
    
}

// ViewModel implementattion
class CountryListViewModel: CountryListViewModelProtocol {
    
    weak var viewController: ViewController?
    var title: String
    var placeHolder: String
    var dataSource = [Country]()
    let networkHelper: NetworkHelper
    
    init(viewController: ViewController) {
        // Intialize required objects
        self.viewController = viewController
        self.title = CountryListScreen.title
        self.placeHolder = CountryListScreen.placeHolder
        self.networkHelper =  NetworkHelper(networkManager: NetworkManager.shared())
    }
    
    // Async method, helps to connect with network helper and get the data.
    /// Logic - Call network helper and get the country list
    /// Parse the network returned result
    /// Call viewcontroller reloadTable method and display all country list
    //TODO: This may be an improvement, We can alert the showError method with error type and display appropriate error message in the UI.
    func getCountryList() async {
        do {
            let result = try await networkHelper.getCountryList()
            switch result {
            case .success(let countryList):
                self.dataSource = countryList
                await self.viewController?.reloadTable(contryList: countryList)
            case .failure(let error):
                await self.viewController?.showError()
            }
        }catch {
            await self.viewController?.showError()
        }
    }
    
    // Method helps to search the user typed string in the SearchController and filter the data source
    /// Logic - Filters the country object whose country name or captial contains the entered text and reload the tableview.
    /// If the entered text is not avilable, then show alert and refresh the table view the original data
    /// If user didn't typed anything reload the table with the original data.
    func filterCountry(searchText: String) {
        if !searchText.isEmpty {
            let result = self.dataSource.filter {
                $0.name.lowercased().contains(searchText.lowercased()) || $0.capital.lowercased().contains(searchText.lowercased())
            }
            if result.count > 0 {
                viewController?.reloadTable(contryList: result)
            } else {
                viewController?.dataSource = self.dataSource
                viewController?.showError()
            }
        } else {
            viewController?.reloadTable(contryList: self.dataSource)
        }
    }
}
