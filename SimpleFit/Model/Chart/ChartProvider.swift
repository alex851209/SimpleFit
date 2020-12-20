//
//  ChartDataProvider.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/28.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift

enum ChartField: String {
    
    case weight
    case photo
    case note
    
    static let date = "date"
    static let month = "month"
    static let day = "day"
    static let photoUrl = "url"
    static let isFavorite = "isFavorite"
    static let photoIsFavorite = "photo.isFavorite"
}

class ChartProvider {
    
    let database = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    let userID = Auth.auth().currentUser?.uid
    var chartData = ChartData()
    var dailyDatas = [DailyData]()
    
    func addDataWith(dailyData: DailyData,
                     field: ChartField,
                     date: Date,
                     completion: @escaping (Result<Any, Error>) -> Void) {

        guard let userID = userID else { return }
        
        let dateString = DateProvider.dateToDateString(date)
        let month = DateProvider.dateToMonthString(date)
        let day = DateProvider.dateToDayString(date)
        let doc = database.collection("users").document(userID).collection("chartData")
        
        switch field {
        
        case .weight:
            guard let weight = dailyData.weight else { return }
            doc.document(dateString).setData([
                field.rawValue: weight,
                ChartField.date: dateString,
                ChartField.month: month,
                ChartField.day: day
                ], merge: true) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(weight))
                }
            }
        case .photo:
            guard let photo = dailyData.photo else { return }
            doc.document(dateString).setData([
                field.rawValue: [
                    ChartField.photoUrl: photo.url,
                    ChartField.isFavorite: photo.isFavorite
                ],
                ChartField.date: dateString,
                ChartField.month: month,
                ChartField.day: day
            ], merge: true) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(photo))
                }
            }
        case .note:
            guard let note = dailyData.note else { return }
            doc.document(dateString).setData([
                field.rawValue: note,
                ChartField.date: dateString,
                ChartField.month: month,
                ChartField.day: day
            ], merge: true) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(note))
                }
            }
        }
    }
    
    func uploadPhotoWith(image: UIImage, date: Date, completion: @escaping (Result<URL, Error>) -> Void) {
        
        // 自動產生一組 ID，方便上傳圖片的命名
        let uniqueString = UUID().uuidString
        
        let fileRef = storageRef.child("SimpleFitPhotoUpload").child("\(uniqueString).jpg")
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
    
    func getDataFrom(year: Int, month: Int) -> ChartData {
        
        getWeightFrom(year: year, month: month)
        getCategoriesFrom(year: year, month: month)
        return chartData
    }
    
    func fetchDailyDatasFrom(year: Int, month: Int, completion: @escaping (Result<[DailyData], Error>) -> Void) {
        
        guard let userID = userID else { return }
        
        let doc = database.collection("users").document(userID).collection("chartData")
        let month = DateProvider.add0BeforeNumber(month)
        dailyDatas.removeAll()
        
        doc.whereField(ChartField.month, isEqualTo: "\(year)-\(month)").getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print("Error getting documents: \(error)")
            } else {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let daily = try document.data(as: DailyData.self, decoder: Firestore.Decoder()) {
                            self.dailyDatas.append(daily)
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
                completion(.success((self.dailyDatas)))
            }
        }
    }
    
    func fetchFavoriteDatas(completion: @escaping (Result<[DailyData], Error>) -> Void) {
        
        guard let userID = userID else { return }
        
        let doc = database.collection("users").document(userID).collection("chartData")
        
        doc.whereField(ChartField.photoIsFavorite, isEqualTo: true).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print("Error getting favorites: \(error)")
            } else {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let daily = try document.data(as: DailyData.self, decoder: Firestore.Decoder()) {
                            self.dailyDatas.append(daily)
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
                completion(.success((self.dailyDatas)))
            }
        }
    }
    
    private func getWeightFrom(year: Int, month: Int) {

        let countOfDays = DateProvider.getCountOfDaysInMonth(year: year, month: month)
        var weightDatas = [Double?]()
        var clearDatas = [Any?]()
        let days = dailyDatas.map { $0.day }

        for count in 1 ... countOfDays {

            let day = DateProvider.add0BeforeNumber(count)

            if days.contains(day) {
                let daily = dailyDatas.first( where: { $0.day == day })
                weightDatas.append(daily?.weight)
            } else {
                weightDatas.append(nil)
            }
            clearDatas.append(nil)
        }
        
        chartData.datas = weightDatas
        chartData.clearDatas = clearDatas

        guard let min = weightDatas.compactMap({ $0 }).min(),
              let max = weightDatas.compactMap({ $0 }).max()
        else {
            chartData.min = 0
            chartData.max = 100
            return
        }

        chartData.min = min - 5
        chartData.max = max + 5
    }
    
    private func getCategoriesFrom(year: Int, month: Int) {
        
        let countOfDays = DateProvider.getCountOfDaysInMonth(year: year, month: month)
        var firstDay = DateProvider.getfirstWeekDayInMonth(year: year, month: month)
        var categories = [String]()
        
        for count in 1 ... countOfDays {
            
            let date = DateProvider.add0BeforeNumber(count)
            let chineseDay = DateProvider.chineseDays[firstDay].day
            let category = "\(chineseDay)<br>\(date)"
            
            firstDay += firstDay != 6 ? 1 : -6
            categories.append(category)
        }
        
        chartData.categories = categories
    }
    
    func updatePhoto(isFavorite: Bool, to date: String, completion: @escaping (Result<Any, Error>) -> Void) {
        
        guard let userID = userID else { return }
        
        let doc = database.collection("users").document(userID).collection("chartData").document(date)
        
        doc.updateData([
            ChartField.photoIsFavorite: isFavorite
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
