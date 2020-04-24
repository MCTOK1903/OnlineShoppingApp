//
//  Downloader.swift
//  OnlineShopApp
//
//  Created by MCT on 21.04.2020.
//  Copyright © 2020 MCT. All rights reserved.
//

import Foundation
import FirebaseStorage

let storage = Storage.storage()

func uploadImages(images: [UIImage?], itemId: String, completion: @escaping (_ imageLinks: [String])-> Void){
    
    var uploadImagesCount = 0
    var imageLinkArray: [String] = []
    var nameSuffix = 0
    
    for image in images {
        
        let fileName = "ItemImages/" + itemId + "/" + "\(nameSuffix)" + ".jpg"
        let imageData = image!.jpegData(compressionQuality: 0.5)
        
        saveImageInFirebase(imageData: imageData!, fileName: fileName) { (imageLink) in
            
            if imageLink != nil {
                
                imageLinkArray.append(imageLink!)
                
                uploadImagesCount += 1
                
                if uploadImagesCount == images.count {
                    completion(imageLinkArray)
                }
            }
        }
        nameSuffix += 1
    }
    
}


//MARK: - save images in firebase

func saveImageInFirebase(imageData:Data, fileName: String, completion: @escaping (_ imageLink: String?)->Void){
    
    let storageRef = storage.reference().child(fileName)
    storageRef.putData(imageData, metadata: nil, completion: { (metadata, err) in
        
        if err != nil {
            print("err")
            completion(nil)
            return
        }
        
        storageRef.downloadURL { (url, err) in
            guard let url  = url else {
                completion(nil)
                return
            }
            completion(url.absoluteString)
        }
        
    })
    
}

//MARK: - Download images from firestore

func downloadImages(imageURL: [String], completion: @escaping (_ images: [UIImage?])-> Void){
    
    var imageArray: [UIImage] = []
    
    var downloadCounter = 0
    
    for link in imageURL {
        
        let url = NSURL(string: link) // string convert to url
        
        let downloadQueue = DispatchQueue(label: "imageDownloadQ")
        
        downloadQueue.async {
            
            downloadCounter += 1
            
            let data = NSData(contentsOf: url! as URL) // url convert to data
            
            if data != nil {
                
                imageArray.append(UIImage(data: data! as Data)!)
                
                if imageArray.count == downloadCounter {
                    
                    DispatchQueue.main.async{
                        completion(imageArray)
                        return
                    }
                }
            } else{
                print("!")
                completion(imageArray)
            }
        }
    }
}


//MARK: - download categories from Firebase

func donwloadCategoriesFromFirebase(completion: @escaping (_ categoryArray : [Category])-> Void){
    
    var categoryArray : [Category] = []
    
    FirebaseReference(.Category).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else{
            completion(categoryArray)
            return
        }
        if !snapshot.isEmpty && snapshot.count > 0 {
            
            for categoryDict in snapshot.documents {
                categoryArray.append(Category(_dictionary: categoryDict.data() as NSDictionary))
            }
            
        }
        completion(categoryArray)
    }
    
    
}


//MARK: - donwload items

func downloadBasketFromFirestore(_ ownerId: String, completion: @escaping (_ basket: Basket?)-> Void){
    
    FirebaseReference(.Basket).whereField(kOWNERID, isEqualTo: ownerId).getDocuments { (snapshot, err) in
        
        guard let snapshot = snapshot else {
            completion(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            
            // - we used document.fitst because every user has only one basket !!
            let basket = Basket(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(basket)
        }else{
            completion(nil)
        }
        
    }
    
}



