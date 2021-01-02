//
//  AddPhotoVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/5.
//

import UIKit

class AddPhotoVC: BlurViewController {

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true, completion: nil) }
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        
        SFProgressHUD.showLoading()
        uploadPhoto()
    }
    
    var callback: ((Int, Int) -> Void)?
    let provider = ChartProvider()
    var selectedPhoto = UIImage()
    var selectedDate = Date()
    var selectedYear = Date().year()
    var selectedMonth = Date().month()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        datePicker.maximumDate = selectedDate
        datePicker.applyBorder()
        datePicker.addTarget(self, action: #selector(dateDidPick), for: .valueChanged)
        
        photoImage.image = selectedPhoto
        photoImage.applyShadow()
        photoImage.layer.shadowOffset = CGSize(width: 5, height: 10)
        photoImage.layer.shadowOpacity = 0.2
    }
    
    private func uploadPhoto() {
        
        provider.uploadPhotoWith(image: selectedPhoto, date: selectedDate) { result in

            switch result {

            case .success(let url):
                print("Success uploading new photo with url: \(url)")
                self.addPhoto(with: url)

            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
    
    private func addPhoto(with url: URL) {

        let urlString = "\(url)"
        let photo = Photo(url: urlString, isFavorite: false)
        let daily = DailyData(photo: photo)

        provider.addDataWith(dailyData: daily, field: .photo, date: selectedDate, completion: { result in

            switch result {

            case .success(let photo):
                let dateString = String(describing: self.selectedDate)
                print("Success adding new photo: \(photo) on date: \(dateString)")
                self.callback?(self.selectedYear, self.selectedMonth)
                SFProgressHUD.showSuccess()
                self.dismiss(animated: true, completion: nil)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    @objc private func dateDidPick(sender: UIDatePicker) {
        
        selectedDate = sender.date
        selectedYear = selectedDate.year()
        selectedMonth = selectedDate.month() }
}
