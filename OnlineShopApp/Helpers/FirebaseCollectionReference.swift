//
//  FirebaseCollectionReference.swift
//  OnlineShopApp
//
//  Created by MCT on 20.04.2020.
//  Copyright © 2020 MCT. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Category
    case Items
    case Basket
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}
