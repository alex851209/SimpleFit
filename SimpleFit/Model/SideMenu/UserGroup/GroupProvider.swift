//
//  GroupProvider.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/16.
//

import Foundation
import Firebase
import FirebaseFirestore

enum GroupField: String {
    
    case id
    case category
    case name
    case content
    case coverPhoto
    case owner
    case groups
    
    static let ownerName = "name"
    static let ownerAvatar = "avatar"
}

enum MemberField: String {
    
    case id
    case avatar
    case gender
    case height
    case name
    case intro
}

enum ChallengeField: String {
    
    case id
    case avatar
    case content
    case date
    case createdTime
}

enum AlbumField: String {
    
    case id
    case name
    case url
    case createdTime
}

enum GroupInvitationsField: String {
    
    case id
    case name
    case inviter
    
    static let inviterName = "name"
    static let inviterAvatar = "avatar"
}

class GroupProvider {
    
    let database = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    let userID = Auth.auth().currentUser?.uid
    var groupList = [Group]()
    var memberList = [User]()
    var challengeList = [Challenge]()
    var albumList = [Album]()
    var invitationList = [Invitation]()
    
    func fetchGroups(of user: User, completion: @escaping (Result<[Group], Error>) -> Void) {
        
        groupList.removeAll()
        
        guard let groups = user.groups else { return }
        
        let doc = database.collection("groups")
        
        doc.getDocuments { [weak self] (querySnapshot, error) in
            
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        if let group = try document.data(as: Group.self, decoder: Firestore.Decoder()) {
                            if groups.contains(group.id) { self?.groupList.append(group) }
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
    
    func addGroupWith(group: Group, user: User, completion: @escaping (Result<Group, Error>) -> Void) {

        guard let userID = userID else { return }
        
        let doc = database.collection("groups")
        let userDoc = database.collection("users").document(userID)
        let id = doc.document().documentID
        
        doc.document(id).setData([
            GroupField.id.rawValue: id,
            GroupField.category.rawValue: group.category,
            GroupField.name.rawValue: group.name,
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
                
                guard let userID = self?.userID else { return }
                
                doc.document(id).collection("members").document(userID).setData([
                    MemberField.id.rawValue: userID,
                    MemberField.name.rawValue: user.name as Any,
                    MemberField.gender.rawValue: user.gender as Any,
                    MemberField.height.rawValue: user.height as Any,
                    MemberField.avatar.rawValue: user.avatar as Any,
                    MemberField.intro.rawValue: user.intro as Any
                ])
                
                userDoc.updateData([
                    GroupField.groups.rawValue: FieldValue.arrayUnion([id])
                ])
            }
        }
    }
    
    func fetchMembers(in group: Group, completion: @escaping (Result<[User], Error>) -> Void) {
        
        let doc = database.collection("groups").document(group.id).collection("members")
        
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
    
    func fetchChallenges(in group: Group, completion: @escaping (Result<[Challenge], Error>) -> Void) {
        
        challengeList.removeAll()
        
        let doc = database
            .collection("groups")
            .document(group.id)
            .collection("challenges")
            .order(by: "createdTime", descending: true)
        
        doc.getDocuments { [weak self] (querySnapshot, error) in
            
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        if let challenge = try document.data(
                            as: Challenge.self,
                            decoder: Firestore.Decoder()
                        ) {
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
    
    func addChallenge(
        in group: Group,
        with challenge: Challenge,
        completion: @escaping (Result<Challenge, Error>) -> Void
    ) {
        
        let doc = database.collection("groups").document(group.id).collection("challenges")
        
        let id = doc.document().documentID
        
        doc.document(id).setData([
            ChallengeField.id.rawValue: id,
            ChallengeField.avatar.rawValue: challenge.avatar as Any,
            ChallengeField.content.rawValue: challenge.content,
            ChallengeField.date.rawValue: challenge.date,
            ChallengeField.createdTime.rawValue: Date()
        ]) { error in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(challenge))
            }
        }
    }
    
    func sendInvitaion(
        from inviter: User,
        to invitee: User,
        in group: Group,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        
        searchUser(invitee) { [weak self] result in
            
            switch result {
            
            case .success(let invitee):
                
                self?.fetchMembers(in: group, completion: { result in
                    
                    switch result {
                    
                    case .success(let users):
                        if users.contains(where: { $0.id == invitee.id }) {
                            SFProgressHUD.showFailed(with: "使用者已存在群組")
                        } else {
                            let doc = self?
                                .database
                                .collection("users")
                                .document(invitee.id)
                                .collection("groupInvitations")

                            doc?.document(group.id).setData([
                                GroupInvitationsField.id.rawValue: group.id,
                                GroupInvitationsField.name.rawValue: group.name,
                                GroupInvitationsField.inviter.rawValue: [
                                    GroupInvitationsField.inviterName: inviter.name,
                                    GroupInvitationsField.inviterAvatar: inviter.avatar
                                ]
                            ]) { error in

                                if let error = error {
                                    completion(.failure(error))
                                } else {
                                    completion(.success(invitee))
                                }
                            }
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                })
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func searchUser(_ user: User, completion: @escaping (Result<User, Error>) -> Void) {
        
        let doc = database.collection("users").whereField("name", isEqualTo: user.name as Any)
        
        doc.getDocuments { (querySnapshot, error) in
            
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                guard let isNoUser = querySnapshot?.documents.isEmpty, !isNoUser else {
                    SFProgressHUD.showFailed(with: "查無使用者")
                    return
                }
                
                for document in querySnapshot!.documents {
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
    
    func addAlbumPhoto(
        in group: Group,
        from user: User,
        with photo: URL,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        
        let doc = database.collection("groups").document(group.id).collection("album")
        
        let id = doc.document().documentID
        
        doc.document(id).setData([
            AlbumField.id.rawValue: id,
            AlbumField.name.rawValue: user.name as Any,
            AlbumField.url.rawValue: "\(photo)",
            AlbumField.createdTime.rawValue: Date()
        ]) { error in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(photo))
            }
        }
    }
    
    func addCoverPhoto(
        in group: Group,
        with photo: URL,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {

        let doc = database.collection("groups").document(group.id)

        doc.setData([
            GroupField.coverPhoto.rawValue: "\(photo)"
        ], merge: true) { error in

            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(photo))
            }
        }
    }
    
    func fetchAlbum(in group: Group, completion: @escaping (Result<[Album], Error>) -> Void) {
        
        albumList.removeAll()
        
        let doc = database
            .collection("groups")
            .document(group.id)
            .collection("album")
            .order(by: AlbumField.createdTime.rawValue, descending: true)
        
        doc.getDocuments { [weak self] (querySnapshot, error) in
            
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        if let album = try document.data(as: Album.self, decoder: Firestore.Decoder()) {
                            self?.albumList.append(album)
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
                guard let albumList = self?.albumList else { return }
                completion(.success(albumList))
            }
        }
    }
    
    func listenInvitations(completion: @escaping (Result<[Invitation], Error>) -> Void) {
        
        guard let userID = userID else { return }
        
        let doc = database.collection("users").document(userID).collection("groupInvitations")
        
        doc.addSnapshotListener { [weak self] querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error listening invitations: \(String(describing: error))")
                return
            }
            
            self?.invitationList.removeAll()
            
            _ = snapshot.documentChanges.map {
                guard let invitation = try? $0.document.data(
                        as: Invitation.self,
                        decoder: Firestore.Decoder())
                else { return }

                self?.invitationList.append(invitation)
            }
            
            guard let invitationList = self?.invitationList else { return }
            completion(.success(invitationList))
        }
    }
    
    func acceptInvitation(
        of user: User,
        invitationID: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        
        guard let userID = userID else { return }
        
        let usersDoc = database.collection("users").document(userID)
        let groupsDoc = database.collection("groups")
        
        usersDoc.collection("groupInvitations").document(invitationID).delete { error in
            
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                usersDoc.updateData([
                    GroupField.groups.rawValue: FieldValue.arrayUnion([invitationID])
                ])
                
                groupsDoc.document(invitationID).collection("members").document(userID).setData([
                    MemberField.id.rawValue: userID,
                    MemberField.name.rawValue: user.name as Any,
                    MemberField.gender.rawValue: user.gender as Any,
                    MemberField.height.rawValue: user.height as Any,
                    MemberField.avatar.rawValue: user.avatar as Any,
                    MemberField.intro.rawValue: user.intro as Any
                ])
                
                completion(.success(invitationID))
            }
        }
    }
    
    func removeMember(
        of user: User,
        in group: Group,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        
        let usersDoc = database.collection("users").document(user.id)
        let groupsDoc = database
            .collection("groups")
            .document(group.id)
            .collection("members")
            .document(user.id)
        
        usersDoc.updateData([
            GroupField.groups.rawValue: FieldValue.arrayRemove([group.id])
        ]) { error in
            
            if let error = error {
                print("Error removing member: \(error)")
            } else {
                groupsDoc.delete()
                guard let name = user.name else { return }
                completion(.success(name))
            }
        }
    }
    
    func removeAlbum(
        of id: String,
        in group: Group,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        
        let doc = database
            .collection("groups")
            .document(group.id)
            .collection("album")
            .document(id)
        
        doc.delete { error in
            
            if let error = error {
                print("Error removing album: \(error)")
            } else {
                completion(.success(id))
            }
        }
    }
    
    func removeChallenge(
        of id: String,
        in group: Group,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        
        let doc = database
            .collection("groups")
            .document(group.id)
            .collection("challenges")
            .document(id)
        
        doc.delete { error in
            
            if let error = error {
                print("Error removing challenge: \(error)")
            } else {
                completion(.success(id))
            }
        }
    }
}
