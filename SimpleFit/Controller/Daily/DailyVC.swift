//
//  DetailVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/1.
//

import UIKit
import Gemini

class DailyVC: BlurViewController {
    
    private struct Segue {
        
        static let photoDetail = "SeguePhotoDetail"
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dailyCollectionView: GeminiCollectionView!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    
    var selectedDaily = DailyData()
    var dailys = [DailyData]()
    var isFirstShow = true
    var selectedPhoto: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureSelectedDaily()
    }
    
    private func configureLayout() {
        
        let month = selectedDaily.month
        let day = selectedDaily.day
        
        dateLabel.text = month + "-" + day
        dateLabel.applyBorder()
    }
    
    private func configureSelectedDaily() {
        
        guard let index = dailys.firstIndex(of: selectedDaily) else { return }
        
        if isFirstShow {
            
            dailyCollectionView.scrollToItem(at: IndexPath(item: index, section: 0),
                                             at: .centeredHorizontally, animated: false)
            isFirstShow = false
        }
    }
    
    private func calculateAverageWeight() -> Double {
        
        var sum: Double = 0
        
        dailys.forEach {
            
            guard let weight = $0.weight else { return }
            sum += weight
        }
        return (sum / Double(dailys.count)).round(to: 1)
    }
    
    private func configureCollectionView() {
        
        dailyCollectionView.delegate = self
        dailyCollectionView.dataSource = self
        dailyCollectionView.showsHorizontalScrollIndicator = false
        dailyCollectionView.collectionViewLayout = layout(withParentView: view)
        dailyCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        let background = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        dailyCollectionView.gemini
            .customAnimation()
            .translation(x: 0, y: 50, z: 0)
            .rotationAngle(x: 0, y: 13, z: 0)
            .ease(.easeOutExpo)
            .shadowEffect(.fadeIn)
            .backgroundColor(startColor: background, endColor: background.withAlphaComponent(0.2))
            .maxShadowAlpha(0.3)
    }
    
    private func layout(withParentView parentView: UIView) -> UICollectionViewFlowLayout {
        
        let layout = PagingFlowLayout()
        let width = parentView.frame.width - 100
        layout.itemSize = CGSize(width: width, height: 520)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private func detectSelectedCell(_ scrollView: UIScrollView) {

        let center = view.convert(dailyCollectionView.center, to: dailyCollectionView)
        
        if let indexPath = dailyCollectionView.indexPathForItem(at: center) {
            
            dateLabel.text = dailys[indexPath.item].date
            selectedDaily = dailys[indexPath.item]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let photoDetailVC = segue.destination as? PhotoDetailVC else { return }
        
        photoDetailVC.selectedPhoto = selectedPhoto
        photoDetailVC.selectedDaily = selectedDaily
    }
}

extension DailyVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int { return dailys.count }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        let reuseID = String(describing: DailyCell.self)
        
        guard let dailyCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseID,
                for: indexPath) as? DailyCell
        else { return cell }
        
        let averageWeight = calculateAverageWeight()
        
        dailyCell.delegate = self
        dailyCell.layoutCell(with: dailys[indexPath.item], averageWeight: averageWeight)
        dailyCollectionView.animateCell(dailyCell)
        
        return dailyCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let cell = cell as? GeminiCell { self.dailyCollectionView.animateCell(cell) }
    }
}

extension DailyVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { dailyCollectionView.animateVisibleCells() }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {  detectSelectedCell(scrollView) }
}

extension DailyVC: DailyCellDelegate {
    
    func photoDidTap(with photo: UIImage) {
        
        selectedPhoto = photo
        performSegue(withIdentifier: Segue.photoDetail, sender: nil)
    }
}
