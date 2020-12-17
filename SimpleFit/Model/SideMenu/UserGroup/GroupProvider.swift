//
//  GroupProvider.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/16.
//

import Foundation
import Firebase

enum GroupField: String {
    
    case id
    case category
    case title
    case content
    case coverPhoto
    case owner
    
    static let ownerName = "name"
    static let ownerAvatar = "avatar"
}

enum MemberField: String {
    
    case avatar
    case gender
    case height
    case name
}

enum ChallengeField: String {
    
    case id
    case avatar
    case content
    case date
}

class GroupProvider {
    
    let database = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    let userName = "Alex"
    var groupList = [Group]()
    var memberList = [User]()
    var challengeList = [Challenge]()
    
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
    
    func addGroupWith(group: Group, user: User, completion: @escaping (Result<Group, Error>) -> Void) {

        let doc = database.collection("users").document(userName).collection("group")
        let id = doc.document().documentID
        
        doc.document(id).setData([
            GroupField.id.rawValue: id,
            GroupField.category.rawValue: group.category,
            GroupField.title.rawValue: group.title,
            GroupField.content.rawValue: group.content,
            GroupField.coverPhoto.rawValue: group.coverPhoto,
            GroupField.owner.rawValue: [
                GroupField.ownerName: group.owner.name,
                GroupField.ownerAvatar: group.owner.avatar
            ]
        ]) { [weak self] error in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(group))
                
                guard let userName = self?.userName else { return }
                
                doc.document(id).collection("member").document(userName).setData([
                    MemberField.name.rawValue: user.name as Any,
                    MemberField.gender.rawValue: user.gender as Any,
                    MemberField.height.rawValue: user.height as Any,
                    MemberField.avatar.rawValue: user.avatar as Any
                ])
            }
        }
    }
    
    func fetchMember(in group: Group, completion: @escaping (Result<[User], Error>) -> Void) {
        
        let doc = database
                    .collection("users")
                    .document(userName)
                    .collection("group")
                    .document(group.id)
                    .collection("member")
        
        doc.getDocuments { [weak self] (querySnapshot, error) in
            
            self?.memberList.removeAll()
            
            if let error = error {
                
                print("Error getting documents: \(error)")
            } else {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let user = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                            
                            self?.memberList.append(user)
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
                guard let memberList = self?.memberList else { return }
                completion(.success(memberList))
            }
        }
    }
    
    func fetchChallenge(in group: Group, completion: @escaping (Result<[Challenge], Error>) -> Void) {
        
        challengeList.removeAll()
        
        let doc = database
                    .collection("users")
                    .document(userName)
                    .collection("group")
                    .document(group.id)
                    .collection("challenge")
                    .order(by: "date", descending: true)
        
        doc.getDocuments { [weak self] (querySnapshot, error) in
            
            if let error = error {
                
                print("Error getting documents: \(error)")
            } else {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let challenge = try document.data(as: Challenge.self, decoder: Firestore.Decoder()) {
                            
                            self?.challengeList.append(challenge)
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
                guard let challengeList = self?.challengeList else { return }
                completion(.success(challengeList))
            }
        }
    }
    
    func addChallenge(in group: Group,
                      with challenge: Challenge,
                      completion: @escaping (Result<Challenge, Error>) -> Void) {
        
        let doc = database
                    .collection("users")
                    .document(userName)
                    .collection("group")
                    .document(group.id)
                    .collection("challenge")
        
        let id = doc.document().documentID
        
        doc.document(id).setData([
            ChallengeField.id.rawValue: id,
            ChallengeField.avatar.rawValue: challenge.avatar as Any,
            ChallengeField.content.rawValue: challenge.content,
            ChallengeField.date.rawValue: challenge.date
        ]) { error in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(challenge))
            }
        }
    }
}
