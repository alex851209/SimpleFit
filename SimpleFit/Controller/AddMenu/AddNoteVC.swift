//
//  AddNoteVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/3.
//

import UIKit
import MIBlurPopup

class AddNoteVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        
        addNote()
        dismiss(animated: true)
    }
    
    var callback: (() -> Void)?
    let provider = ChartProvider()
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        datePicker.applyBorder()
        datePicker.addTarget(self, action: #selector(dateDidPick), for: .valueChanged)
        
        noteTextView.transform = CGAffineTransform(rotationAngle: .pi * 0.05)
    }
    
    private func addNote() {
        
        guard let note = noteTextView.text else { return }
        
        let daily = DailyData(weight: nil, photo: nil, note: note)
        provider.addDataWith(dailyData: daily, field: .note, date: date, completion: { [weak self] _ in
            print("Success adding a note: \(note) on \(String(describing: self?.date))")
        })
    }
    
    @objc private func dateDidPick(sender: UIDatePicker) { date = sender.date }
}

extension AddNoteVC: MIBlurPopupDelegate {
    
    var popupView: UIView { view }
    var blurEffectStyle: UIBlurEffect.Style? { .systemUltraThinMaterial }
    var initialScaleAmmount: CGFloat { 0.1 }
    var animationDuration: TimeInterval { 0.7 }
}
