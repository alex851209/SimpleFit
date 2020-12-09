//
//  UserFavoriteVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/3.
//

import UIKit
import Gemini

class UserFavoriteVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteCollectionView: GeminiCollectionView!
    
    @IBAction func backButtonDidTap(_ sender: Any) { navigationController?.popViewController(animated: true) }
    
    private let images = [
        UIImage.asset(.album),
        UIImage.asset(.camera),
        UIImage.asset(.note),
        UIImage.asset(.weight),
        UIImage.asset(.sideMenu)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureCollectionView()
    }
    
    private func configureLayout() { titleLabel.applyBorder() }
    
    private func layout(withParentView parentView: UIView) -> UICollectionViewFlowLayout {
        
        let layout = PagingFlowLayout()
        let width = parentView.frame.width - 100
        layout.itemSize = CGSize(width: width, height: 450)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private func configureCollectionView() {
        
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.showsHorizontalScrollIndicator = false
        favoriteCollectionView.collectionViewLayout = layout(withParentView: view)
        favoriteCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        let background = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        
        favoriteCollectionView.gemini
            .customAnimation()
            .translation(x: 0, y: 50, z: 0)
            .rotationAngle(x: 0, y: 13, z: 0)
            .ease(.easeOutExpo)
            .shadowEffect(.fadeIn)
            .backgroundColor(startColor: background, endColor: background.withAlphaComponent(0.2))
            .maxShadowAlpha(0.3)
    }
}

extension UserFavoriteVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int { return images.count }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        let reuseID = String(describing: FavoriteCell.self)
        
        guard let favoriteCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseID,
                for: indexPath) as? FavoriteCell,
              let image = images[indexPath.item]
        else { return cell }
        
        favoriteCell.layoutCell(with: image)
        favoriteCollectionView.animateCell(favoriteCell)
        
        return favoriteCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let cell = cell as? GeminiCell { self.favoriteCollectionView.animateCell(cell) }
    }
}

extension UserFavoriteVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { favoriteCollectionView.animateVisibleCells() }
}
