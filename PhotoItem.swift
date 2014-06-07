//
//  PhotoItem.swift
//  PhotoGalleryDemo
//
//  Created by Kazuki Nishiura on 2014/06/07.
//  Copyright (c) 2014年 Emaki inc. All rights reserved.
//

import Foundation
import UIKit

class PhotoItem : NSObject {
    var url: NSURL
    var image: UIImage?

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
}