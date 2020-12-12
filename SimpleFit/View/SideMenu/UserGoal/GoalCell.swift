//
//  GoalCell.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/8.
//

import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var beginDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var beginWeight: UILabel!
    @IBOutlet weak var endWeight: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressTitleLabel: UILabel!
    
    func layoutCell(with goal: Goal, currentWeight: Double) {
        
        beginWeight.applyBorder()
        beginWeight.layer.borderWidth = 0
        endWeight.applyBorder()
        endWeight.layer.borderWidth = 0
        
        titleLabel.text = goal.title
        beginDate.text = goal.beginDate
        beginWeight.text = "\(goal.beginWeight)"
        endDate.text = goal.endDate
        endWeight.text = "\(goal.endWeight)"
        
        var progress = (abs(currentWeight - goal.beginWeight) / (goal.endWeight - goal.beginWeight)).round(to: 2)
        if progress > 1 { progress = 1 }
        progressTitleLabel.text = String(format: "%.0f", progress * 100) + "%"
        triggerProgressView(with: Float(progress))
    }
    
    private func triggerProgressView(with progress: Float) {

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 1,
            delay: 0,
            options: [.curveLinear, .beginFromCurrentState, .preferredFramesPerSecond60]
        ) { [weak self] in

            self?.progressView.setProgress(progress, animated: true)
        }
    }
}
