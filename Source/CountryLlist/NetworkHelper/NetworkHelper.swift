//
//  NetworkHelper.swift
//  CountryList
//
//  Created by Saravanakumaran Sakthivel on 3/17/24.
//

import Foundation

// Enum helps to organize all API end points
enum API: String {
    case countryList = "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"
}

// Network helper protocol interface help to connect with network manager and get response.
protocol NetworkHelperProtocol {
    func getCountryList() async throws -> Result<[Country], NetworkError>
    func parseAndGetCountryList(data: Data) -> Result<[Country], NetworkError>
    
}


class NetworkHelper: NetworkHelperProtocol {
    
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // This method helps construct network request and call generic network manager
    /// It returns Result type with Array of Country and NetworkError.
    func getCountryList() async throws -> Result<[Country], NetworkError> {
        
        guard let url = URL(string: API.countryList.rawValue) else {
            return .failure(.notValidURL)
        }
        
        let networkRequest = NetworkRequest(url: url,
                                            method: .get,
                                            headers: nil,
                                            body: nil)
        do {
            let result = try await networkManager.performRequest(networkRequest: networkRequest)
            switch result {
            case .success(let data):
                return parseAndGetCountryList(data: data)
            case .failure(let error):
                return .failure(error)
            }
        } catch {
            return .failure(.genericError)
        }
    }
    
    // This helps to parse the country list resposne from the network response data
    // TODO: This can be refactored and defined as more generic method
    func parseAndGetCountryList(data: Data) -> Result<[Country], NetworkError> {
        do {
            let countryList = try JSONDecoder().decode([Country].self, from: data)
            return .success(countryList)
        } catch {
            return .failure(.parsingError)
        }
    }
    
}
