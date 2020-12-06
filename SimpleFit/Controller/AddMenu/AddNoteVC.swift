//
//  AddNoteVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/3.
//

import UIKit

class AddNoteVC: BlurViewController {

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
        
        let daily = DailyData(note: note)
        provider.addDataWith(dailyData: daily, field: .note, date: date, completion: { [weak self] result in
            
            switch result {
            
            case .success(let note):
                let dateString = String(describing: self?.date)
                print("Success adding new note: \(note) on date: \(dateString)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    @objc private func dateDidPick(sender: UIDatePicker) { date = sender.date }
}
