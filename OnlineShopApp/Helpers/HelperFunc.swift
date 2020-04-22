//
//  HelperFunc.swift
//  OnlineShopApp
//
//  Created by MCT on 22.04.2020.
//  Copyright © 2020 MCT. All rights reserved.
//

import Foundation


func convertToCurrency( _ number: Double) -> String {
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.currencySymbol = "$"
    
    return currencyFormatter.string(from: NSNumber(value: number))!
}
