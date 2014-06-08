//
//  PhotoGalleryDelegate.swift
//  PhotoGalleryDemo
//
//  Created by Kazuki Nishiura on 2014/06/09.
//  Copyright (c) 2014年 Emaki inc. All rights reserved.
//

import Foundation

protocol PhotoGalleryDelegate {
    // TODO make following method optional. That requires protocol to be @objc, and in my environment doing so causes compile error with segmentaiton fault. I suspect that is caused by bug in compiler. Leave it non-optional for now.
    func uiActivitiesForSinglePhoto() -> UIActivity[]
}