//
//  ViewController.swift
//  ScreenShotDetected_Swift
//
//  Created by Tech-zhangyangyang on 2017/4/20.
//  Copyright © 2017年 Tech-zhangyangyang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView()
        imageView.frame.size = UIScreen.main.bounds.size
        imageView.image = UIImage(named:"window.jpeg")
        self.view.addSubview(imageView)
    }
}

