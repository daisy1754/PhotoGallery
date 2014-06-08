//
//  ViewController.swift
//  PhotoGalleryDemo
//
//  Created by Kazuki Nishiura on 2014/06/07.
//  Copyright (c) 2014年 Emaki inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openGridView() {
        // Images are from http://free.foto.ne.jp
        let dataSource = SimplePhotoGalleryDataSource(photos: [
            resourceImageUrlForName("beach", type: "jpeg"),
            resourceImageUrlForName("evening", type: "jpeg"),
            resourceImageUrlForName("sky", type: "jpeg"),
            resourceImageUrlForName("beach2", type: "jpeg"),
            resourceImageUrlForName("sky2", type: "jpeg"),
            NSURL.URLWithString("https://dl.dropboxusercontent.com/u/5282183/photogallerysrc/coral.jpeg"),
            NSURL.URLWithString("https://dl.dropboxusercontent.com/u/5282183/photogallerysrc/fireworks.jpeg"),
            NSURL.URLWithString("https://dl.dropboxusercontent.com/u/5282183/photogallerysrc/in_the_sea.jpeg")
            ]);
        let photoGridController = PhotoGridViewController(dataSource: dataSource)
        let navigationController = UINavigationController(rootViewController:photoGridController)
        self.presentViewController(navigationController, animated:false, completion: nil)
    }

    func resourceImageUrlForName(name: NSString, type: NSString) -> NSURL {
        let path = NSBundle.mainBundle().pathForResource(name, ofType: type)
        return NSURL(fileURLWithPath: path)
    }
}

