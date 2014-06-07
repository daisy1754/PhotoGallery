//
//  PhotoGalleryDataSource.swift
//  PhotoGalleryDemo
//
//  Created by Kazuki Nishiura on 2014/06/07.
//  Copyright (c) 2014年 Emaki inc. All rights reserved.
//

import Foundation

protocol PhotoGalleryDataSource {
    func numberOfPhotos() -> Int
    func itemForPhotoAtIndexPath(indexPath: NSIndexPath!) -> PhotoItem
}