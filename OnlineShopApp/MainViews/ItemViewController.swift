//
//  ItemViewController.swift
//  OnlineShopApp
//
//  Created by MCT on 22.04.2020.
//  Copyright © 2020 MCT. All rights reserved.
//

import UIKit
import JGProgressHUD

class ItemViewController: UIViewController {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UITextView!
    
    //MARRK: Vars
    
    var item: Item!
    var itemImages:[UIImage] = []
    let hud = JGProgressHUD(style: .dark)
     
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }
    
    
    //MARK: setup UI
    
    private func setupUI(){
        
        if item != nil {
            
            self.title = item.name
            nameLabel.text = item.name
            descriptionLabel.text = item.description
            priceLabel.text = convertToCurrency(item.price)
            
            
           
        }
    
    }
}

 
extension ItemViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return UICollectionViewCell()
    }
    
    
    
    
}
