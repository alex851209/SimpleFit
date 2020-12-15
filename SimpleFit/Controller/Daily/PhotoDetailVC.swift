//
//  PhotoDetailVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/15.
//

import UIKit

class PhotoDetailVC: BlurViewController {

    @IBOutlet weak var photoImage: UIImageView!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    
    var selectedPhoto: UIImage?
    
    override var initialScaleAmmount: CGFloat { return 0.3 }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurePhoto()
    }
    
    private func configurePhoto() {
        
        photoImage.image = selectedPhoto
        photoImage.layer.cornerRadius = 25
    }
}
