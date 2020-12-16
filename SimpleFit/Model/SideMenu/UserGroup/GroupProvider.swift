//
//  GroupProvider.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/16.
//

import Foundation
import Firebase

class GroupProvider {
    
    let database = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    let userName = "Alex"
    var groupList = [Group]()
    
    func fetchGroup(completion: @escaping (Result<[Group], Error>) -> Void) {
        
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
                    guard let groupList = self?.groupList else { return }
                    completion(.success(groupList))
                }
            }
        }
    }
}
