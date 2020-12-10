//
//  UserProvider.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/10.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum UserField: String {
    
    case avatar
    case name
    case gender
    case height
}

class UserProvider {
    
    let database = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    let userName = "Alex"
    
    func uploadInfoWith(user: User, completion: @escaping (Result<Any, Error>) -> Void) {

        let doc = database.collection("users").document(userName)
        
        let avatarURL = user.avatar as Any
        let name = user.name as Any
        let gender = user.gender as Any
        let height = user.height as Any
        
        doc.setData([
            UserField.avatar.rawValue: avatarURL,
            UserField.name.rawValue: name,
            UserField.gender.rawValue: gender,
            UserField.height.rawValue: height
        ], merge: true) { error in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }
    
    func fetchInfo(completion: @escaping (Result<User, Error>) -> Void) {
        
        let doc = database.collection("users").document(userName)
        
        doc.getDocument { (document, error) in
            
            if let error = error {
                
                print("Error getting document: \(error)")
            } else if let document = document, document.exists {
                
                do {
                    if let user = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                        
                        completion(.success(user))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
