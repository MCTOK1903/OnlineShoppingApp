//
//  Basket.swift
//  OnlineShopApp
//
//  Created by MCT on 24.04.2020.
//  Copyright © 2020 MCT. All rights reserved.
//

import Foundation

class Basket {
    
    var id: String!
    var ownerId: String!
    var itemIds: [String]!
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kOBJECTID] as? String
        ownerId = _dictionary[kOWNERID] as? String
        itemIds = _dictionary[kITEMIDS] as? [String]
    }
    
}





//MARK: - Helper func
func basketDictionaryFrom(_ basket: Basket) -> NSDictionary{
    return NSDictionary(objects: [basket.id, basket.itemIds, basket.ownerId], forKeys: [kOBJECTID as NSCopying, kITEMIDS as NSCopying, kOWNERID as NSCopying])
}
