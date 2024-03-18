//
//  Country.swift
//  CountryList
//
//  Created by Saravanakumaran Sakthivel on 3/17/24.
//

import Foundation

// In the sample response below values are non nil hence declared as non optional variables.
// TODO: While decoding the data from the network, if empty data comes we could have mapped with N/A, Currently in UI displaying "N/A"
struct Country: Codable {
    var name: String
    var region: String
    var code: String
    var capital: String
}
