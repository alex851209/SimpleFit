//
//  MonthFavoriteVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/16.
//

import UIKit
import Gemini

class MonthFavoriteVC: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionView: GeminiCollectionView!
    
    @IBAction func backButtonDidTap(_ sender: Any) { navigationController?.popViewController(animated: true) }
    
    var favorite = Favorite()
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDateLabel(with: index)
        configureCollectionView()
    }
    
    private func configureDateLabel(with index: Int) {
        
        let date = favorite.dailys[index].date
        
        dateLabel.text = date
        dateLabel.applyBorder()
    }
    
    private func configureCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.collectionViewLayout = layout(withParentView: view)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        collectionView.gemini
            .customAnimation()
            .translation(x: 0, y: 50, z: 0)
            .rotationAngle(x: 0, y: 13, z: 0)
            .ease(.easeOutExpo)
    }
    
    private func layout(withParentView parentView: UIView) -> UICollectionViewFlowLayout {
        
        let layout = PagingFlowLayout()
        let width = parentView.frame.width - 80
        layout.itemSize = CGSize(width: width, height: 520)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private func detectSelectedCell(_ scrollView: UIScrollView) {

        let center = view.convert(collectionView.center, to: collectionView)
        
        if let indexPath = collectionView.indexPathForItem(at: center) { self.index = indexPath.item }
    }
}

extension MonthFavoriteVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int { return favorite.dailys.count }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        let reuseID = String(describing: MonthFavoriteCell.self)
        
        guard let favoriteCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseID,
                for: indexPath
        ) as? MonthFavoriteCell else { return cell }
        
        favoriteCell.layoutCell(with: favorite.dailys[indexPath.row])
        
        return favoriteCell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        
        if let cell = cell as? GeminiCell { self.collectionView.animateCell(cell) }
    }
}

extension MonthFavoriteVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { collectionView.animateVisibleCells() }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        detectSelectedCell(scrollView)
        configureDateLabel(with: index)
    }
}
