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
    @IBOutlet weak var removeButton: UIButton!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    @IBAction func removeButtonDidTap(_ sender: Any) { showRemoveAlert() }
    
    override var blurEffectStyle: UIBlurEffect.Style? { return .prominent }
    
    let provider = GroupProvider()
    var album: Album?
    var group: Group?
    var callback: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        albumImageView.loadImage(album?.url)
        albumImageView.layer.cornerRadius = 15
        
        nameLabel.text = album?.name
        
        removeButton.applyBorder()
        
        guard let createdTime = album?.createdTime else { return }
        createdTimeLabel.text = DateProvider.dateToDateString(createdTime)
    }
    
    private func showRemoveAlert() {
        
        let alert = SFAlertVC(title: "移除照片？", showAction: remove)
        
        removeButton.showButtonFeedbackAnimation { [weak self] in
            self?.present(alert, animated: true)
        }
    }
    
    private func remove() {
        
        guard let group = group,
              let id = album?.id
        else { return }
        
        SFProgressHUD.showLoading()
        
        provider.removeAlbum(of: id, in: group) { [weak self] result in
            switch result {
            case .success(let id):
                print("Success removing album: \(id)")
                self?.callback?()
                self?.dismiss(animated: true)
            case .failure(let error):
                print(error)
            }
        }
    }
}
