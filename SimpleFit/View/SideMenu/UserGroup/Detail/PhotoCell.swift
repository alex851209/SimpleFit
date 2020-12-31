//
//  PhotoCell.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/17.
//

import UIKit
import Gemini

class PhotoCell: UITableViewCell {

    @IBOutlet weak var collectionView: GeminiCollectionView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var photoCountLabel: UILabel!
    
    @IBAction func addButtonDidTap(_ sender: UIButton) { addPhoto(sender) }
    
    var showDetail: ((Int) -> Void)?
    var callback: (() -> Void)?
    var albums = [Album]()
    
    func layoutCell(with albums: [Album]) {
        
        self.albums = albums
        photoCountLabel.text = "1 / \(albums.count)"
        photoCountLabel.isHidden = albums.isEmpty
        emptyLabel.isHidden = !albums.isEmpty
        configureCollectionView()
    }
    
    private func addPhoto(_ sender: UIButton) {
        
        sender.showButtonFeedbackAnimation { self.callback?() }
    }
    
    private func configureCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.collectionViewLayout = layout(withParentView: self)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.gemini
            .customAnimation()
            .translation(x: 0, y: 30, z: 0)
            .rotationAngle(x: 0, y: 13, z: 0)
            .ease(.easeOutExpo)
    }
    
    private func layout(withParentView parentView: UIView) -> UICollectionViewFlowLayout {
        
        let layout = PagingFlowLayout()
        let width = parentView.frame.width - 80
        let height = parentView.frame.height
        
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private func detectSelectedCell(_ scrollView: UIScrollView) {

        let center = contentView.convert(collectionView.center, to: collectionView)
        
        if let indexPath = collectionView.indexPathForItem(at: center) {
            
            photoCountLabel.text = "\(indexPath.item + 1) / \(albums.count)"
        }
    }
}

extension PhotoCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return albums.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        let reuseID = String(describing: PhotoCollectionCell.self)
        
        guard let photoCollectionCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseID,
                for: indexPath
        ) as? PhotoCollectionCell else { return cell }
        
        photoCollectionCell.layoutCell(with: albums[indexPath.item])
        
        return photoCollectionCell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        
        if let cell = cell as? GeminiCell { self.collectionView.animateCell(cell) }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        collectionView.cellForItem(at: indexPath)?.showButtonFeedbackAnimation { [weak self] in
            
            self?.showDetail?(indexPath.item)
        }
    }
}

extension PhotoCell {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { collectionView.animateVisibleCells() }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { detectSelectedCell(scrollView) }
}
