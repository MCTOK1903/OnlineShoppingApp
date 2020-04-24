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
     
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    private let cellHeight : CGFloat = 196.0
    private let itemsPerRow: CGFloat = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "back"), landscapeImagePhone: UIImage(named: "back"), style: .plain, target: self, action: #selector(backAction))]
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "basket"), landscapeImagePhone: UIImage(named: "back"), style: .plain, target: self, action: #selector(addToBasket))]
        
    }
    
    //MARK: - Download Pictures
    
    private func downloadPictures() {
        
        if item != nil && item.imageLinks != nil {
            downloadImages(imageURL: item.imageLinks) { (allImages) in
                
                if allImages.count > 0 {
                    
                    self.itemImages = allImages as! [UIImage]
                    self.imageCollectionView.reloadData()
                    
                }
            }
        }
        
    }
    
    
    //MARK: - setup UI
    
    private func setupUI(){
        
        if item != nil {
            
            self.title = item.name
            nameLabel.text = item.name
            descriptionLabel.text = item.description
            priceLabel.text = convertToCurrency(item.price)
            downloadPictures()
        }
    
    }
    
    
    //MARK: IBAction
    
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addToBasket(){
        
        downloadBasketFromFirestore("1234") { (basket) in
            
            if basket == nil {
                self.createNewBasket()
            }else{
                basket!.itemIds.append(self.item.id)
                self.updateBasket(basket: basket!, withValues: [kITEMIDS: basket?.itemIds])
            }
        }
        
        
    }
    
    //MARK: - Add to basket
    
    private func createNewBasket(){
        
        let newBasket = Basket()
        newBasket.id = UUID().uuidString
        newBasket.ownerId = "1234"
        newBasket.itemIds = [self.item.id]
        saveBasketToFirestore(newBasket)
        
        self.hud.textLabel.text = "Added to basket!"
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view, animated: true)
        self.hud.dismiss(afterDelay: 2.0, animated: true)
        
    }
    
    private func updateBasket(basket: Basket, withValues: [String:Any]){
        
        
        
    }
    
    
}


//MARK: - extension
 
extension ItemViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count == 0 ? 1 : itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
           
        if itemImages.count > 0 {
            cell.setupImageWith(itemImage: itemImages[indexPath.row])
        }
        
        return cell
    }

}

extension ItemViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.frame.width - sectionInsets.left

        return CGSize(width: availableWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}

