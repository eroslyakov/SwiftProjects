//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Rosliakov Evgenii on 28.07.2021.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

struct ExchangeRate: Decodable {
    let assetIdBase: String
    let assetIdQuote: String
    let rate: Double
    
    var rateString: String { String(format: "%.5f", rate) }
}
