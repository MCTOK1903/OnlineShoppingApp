//
//  ImageCollectionViewCell.swift
//  OnlineShopApp
//
//  Created by MCT on 22.04.2020.
//  Copyright © 2020 MCT. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    func setupImageWith(itemImage: UIImage){
        imageView.image = itemImage 
    }
    
}
