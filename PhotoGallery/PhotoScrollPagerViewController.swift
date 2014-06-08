//
//  PhotoScrollPagerViewController.swift
//  PhotoGalleryDemo
//
//  Created by Kazuki Nishiura on 2014/06/08.
//  Copyright (c) 2014年 Emaki inc. All rights reserved.
//

import Foundation
import UIKit

class PhotoScrollPagerViewController : UIViewController, UIScrollViewDelegate {
    let PhotoPadding: CGFloat = 10.0
    var dataSource: PhotoGalleryDataSource
    var currentIndex: Int
    var photosScroll: UIScrollView = UIScrollView()
    var numOfPhotos: Int = -1
    var photosCache: PhotoItem?[] = []
    var visiblePages: FullScreenPhotoView[] = []
    var recycledPages: FullScreenPhotoView[] = []
    
    init(dataSource: PhotoGalleryDataSource, currentIndex: Int) {
        self.dataSource = dataSource
        self.currentIndex = currentIndex
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        photosScroll.delegate = nil
    }

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.clipsToBounds = true

        photosScroll.frame = frameForScrollView()
        photosScroll.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        photosScroll.pagingEnabled = true
        photosScroll.delegate = self;
        photosScroll.showsHorizontalScrollIndicator = false;
        photosScroll.showsVerticalScrollIndicator = false;
        photosScroll.backgroundColor = UIColor.whiteColor()
        photosScroll.contentSize = contentSizeForScrollView()
        self.view.addSubview(photosScroll)

        reloadData()

