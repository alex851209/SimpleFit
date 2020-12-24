//
//  GoalProvider.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/12.
//

import Foundation
import Firebase
import FirebaseFirestore

enum GoalField: String {
    
    case id
    case title
    case beginDate
    case beginWeight
    case endDate
    case endWeight
}

class GoalProvider {
    
    let database = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    var goalList = [Goal]()
    
    func addDataWith(goal: Goal, completion: @escaping (Result<Any, Error>) -> Void) {

        guard let userID = userID else { return }
        
        let doc = database.collection("users").document(userID).collection("goalList")
        let id = doc.document().documentID
        
        doc.document(id).setData([
            GoalField.id.rawValue: id,
            GoalField.title.rawValue: goal.title,
            GoalField.beginDate.rawValue: goal.beginDate,
            GoalField.beginWeight.rawValue: goal.beginWeight,
            GoalField.endDate.rawValue: goal.endDate,
            GoalField.endWeight.rawValue: goal.endWeight
        ], merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success((goal)))
            }
        }
    }
    
    func fetchGoalDatas(completion: @escaping (Result<[Goal], Error>) -> Void) {
        
        goalList.removeAll()
        
        guard let userID = userID else { return }
        
        let doc = database.collection("users").document(userID).collection("goalList").order(by: "endDate")
        
        doc.getDocuments { [weak self] (querySnapshot, error) in
            
            if let error = error {
                
                print("Error getting documents: \(error)")
            } else {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let goal = try document.data(as: Goal.self, decoder: Firestore.Decoder()) {
                            
                            self?.goalList.append(goal)
                        }
                    } catch {
                        completion(.failure(error))
                    }
                    guard let goalList = self?.goalList else { return }
                    completion(.success(goalList))
                }
            }
            
            guard let emptyGoalList = self?.goalList else { return }
            
            completion(.success(emptyGoalList))
        }
    }
    
    func fetchLatestWeight(completion: @escaping (Result<Double, Error>) -> Void) {
        
        guard let userID = userID else { return }
        
        let doc = database
                    .collection("users")
                    .document(userID)
                    .collection("chartData")
                    .order(by: "date", descending: true)
                    .limit(to: 1)
        
        doc.getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print("Error getting documents: \(error)")
            } else {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let daily = try document.data(as: DailyData.self, decoder: Firestore.Decoder()),
                           let weight = daily.weight {
                            
                            completion(.success(weight))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func removeGoal(with goalId: String, completion: @escaping (Result<Any, Error>) -> Void) {

        guard let userID = userID else { return }

        let doc = database
                    .collection("users")
                    .document(userID)
                    .collection("goalList")

        doc.document(goalId).delete { error in
            
            if let error = error {
                
                print("Error removing Goal: \(error)")
            } else {
                
                completion(.success(()))
            }
        }
    }
}
