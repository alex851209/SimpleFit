//
//  ReviewProvider.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/11.
//

import Foundation
import Firebase

class ReviewProvider {

    var weightDatas = [Double]()
    var categories = [String]()
    
    func fetchReviewDatas(from beginDate: Date,
                          to endDate: Date,
                          completion: @escaping (Result<Any, Error>) -> Void) {
        
        let database = Firestore.firestore()
        let userName = "Alex"
        let beginDateString = DateProvider.dateToDateString(beginDate)
        let endDateString = DateProvider.dateToDateString(endDate)
        let doc = database.collection("users").document(userName).collection("chartData")
        
        weightDatas.removeAll()
        categories.removeAll()
        
        doc.whereField(ChartField.date, isGreaterThanOrEqualTo: beginDateString)
           .whereField(ChartField.date, isLessThanOrEqualTo: endDateString)
           .getDocuments { [weak self] (querySnapshot, error) in
            
            if let error = error {
                
                print("Error getting documents: \(error)")
            } else {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let daily = try document.data(as: DailyData.self, decoder: Firestore.Decoder()) {
                            
                            guard let weight = daily.weight else { return }
                            
                            self?.weightDatas.append(weight)
                            self?.categories.append(daily.date)
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
                completion(.success(()))
            }
           }
    }
    
    func getChartData() -> ChartData {

        var chartData = ChartData()
        
        chartData.datas = weightDatas
        chartData.categories = categories

        if let min = weightDatas.compactMap({ $0 }).min(),
           let max = weightDatas.compactMap({ $0 }).max() {
            
            chartData.min = min
            chartData.max = max
        }

        return chartData
    }
}