        super.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutVisiblePages()
    }

    func layoutVisiblePages() {
        didStartViewingPageAtIndex(currentIndex)
    }

    func reloadData() {
        let count = numberOfPhotos()
        
        // TODO: prevent ongoing loading
        
        // Invalidate cache
        photosCache = []
        for var i = 0; i < count; i++ {
            photosCache.append(nil)
        }

        if (currentIndex < 0) { currentIndex = 0}
        if (currentIndex >= count) { currentIndex = count - 1 }

        // Update layout
        if (isViewLoaded()) {
            for subview: AnyObject in photosScroll.subviews {
                subview.removeFromSuperview()
            }
            performLayout()
            self.view.setNeedsLayout()
        }
    }

    func numberOfPhotos() -> Int {
        if (numOfPhotos < 0) {
            numOfPhotos = dataSource.numberOfPhotos()
        }
        return numOfPhotos
    }

    func photoAtIndex(index: Int) -> PhotoItem? {
        var photo = photosCache[index]
        if (photo) {
            return photo!
        }
        photo = dataSource.itemForPhotoAtIndexPath(NSIndexPath(indexes: [0, index], length: 2))
        photosCache[index] = photo
        return photo
    }

    func performLayout() {
        visiblePages = []
        recycledPages = []
        photosScroll.contentOffset = contentOffsetForPageAtIndex(currentIndex)
        layoutPages()
        updateTitle()
    }

    func layoutPages() {
        let visibleBounds = photosScroll.bounds
        var firstIndex = Int((CGRectGetMinX(visibleBounds) + PhotoPadding * 2) / visibleBounds.size.width)
        var lastIndex = Int((CGRectGetMaxX(visibleBounds) - PhotoPadding * 2) / visibleBounds.size.width)

        if (firstIndex < 0) { firstIndex = 0 }
        if (firstIndex >= numberOfPhotos()) { firstIndex = numberOfPhotos() - 1 }
        if (lastIndex < 0) { lastIndex = 0 }
        if (lastIndex >= numberOfPhotos()) { lastIndex = numberOfPhotos() - 1 }

        // Remove far pages
        let numOfVisiblePage = visiblePages.count
        for var i = numOfVisiblePage - 1; i >= 0; i-- {
            var page = visiblePages[i]
            if (page.indexInPager < firstIndex || lastIndex < page.indexInPager) {
                recycledPages.append(page)
                page.removeFromSuperview()
                visiblePages.removeAtIndex(i)
            }
        }

        // Restrict recycle pages size to two
        while (recycledPages.count > 2) {
            recycledPages.removeAtIndex(recycledPages.count - 1)
        }

        for var i = firstIndex; i <= lastIndex; i++ {
            if (!pageExistsForIndex(i)) {
                var page = dequeueRecycledPage()
                if (!page) {
                    page = FullScreenPhotoView(frame: self.view.frame)
                }
                visiblePages.append(page!)
                page!.frame = frameForPageAtIndex(i)
                page!.indexInPager = i
                page!.photo = photoAtIndex(i)
                if (page!.photo && !page!.photo!.localImage()) {
                    page!.photo!.startLoadingRemoteImageAndNotify()
                }
                photosScroll.addSubview(page)
            }
        }
    }

    func contentOffsetForPageAtIndex(index: Int) -> CGPoint {
        return CGPointMake(photosScroll.bounds.size.width * CGFloat(index), 0)
    }

    func pageExistsForIndex(index: Int) -> Bool {
        for page in visiblePages {
            if (page.indexInPager == index) {
                return true
            }
        }
        return false
    }

    func pageForPhoto(photo: PhotoItem) -> FullScreenPhotoView? {
        for page in visiblePages {
            if (page.photo == photo) {
                return page
            }
        }
        return nil
    }

    func dequeueRecycledPage() -> FullScreenPhotoView? {
        if (recycledPages.count > 0) {
            var page = recycledPages[recycledPages.count - 1]
            recycledPages.removeAtIndex(recycledPages.count - 1)
            return page
        }
        return nil
    }

    func didStartViewingPageAtIndex(var index: Int) {
        if (index < 0) { index = 0 }
        if (index >= numberOfPhotos()) { index = numberOfPhotos() - 1 }
        for var i = 0; i < numberOfPhotos(); i++ {
            if (i < index - 1 || index + 1 < i) {
                // TODO cancel loading
                photosCache[i] = nil
            }
        }
        let photo = photosCache[index]
        if (photo && photo!.localImage()) {
            // photo at current index is already loaded, so start loading adjacent photos
            loadAdjacentPhotos(photo!)
        }
    }

    func loadAdjacentPhotos(var photo: PhotoItem) {
        let page = pageForPhoto(photo)
        if (page && page!.indexInPager == currentIndex) {
            for i in [page!.indexInPager - 1, page!.indexInPager + 1] {
                if 0 <= i && i < numberOfPhotos() {
                    photoAtIndex(i)!.startLoadingRemoteImageAndNotify()
                }
            }
        }
    }

    func updateTitle() {
        if (numberOfPhotos() > 0) {
            self.title = "\(currentIndex + 1) of \(numberOfPhotos())"
        } else {
            self.title = ""
        }
    }

// UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        layoutPages()

        let visibleBounds = photosScroll.bounds
        var index: Int = Int(CGRectGetMaxX(visibleBounds) / visibleBounds.size.width)
        if (index < 0) { index = 0 }
        if (index >= numberOfPhotos()) { index = numberOfPhotos() - 1 }
        if (currentIndex != index) {
            currentIndex = index
            didStartViewingPageAtIndex(index)
        }
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        updateTitle()
    }

// Frame or position calculations
    func frameForScrollView() -> CGRect {
        let base = self.view.bounds
        return CGRectMake(base.origin.x - PhotoPadding, base.origin.y, base.size.width + (2 * PhotoPadding), base.size.height)
    }

    func frameForPageAtIndex(index: Int) -> CGRect {
        // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
        // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
        // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
        // because it has a rotation transform applied.
        var bounds = photosScroll.bounds
        return CGRectMake(bounds.size.width * CGFloat(index) + PhotoPadding, bounds.origin.y, bounds.size.width - (2 * PhotoPadding), bounds.size.height)
    }

    func contentSizeForScrollView() -> CGSize {
        let bounds = photosScroll.bounds;
        return CGSizeMake(bounds.size.width * CGFloat(numberOfPhotos()), bounds.size.height);
    }
}