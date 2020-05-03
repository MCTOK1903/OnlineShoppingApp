//
//  BasketViewController.swift
//  OnlineShopApp
//
//  Created by MCT on 25.04.2020.
//  Copyright © 2020 MCT. All rights reserved.
//

import UIKit
import JGProgressHUD

class BasketViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var basketTotalLabel: UILabel!
    @IBOutlet weak var totalItemsCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkOutButtonOutlet: UIButton!
    
    //MARK: - Vars
    var basket: Basket?
    var allItems: [Item] = []
    var purchasedItemIds: [String] = []
    
    let hus = JGProgressHUD(style: .dark)
    
    
    
    //MARK: - View Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = footerView;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //TODO-check user login
        
        loadBasketFromFirebase()
        
    }
    
    //MARK: - IBActions
    @IBAction func checkOutClicked(_ sender: Any) {
    }
    
    
    //MARK: - Download basket
    
    private func loadBasketFromFirebase(){
        
        downloadBasketFromFirestore("1234") { (basket) in
            self.basket = basket
            self.getBasketItem()
        }
    }
    
    private func getBasketItem(){
        
        if basket != nil {
            
            donwloadItemInBasket(basket!.itemIds) { (allItems) in
                self.allItems = allItems
                self.updateTotalLabels(false) // false == basket is not empty!
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Helper func
    
    private func updateTotalLabels(_ isEmpty: Bool){
        
        if isEmpty {
            totalItemsCount.text = "0"
            basketTotalLabel.text = BasketTotalPrice()
        }else {
            totalItemsCount.text = "\(allItems.count)"
            basketTotalLabel.text = BasketTotalPrice()
        }
        
        checkoutButtonStatusUpdate()
        
    }
    
    
    private func BasketTotalPrice() -> String {
        
        var totalPrice = 0.0
        
        for item in allItems {
            
            totalPrice += item.price
        }
        
        return "Total Price:" + convertToCurrency(totalPrice)
        
    }
    
    //MARK: - Control checkoutButton
    
    private func checkoutButtonStatusUpdate(){
        
        checkOutButtonOutlet.isEnabled = allItems.count > 0
        
    }
    
    //MARK: - removeItemFromBasket
    
    private func removeItemFromBasket(itemId:String){
        
        for i in  0..<basket!.itemIds.count {
            
            if itemId == basket!.itemIds[i] {
                basket!.itemIds.remove(at: i)
                return
            }
        }
    }
    
    
}

//MARK: - extension tableView

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count > 0 ? allItems.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        cell.generateCell(allItems[indexPath.row]) 
        return cell
    }
    
    
    //MARK: - UITableview Delegate
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let itemToDelete = allItems[indexPath.row]
            
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            
            removeItemFromBasket(itemId: itemToDelete.id)
            
            updateBasketInFirestore(basket!, withValues: [kITEMIDS: basket?.itemIds]) { (err) in
                
                if err != nil {
                    print("error updating basket", err?.localizedDescription)
                }
                
                self.getBasketItem()
            }
        }
    }
    
    
}




    
