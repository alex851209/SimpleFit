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
    
    static let month = "month"
    static let day = "day"
    static let photoUrl = "url"
    static let photoIsFavorite = "isFavorite"
}

class ChartProvider {
    
    let database = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    let user = "Alex"
    var chartData = ChartData()
    var dailyDatas = [DailyData]()
    
    func addDataWith(dailyData: DailyData,
                     field: ChartField,
                     date: Date,
                     completion: @escaping (Result<Any, Error>) -> Void) {

        let id = DateProvider.dateToDateString(date)
        let month = DateProvider.dateToMonthString(date)
        let day = DateProvider.dateToDayString(date)
        let doc = database.collection("users").document(user).collection("chartData")
        
        switch field {
        
        case .weight:
            guard let weight = dailyData.weight else { return }
            doc.document(id).setData([
                field.rawValue: weight,
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
            doc.document(id).setData([
                field.rawValue: [
                    ChartField.photoUrl: photo.url,
                    ChartField.photoIsFavorite: photo.isFavorite
                ],
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
            doc.document(id).setData([
                field.rawValue: note,
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
        guard let uploadData = image.jpegData(compressionQuality: 0.9) else { return }
        
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
        
        let doc = database.collection("users").document(user).collection("chartData")
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
    
    private func getWeightFrom(year: Int, month: Int) {

        let countOfDays = DateProvider.getCountOfDaysInMonth(year: year, month: month)
        var weights = [Double?]()
        var datas = [Any]()
        var clearDatas = [Any?]()
        let days = dailyDatas.map { $0.day }

        for count in 1 ... countOfDays {

            let day = DateProvider.add0BeforeNumber(count)

            if days.contains(day) {
                let daily = dailyDatas.first( where: { $0.day == day })
                weights.append(daily?.weight)
            } else {
                weights.append(nil)
            }
        }

        for xPosition in 0 ..< countOfDays {

            clearDatas.append(nil)
            guard let yPosition = weights[xPosition] else { continue }
            let coordinates: [Any] = [xPosition, yPosition]
            datas.append(coordinates)
        }

        chartData.datas = datas
        chartData.clearDatas = clearDatas

        guard let min = weights.compactMap({ $0 }).min(),
              let max = weights.compactMap({ $0 }).max()
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
}
