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
            nameSuffix += 1
        }
    }
    
}


func saveImageInFirebase(imageData:Data, fileName: String, completion: @escaping (_ imageLink: String?)->Void){
    
    let storageRef = storage.reference().child(fileName)
    storageRef.putData(imageData, metadata: nil) { (metadata, err) in
        if let err = err {
            print(err)
            completion(nil)
            return
        }
        storageRef.downloadURL { (url, err) in
            guard let url = url else {
                completion(nil)
                return
            }
            
            completion(url.absoluteString)
        }
         
    }
    
}


