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
    }
    
    private func configureLayout() {
        
        cardView.layer.cornerRadius = 25
        cardView.applyShadow()
        
        titleLabel.applyBorder()
        
        guard let weight = daily?.weight else { return }
        weightLabel.text = "\(weight)"
        weightLabel.applyBorder()
        
        photoImage.image = UIImage.asset(.album)
        
        noteTextView.transform = CGAffineTransform(rotationAngle: .pi * 0.05)
        noteTextView.text = daily?.note
    }
}
