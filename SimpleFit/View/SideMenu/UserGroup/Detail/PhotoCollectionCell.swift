//
//  PhotoCollectionCell.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/18.
//

import UIKit
import Gemini

class PhotoCollectionCell: GeminiCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    
    func layoutCell(with album: Album) {
        
        photoImage.layer.cornerRadius = 15
        photoImage.loadImage(album.url)
    }
}
