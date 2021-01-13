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
    
    @IBAction func dismiss(_ sender: Any) {
        
        blurCallback?()
        dismiss(animated: true)
    }
    @IBAction func favoriteButtonDidTap(_ sender: Any) { addFavorite() }
    
    var callback: ((Bool) -> Void)?
    var blurCallback: (() -> Void)?
    let provider = ChartProvider()
    var selectedDaily: DailyData?
    var selectedPhoto: UIImage?
    var isFavorite = false
    let heartColor = UIColor(red: 168/255, green: 63/255, blue: 57/255, alpha: 1)
    
    override var initialScaleAmmount: CGFloat { return 0.3 }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        photoImage.image = selectedPhoto
        photoImage.layer.cornerRadius = 25
        
        guard let isFavorite = selectedDaily?.photo?.isFavorite else { return }

        if isFavorite { favoriteButton.tintColor = heartColor }
        self.isFavorite = isFavorite
    }
    
    private func addFavorite() {
        
        SFProgressHUD.showLoading()
        isFavorite = !isFavorite
        
        favoriteButton.showButtonFeedbackAnimation { [weak self] in
            guard let selectedDate = self?.selectedDaily?.date,
                  let isFavorite = self?.isFavorite
            else { return }
            
            self?.provider.updatePhoto(isFavorite: isFavorite, to: selectedDate) { [weak self] result in
                switch result {
                case .success:
                    self?.favoriteButton.tintColor = isFavorite ? self?.heartColor : .systemGray
                    !isFavorite ? SFProgressHUD.removeHeart() : SFProgressHUD.showHeart()
                    self?.callback?(isFavorite)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
