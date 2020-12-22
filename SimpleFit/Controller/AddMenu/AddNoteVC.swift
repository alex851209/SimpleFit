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
    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var backgroundCardView: CardView!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        
        SFProgressHUD.showLoading()
        addNote()
    }
    
    var callback: ((Int, Int) -> Void)?
    let provider = ChartProvider()
    var selectedDate = Date()
    var selectedYear = Date().year()
    var selectedMonth = Date().month()
    var selectedDateString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        toggleTextView()
    }
    
    private func configureLayout() {
        
        datePicker.maximumDate = selectedDate
        datePicker.applyBorder()
        datePicker.addTarget(self, action: #selector(dateDidPick), for: .valueChanged)
        
        noteTextView.delegate = self
        
        pinImage.transform = CGAffineTransform(rotationAngle: .pi * 0.2)
        cardView.transform = CGAffineTransform(rotationAngle: -.pi * 0.02)
        backgroundCardView.transform = CGAffineTransform(rotationAngle: .pi * 0.03)
    }
    
    private func toggleTextView() {
        
        selectedDateString = DateProvider.dateToDateString(selectedDate)
        
        if noteTextView.textColor == UIColor.systemGray3 {
            
            noteTextView.textColor = .systemGray
            noteTextView.text = nil
        } else if noteTextView.text.isEmpty {
            
            noteTextView.textColor = .systemGray3
            noteTextView.text = "\(selectedDateString)\n請輸入筆記"
        }
    }
    
    private func addNote() {
        
        guard let note = noteTextView.text,
              noteTextView.textColor == UIColor.systemGray
        else {
            SFProgressHUD.showFailed(with: "請輸入筆記")
            return
        }
        
        let daily = DailyData(note: note)
        provider.addDataWith(dailyData: daily, field: .note, date: selectedDate, completion: { [weak self] result in
            
            switch result {
            
            case .success(let note):
                let dateString = String(describing: self?.selectedDate)
                print("Success adding new note: \(note) on date: \(dateString)")
                
                SFProgressHUD.showSuccess()
                
                guard let selectedYear = self?.selectedYear,
                      let selectedMonth = self?.selectedMonth
                else { return }
                
                self?.callback?(selectedYear, selectedMonth)
                self?.dismiss(animated: true)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    @objc private func dateDidPick(sender: UIDatePicker) {
        
        selectedDate = sender.date
        selectedYear = selectedDate.year()
        selectedMonth = selectedDate.month()
        
        if noteTextView.textColor == .systemGray3 {
            
            selectedDateString = DateProvider.dateToDateString(selectedDate)
            noteTextView.text = "\(selectedDateString)\n請輸入筆記"
        }
    }
}

extension AddNoteVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) { toggleTextView() }
    
    func textViewDidEndEditing(_ textView: UITextView) { toggleTextView() }
}
