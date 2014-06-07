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
        let dataSource = SimplePhotoGalleryDataSource(photos: [
            resourceImageUrlForName("beach", type: "jpeg"),
            resourceImageUrlForName("evening", type: "jpeg"),
            resourceImageUrlForName("sky", type: "jpeg"),
            resourceImageUrlForName("beach2", type: "jpeg"),
            resourceImageUrlForName("sky2", type: "jpeg"),
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

