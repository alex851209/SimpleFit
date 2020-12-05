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
    
    @IBAction func dismiss(_ sender: Any) {
        
        callback?()
        dismiss(animated: true)
    }
    
    var callback: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
        weightLabel.applyBorder()
        photoImage.image = UIImage.asset(.album)
        noteTextView.transform = CGAffineTransform(rotationAngle: .pi * 0.05)
    }
}
