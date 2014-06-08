//
//  PhotoGridViewController.swift
//  PhotoGalleryDemo
//
//  Created by Kazuki Nishiura on 2014/06/07.
//  Copyright (c) 2014年 Emaki inc. All rights reserved.
//

import Foundation
import UIKit

struct PhotoGridDefaultSettings {
    static var NumOfColumn: Int = 3
    static var LineSpace: CGFloat = 2.0
    static var InterItemSpace: CGFloat = 2.0
    static func gridSize() -> CGSize {
        let size = UIScreen.mainScreen().bounds.size
        let shorter = size.height > size.width ? size.width : size.height
        let x = (CGFloat(shorter) - CGFloat(InterItemSpace) * CGFloat(NumOfColumn - 1)) / CGFloat(NumOfColumn)
        return CGSizeMake(x, x)
    }

    static var backgroundColor = UIColor.whiteColor()
}

class PhotoGridViewController : UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let ReuseIdentifier = "gridCell"
    var dataSource : PhotoGalleryDataSource;

    convenience init(dataSource: PhotoGalleryDataSource) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = PhotoGridDefaultSettings.gridSize()
        layout.headerReferenceSize = CGSizeMake(0, 0)
        layout.footerReferenceSize = CGSizeMake(0, 0)
        layout.minimumLineSpacing = PhotoGridDefaultSettings.LineSpace
        layout.minimumInteritemSpacing = PhotoGridDefaultSettings.InterItemSpace
        self.init(collectionViewLayout: layout, dataSource: dataSource)
        collectionView.backgroundColor = PhotoGridDefaultSettings.backgroundColor
    }

    init(collectionViewLayout layout: UICollectionViewLayout!, dataSource: PhotoGalleryDataSource) {
        self.dataSource = dataSource;
        super.init(collectionViewLayout: layout);
    }

    override func viewDidLoad() {
        self.collectionView.registerClass(PhotoGridCell.classForCoder(), forCellWithReuseIdentifier:ReuseIdentifier)
    }

    override func collectionView(collectionView: UICollectionView!,
        numberOfItemsInSection section: Int) -> Int {
            return dataSource.numberOfPhotos()
    }

    override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let grid = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifier, forIndexPath:indexPath) as PhotoGridCell
        let photo = dataSource.itemForPhotoAtIndexPath(indexPath)
        grid.photo = photo
        if (!photo.localImage()) {
            photo.startLoadingRemoteImageAndNotify()
        }
        return grid
    }
}