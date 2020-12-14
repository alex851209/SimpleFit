//
//  DailyCell.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/14.
//

import UIKit
import Gemini

class DailyCell: GeminiCell {

    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var photoPlaceholderLabel: UILabel!
    @IBOutlet var notePlaceholderLabels: [UILabel]!
    @IBOutlet weak var notePlaceholderImage: UIImageView!
    
    func layoutCell(with daily: DailyData, averageWeight: Double) {
        
        configureTapGesture()
        
        layer.cornerRadius = 25
        applyShadow()
        
        guard let weight = daily.weight else { return }
        
        weightLabel.text = String(describing: weight)
        averageLabel.text = String(describing: averageWeight)
        
        configurePhoto(with: daily)
        configureNote(with: daily)
    }
    
    private func configurePhoto(with daily: DailyData) {
        
        photoImage.layer.cornerRadius = 25
        
        let hasPhoto = daily.photo != nil ? true : false
        
        if hasPhoto { photoImage.loadImage(daily.photo?.url) }
        photoPlaceholderLabel.isHidden = hasPhoto
        photoImage.isHidden = !hasPhoto
    }
    
    private func configureNote(with daily: DailyData) {
        
        noteTextView.applyBorder()
        noteTextView.layer.cornerRadius = 25
        noteTextView.layer.borderWidth = 0
        noteTextView.text = daily.note
        noteTextView.isEditable = false
        
        let hasNote = daily.note != nil ? true : false
        
        notePlaceholderImage.isHidden = hasNote
        notePlaceholderLabels.forEach { $0.isHidden = hasNote }
        noteTextView.isHidden = !hasNote
    }
    
    private func configureTapGesture() {

        let photoRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoDidTap))
        let noteRecognizer = UITapGestureRecognizer(target: self, action: #selector(noteDidTap))
        
        photoImage.isUserInteractionEnabled = true
        noteTextView.isUserInteractionEnabled = true
        photoImage.addGestureRecognizer(photoRecognizer)
        noteTextView.addGestureRecognizer(noteRecognizer)
    }

    @objc private func photoDidTap() {

        photoImage.showButtonFeedbackAnimation {}
    }
    
    @objc private func noteDidTap() {

        noteTextView.showButtonFeedbackAnimation {}
    }
}
