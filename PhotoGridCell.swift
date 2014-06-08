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
    var progressView: DACircularProgressView = DACircularProgressView(frame: CGRectMake(0, 0, 40.0, 40.0))
    var photo: PhotoItem? {
        didSet {
            showLocalImage()

            // If local image doesn't exist, it should be loaded outside. We just show loading indicator here
            setProgressVisibility(imageView.image ? false : true)
        }
    }

    init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        progressView.userInteractionEnabled = false
        progressView.thicknessRatio = 0.1
        progressView.roundedCorners = Int(false)
        progressView.progressTintColor = UIColor(red: 210.0/255, green: 210.0/225, blue: 210.0/225, alpha:1)
        progressView.trackTintColor = UIColor(red: 230.0/255, green: 230.0/225, blue: 230.0/225, alpha:1)
        addSubview(progressView)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"updateProgress:", name:NotificationPhotoLoadingProgress, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("handleLoadCompletion:"), name:NotificationPhotoLoadingEnd, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        progressView.frame = CGRectMake(
            (self.bounds.size.width - progressView.frame.size.width) / 2,
            (self.bounds.size.width - progressView.frame.size.width) / 2,
            progressView.frame.size.width,
            progressView.frame.size.height
        )
    }
    
    override func prepareForReuse() {
        imageView.image = nil;
        progressView.progress = 0
    }

    func setProgressVisibility(visible: Bool) {
        progressView.hidden = !visible
        if (visible) {
            progressView.progress = 0
        }
    }

    func showLocalImage() {
        imageView.image = photo!.localImage()
    }

    func showFailureImage() {
        // TODO
    }
// Handle notifications
    func updateProgress(notification: NSNotification) {
        let dict = notification.object as NSDictionary
        let photo = dict.objectForKey("photo") as PhotoItem
        if (photo != self.photo) {
            return
        }
        var progress = dict.valueForKey("progress").floatValue
        if progress > 1 {
            progress = 1
        } else if progress < 0 {
            progress = 0
        }
        self.progressView.progress = progress
    }
    
    func handleLoadCompletion(notification: NSNotification) {
        let photo = notification.object as PhotoItem
        if (photo != self.photo) {
            return
        }
        if (photo.localImage()) {
            showLocalImage()
        } else {
            showFailureImage()
        }
        setProgressVisibility(false)
     }
}