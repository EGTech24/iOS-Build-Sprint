//
//  CurrencyData.swift
//  Converency
//
//  Created by Enrique Gongora on 2/3/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import Foundation

struct CurrencyData: Codable{
    let base: String
    let rates: [String: Double]
}
