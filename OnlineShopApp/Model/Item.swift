//
//  Item.swift
//  OnlineShopApp
//
//  Created by MCT on 20.04.2020.
//  Copyright © 2020 MCT. All rights reserved.
//

import Foundation
import UIKit


class Item {
     
    var id: String!
    var categoryId: String!
    var name: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    
    init() {
        
    }
    
    init(_ dictionary: NSDictionary) {
        
        id = dictionary[kOBJECTID] as? String
        categoryId = dictionary[kCATEGORYID] as? String
        name = dictionary[kNAME] as? String
        description = dictionary[kDESCRIPTION] as? String
        price = dictionary[kPRICE] as? Double
        imageLinks = dictionary[kIMAGELINKS] as? [String]
        
    }
    
}

//MARK: Save items func

func saveItemToFirestore(_ item:Item){
    
    FirebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String:Any])
    
}



// MARK:helper func

func itemDictionaryFrom(_ item: Item) -> NSDictionary {

    return NSDictionary(objects: [item.id,item.categoryId,item.name,item.description,item.price,item.imageLinks], forKeys: [kOBJECTID as NSCopying, kCATEGORYID as NSCopying, kNAME as NSCopying, kDESCRIPTION as NSCopying, kPRICE as NSCopying, kIMAGELINKS as NSCopying])
}



