//
//  AlbumDetailVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/24.
//

import UIKit

class AlbumDetailVC: BlurViewController {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    var album: Album?
    
    private func configureLayout() {
        
        albumImageView.loadImage(album?.url)
        albumImageView.layer.cornerRadius = 15
        
        nameLabel.text = album?.name
        
        guard let createdTime = album?.createdTime else { return }
        createdTimeLabel.text = DateProvider.dateToDateString(createdTime)
    }
}
