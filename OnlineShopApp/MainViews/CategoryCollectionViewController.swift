//
//  CategoryCollectionViewController.swift
//  OnlineShopApp
//
//  Created by MCT on 19.04.2020.
//  Copyright © 2020 MCT. All rights reserved.
//

import UIKit
import Firebase
private let reuseIdentifier = "Cell"

class CategoryCollectionViewController: UICollectionViewController {

    
    //variable
    var categoryArray : [Category] = []
    private let sectionInests = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    private let itemPerRow: CGFloat = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadCategories()
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoryArray.count > 0 ? categoryArray.count : 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewCell
        cell.generateCell(categoryArray[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "categoryToItemsSegue", sender: categoryArray[indexPath.row])
    }
    
    
    
    //Download categories
    private func loadCategories(){
        
        downloadCategoriesFromFirebase { (allCategories) in
            self.categoryArray = allCategories
            self.collectionView.reloadData()
        }
    }
    
    
    //Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "categoryToItemsSegue" {
            let vc = segue.destination as! ItemsTableViewController
            vc.category = sender as! Category
        }
    }
    
     
}

extension CategoryCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInests.left * (itemPerRow + 1)
        let avaiableWidth = view.frame.width - paddingSpace
        let withPerItem = avaiableWidth / itemPerRow
        
        return CGSize(width: withPerItem, height: withPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInests
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInests.left
    }
    
    
}
