//
//  PhotoItem.swift
//  PhotoGalleryDemo
//
//  Created by Kazuki Nishiura on 2014/06/07.
//  Copyright (c) 2014年 Emaki inc. All rights reserved.
//

import Foundation
import UIKit

let NotificationPhotoLoadingEnd = "photoLodingEnd"
let NotificationPhotoLoadingProgress = "photoLoadingProgress"

class PhotoItem : NSObject {
    var url: NSURL
    var image: UIImage?
    var loading = false
    var loadingOperation: SDWebImageOperation?

    init(url: NSURL) {
        self.url = url
    }

    func localImage() -> UIImage? {
        if (image) {
            return image!
        } else if (url.fileURL) {
            return UIImage(contentsOfFile:url.path);
        }
        return nil;
    }

    func startLoadingRemoteImageAndNotify() {
        // TODO: needs to consiter synchronization to avoid duplicate loading. Swift currently not seems to have @synchronized keyword
        if (loading) {
            return
        }
        loading = true
        loadingOperation = SDWebImageManager.sharedManager().downloadWithURL(url, options: nil,
            progress: {(receivedSize: Int, expectedSize: Int) in
                if (expectedSize <= 0) {
                    return
                }
                let progress = Float(receivedSize) / Float(expectedSize)
                let dict = NSDictionary(objects:[progress, self], forKeys:["progress", "photo"])
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationPhotoLoadingProgress, object:dict)
            },
            completed:{(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, finished: Bool) in
                if (error) {
                    NSLog("Photo loading error from url  \(error)")
                }
                self.loadingOperation = nil
                self.image = image
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationPhotoLoadingEnd, object:self)
                self.loading = false
            })
    }
}