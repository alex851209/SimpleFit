//
//  DetailVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/1.
//

import UIKit

class DetailVC: BlurViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var cardView: UIView!
    
    @IBAction func dismiss(_ sender: Any) {
        
        callback?()
        dismiss(animated: true)
    }
    
    var callback: (() -> Void)?
    var daily: DailyData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureTapGesture()
    }
    
    private func configureLayout() {
        
        cardView.layer.cornerRadius = 25
        cardView.applyShadow()
        
        guard let month = daily?.month,
              let day = daily?.day
        else { return }
        titleLabel.text = month + "-" + day
        titleLabel.applyBorder()
        
        if let weight = daily?.weight { weightLabel.text = "\(weight)" }
        weightLabel.applyBorder()
        
        if let photo = daily?.photo { photoImage.loadImage(photo.url, placeHolder: UIImage.asset(.album)) }
        photoImage.layer.cornerRadius = 10
        photoImage.clipsToBounds = true
        photoImage.applyShadow()
        
        noteTextView.transform = CGAffineTransform(rotationAngle: .pi * 0.05)
        noteTextView.text = daily?.note
    }
    
    private func configureTapGesture() {
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(photoDidTap))
        photoImage.isUserInteractionEnabled = true
        photoImage.addGestureRecognizer(recognizer)
    }
    
    @objc private func photoDidTap() {
        
        photoImage.showButtonFeedbackAnimation {}
    }
}
