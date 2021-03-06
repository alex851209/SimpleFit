//
//  PhotoManager.swift
//  SimpleFit
//
//  Created by shuo on 2021/1/2.
//

import UIKit
import FirebaseStorage

enum StorageFile: String {
    
    case avatar = "SimpleFitAvatarUpload"
    case group = "SimpleFitGroupPhotoUpload"
    case photo = "SimpleFitPhotoUpload"
}

class PhotoManager {
    
    static let shared = PhotoManager()
    
    private init() {}
    
    func uploadPhoto(
        to file: StorageFile,
        with image: UIImage,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        
        let storageRef = Storage.storage().reference()
        
        // 自動產生一組 ID，方便上傳圖片的命名
        let uniqueString = UUID().uuidString
        
        let fileRef = storageRef.child(file.rawValue).child("\(uniqueString).jpg")
        
        let compressedImage = image.scale(newWidth: 600)
        
        // 轉成 data
        guard let uploadData = compressedImage.jpegData(compressionQuality: 0.7) else { return }
        
        fileRef.putData(uploadData, metadata: nil) { (_, error) in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // 取得URL
            fileRef.downloadURL { (url, error) in
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                guard let downloadURL = url else { return }
                completion(.success(downloadURL))
            }
        }
    }
}
