//
//  SimplePhotoDataSource.swift
//  PhotoGalleryDemo
//
//  Created by Kazuki Nishiura on 2014/06/07.
//  Copyright (c) 2014年 Emaki inc. All rights reserved.
//

import Foundation

class SimplePhotoGalleryDataSource : PhotoGalleryDataSource {
    let photos: NSURL[]
    init(photos: NSURL[]) {
        self.photos = photos;
    }

    func numberOfPhotos() -> Int {
        return photos.count;
    }

    func itemForPhotoAtIndexPath(indexPath: NSIndexPath!) -> PhotoItem {
        return PhotoItem(url: photos[indexPath.row])
    }
}