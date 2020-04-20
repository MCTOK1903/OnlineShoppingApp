//
//  ItemsTableViewController.swift
//  OnlineShopApp
//
//  Created by MCT on 20.04.2020.
//  Copyright © 2020 MCT. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {

    //vars
    
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(category?.name)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemToAddItemSegue" {
            let vc =  segue.destination as! AddItemViewController
            vc.category = category!
        }
    }

}
