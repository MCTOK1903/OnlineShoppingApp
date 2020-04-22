//
//  AddItemViewController.swift
//  OnlineShopApp
//
//  Created by MCT on 21.04.2020.
//  Copyright © 2020 MCT. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UIViewController {

    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var priceTF: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: vars
    var category: Category!
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .dark)
    
    var activityIndicator: NVActivityIndicatorView?
    
    var itemImages : [UIImage?] = []
    
    
    //MARK:View lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballRotateChase, color: .gray, padding: nil)
    }
    
    
    @IBAction func cameraClicked(_ sender: Any) {
        itemImages = []
        showImageGallery()
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        dissmissKeyboard()
        
        if checkFieldAreCompleted() {
            savetoFirebase()
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
    
     //MARK: back to itemstableVC
    private func popTheView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: SaveToFireBase
    private func savetoFirebase() {
        
        showLoadingIndicator()
        let item = Item()
        item.id = UUID().uuidString
        item.name = titleTF.text!
        item.price = Double(priceTF.text!)
        item.categoryId = category.id
        item.description = descriptionTextView.text
        
        if itemImages.count > 0 && !itemImages.isEmpty {
            
            uploadImages(images: itemImages, itemId: item.id) { (imageLinkArray) in
                
                item.imageLinks = imageLinkArray
                
                saveItemToFirestore(item)
                self.hideLoadingIndicator()
                self.popTheView()
            }
            
        }else {
            saveItemToFirestore(item)
            popTheView()
        }
    }
    
    
    //MARK: Activity İndicator
    
    private func showLoadingIndicator(){
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    private func hideLoadingIndicator(){
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    //MARK: show Galery
    private func showImageGallery(){
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab,.cameraTab]
        Config.Camera.imageLimit = 4
        
        self.present(self.gallery, animated: true, completion: nil)
        
    }
    
    
}

extension AddItemViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            Image.resolve(images: images) { (resolvedImages) in
                self.itemImages = resolvedImages
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}
