//
//  AddItemViewController.swift
//  OnlineShopApp
//
//  Created by MCT on 21.04.2020.
//  Copyright © 2020 MCT. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var priceTF: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: vars
    var category: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cameraClicked(_ sender: Any) {
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        dissmissKeyboard()
        
        if checkFieldAreCompleted() {
                    
        }else{
            makeAlert(title: "Error", message: "Title/Price/Description?")
        }
    }
    
    //GestureRecognizer
    @IBAction func backgroundTapped(_ sender: Any) {
        dissmissKeyboard()
    }
    
    
    //MARK: Helper func
    
    private func dissmissKeyboard(){
        self.view.endEditing(false)
    }
    
    private func checkFieldAreCompleted() -> Bool {
        return (titleTF.text != "" && priceTF.text != "" && descriptionTextView.text != "")
    }
    
    private func makeAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}
