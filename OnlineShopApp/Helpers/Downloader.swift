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

//MARK: Download images from firestore

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



