//
//  AddMenuView.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/30.
//

import UIKit

protocol AddMenuViewDelegate: AnyObject {
    
    func showAddWeight()
    
    func showCamera()
    
    func showAlbum()
    
    func showAddNote()
}

class AddMenuView: UIView {

    var addMenuButton = UIButton()
    var weightButton = UIButton()
    var cameraButton = UIButton()
    var albumButton = UIButton()
    var noteButton = UIButton()
    var buttons = [UIButton]()
    var isAddMenuOpen = false
    
    weak var delegate: AddMenuViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func configure() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(addMenuButton)
        addMenuButton.applyAddButton()
        addMenuButton.setImage(UIImage.asset(.add), for: .normal)
        addMenuButton.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
        
        buttons = [noteButton, albumButton, cameraButton, weightButton]
        
        weightButton.setImage(UIImage.asset(.weight), for: .normal)
        cameraButton.setImage(UIImage.asset(.camera), for: .normal)
        albumButton.setImage(UIImage.asset(.album), for: .normal)
        noteButton.setImage(UIImage.asset(.note), for: .normal)
        
        weightButton.addTarget(self, action: #selector(weightButtonDidTap), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(cameraButtonDidTap), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(albumButtonDidTap), for: .touchUpInside)
        noteButton.addTarget(self, action: #selector(noteButtonDidTap), for: .touchUpInside)
        
        buttons.forEach {
            $0.alpha = 0
            addSubview($0)
            $0.applyAddMenuButton()
            $0.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
            
            NSLayoutConstraint.activate([
                $0.centerXAnchor.constraint(equalTo: addMenuButton.centerXAnchor),
                $0.centerYAnchor.constraint(equalTo: addMenuButton.centerYAnchor)
            ])
        }
    }
    
    @objc private func toggleMenu() {
        
        var padding: CGFloat = 70
        
        if isAddMenuOpen {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, animations: { [weak self] in
                self?.addMenuButton.transform = .identity
                
                self?.buttons.forEach {
                    $0.alpha = 0
                    $0.transform = CGAffineTransform(translationX: 0, y: padding)
                    padding += 70
                }
            })
            isAddMenuOpen = false
        } else {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, animations: { [weak self] in
                self?.addMenuButton.transform = CGAffineTransform(rotationAngle: .pi * 1.25)
                
                self?.buttons.forEach {
                    $0.alpha = 1
                    $0.transform = CGAffineTransform(translationX: 0, y: -padding)
                    padding += 70
                }
            })
            isAddMenuOpen = true
        }
    }
    
    @objc private func weightButtonDidTap() { delegate?.showAddWeight() }
    
    @objc private func cameraButtonDidTap() { delegate?.showCamera() }
    
    @objc private func albumButtonDidTap() { delegate?.showAlbum() }
    
    @objc private func noteButtonDidTap() { delegate?.showAddNote() }
}
