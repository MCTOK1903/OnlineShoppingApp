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
                self.totalItemsCount.text = String(self.allItems.count)
                self.tableView.reloadData()
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
    
}
