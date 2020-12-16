//
//  GroupProvider.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/16.
//

import Foundation
import Firebase

enum GroupField: String {
    
    case category
    case title
    case content
    case coverPhoto
    case owner
    
    static let ownerName = "name"
    static let ownerAvatar = "avatar"
}

class GroupProvider {
    
    let database = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    let userName = "Alex"
    var groupList = [Group]()
    
    func fetchGroup(completion: @escaping (Result<[Group], Error>) -> Void) {
        
        groupList.removeAll()
        
        let doc = database.collection("users").document(userName).collection("group")
        
        doc.getDocuments { [weak self] (querySnapshot, error) in
            
            if let error = error {
                
                print("Error getting documents: \(error)")
            } else {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let group = try document.data(as: Group.self, decoder: Firestore.Decoder()) {
                            
                            self?.groupList.append(group)
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
                guard let groupList = self?.groupList else { return }
                completion(.success(groupList))
            }
        }
    }
    
    func uploadPhotoWith(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        
        // 自動產生一組 ID，方便上傳圖片的命名
        let uniqueString = UUID().uuidString
        
        let fileRef = storageRef.child("SimpleFitGroupPhotoUpload").child("\(uniqueString).jpg")
        // 轉成 data
        
        let compressedImage = image.scale(newWidth: 600)
        
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
    
    func addGroupWith(group: Group, completion: @escaping (Result<Group, Error>) -> Void) {

        let doc = database.collection("users").document(userName).collection("group")
        
        doc.document().setData([
            GroupField.category.rawValue: group.category,
            GroupField.title.rawValue: group.title,
            GroupField.content.rawValue: group.content,
            GroupField.coverPhoto.rawValue: group.coverPhoto,
            GroupField.owner.rawValue: [
                GroupField.ownerName: group.owner.name,
                GroupField.ownerAvatar: group.owner.avatar
            ]
        ]) { error in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(group))
            }
        }
    }
}
