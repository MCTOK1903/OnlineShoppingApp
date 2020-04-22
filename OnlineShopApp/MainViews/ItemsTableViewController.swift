//
//  ItemsTableViewController.swift
//  OnlineShopApp
//
//  Created by MCT on 20.04.2020.
//  Copyright © 2020 MCT. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {

    //MARK:vars
    
    var category: Category?
    
    var itemArray:[Item] = []
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //boş günre görünümleri yok eder
        tableView.tableFooterView = UIView()
        
        self.title = category?.name
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if category != nil {
            loadItems()
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count > 0 ? itemArray.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        cell.generateCell(itemArray[indexPath.row])
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemToAddItemSegue" {
            let vc =  segue.destination as! AddItemViewController
            vc.category = category!
        }
    }
    
    //MARK: download Items from Firabase
    private func loadItems(){
        downloadItemsFromFirebase(withCategoryId: category!.id) { (ItemArray) in
            self.itemArray = ItemArray
            self.tableView.reloadData()
        }
    }

}
