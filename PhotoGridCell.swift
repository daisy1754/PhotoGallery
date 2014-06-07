//
//  PhotoGridCell.swift
//  PhotoGalleryDemo
//
//  Created by Kazuki Nishiura on 2014/06/07.
//  Copyright (c) 2014年 Emaki inc. All rights reserved.
//

import Foundation
import UIKit

class PhotoGridCell : UICollectionViewCell {
    var imageView: UIImageView = UIImageView()

    init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }
    
    override func prepareForReuse() {
        imageView.image = nil;
    }
    
    func setPhoto(photo: PhotoItem) {
        imageView.image = photo.localImage()
        if (!imageView.image) {
            NSLog("fail to load image")
        }
    }
}