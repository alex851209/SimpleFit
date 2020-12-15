//
//  PhotoDetailVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/15.
//

import UIKit

class PhotoDetailVC: BlurViewController {

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    @IBAction func favoriteButtonDidTap(_ sender: Any) { addToFavorite() }
    
    let provider = ChartProvider()
    var selectedDaily: DailyData?
    var selectedPhoto: UIImage?
    
    override var initialScaleAmmount: CGFloat { return 0.3 }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        photoImage.image = selectedPhoto
        photoImage.layer.cornerRadius = 25
        
        guard let isFavorite = selectedDaily?.photo?.isFavorite else { return }

        if isFavorite { favoriteButton.tintColor = UIColor(red: 168/255, green: 63/255, blue: 57/255, alpha: 1) }
    }
    
    private func addToFavorite() {
        
        favoriteButton.showButtonFeedbackAnimation { [weak self] in
            
            guard let selectedDate = self?.selectedDaily?.date else { return }
            self?.provider.addToFavoriteFrom(date: selectedDate) { [weak self] result in
                
                switch result {
                
                case .success:
                    self?.favoriteButton.tintColor = UIColor(red: 168/255, green: 63/255, blue: 57/255, alpha: 1)
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
