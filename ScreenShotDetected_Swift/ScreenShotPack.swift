//
//  ScreenShotPack.swift
//  ScreenShotPack_Swift
//
//  Created by Tech-zhangyangyang on 2017/4/20.
//  Copyright © 2017年 Tech-zhangyangyang. All rights reserved.
//

import UIKit

class ScreenShotPack: NSObject {
    
    static let sharedSingleOne = ScreenShotPack()  // 创建单例
    
    func embedApplication(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)  {
        // 注册截屏通知
        NotificationCenter.default.addObserver(self, selector: #selector(userDidTakeScreenshot(notification:)), name: .UIApplicationUserDidTakeScreenshot, object: nil)
    }
    
    func userDidTakeScreenshot(notification:NSNotification)  {
        let image:UIImage = self.imageWithScreenshot()
        let window = UIApplication.shared.windows[0]
        
        // 添加显示
        let imgvPhoto = UIImageView(image:image)
        imgvPhoto.frame = CGRect(x:window.frame.size.width/2,y:window.frame.size.height/2,width:window.frame.size.width/2,height:window.frame.size.height/2)
        
        // 添加边框
        let layer = imgvPhoto.layer
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 5
        
        // 添加四个边阴影
        imgvPhoto.layer.shadowColor   = UIColor.black.cgColor
        imgvPhoto.layer.shadowOffset  = CGSize(width:0,height:0)
        imgvPhoto.layer.shadowOpacity = 0.5
        imgvPhoto.layer.shadowRadius  = 10
        
        // 添加四个边阴影
        imgvPhoto.layer.shadowColor   = UIColor.black.cgColor
        imgvPhoto.layer.shadowOffset  = CGSize(width:4,height:4)
        imgvPhoto.layer.shadowOpacity = 0.5
        imgvPhoto.layer.shadowRadius  = 2.0
        window.addSubview(imgvPhoto)
    }
    
    func imageWithScreenshot() -> UIImage {
        return self.dataWithScreenshotInPNGFormat()
    }

    // 获取到截屏图片
    func dataWithScreenshotInPNGFormat() -> UIImage {
        var imageSize = CGSize.zero
        let orientation = UIApplication.shared.statusBarOrientation
        imageSize = UIScreen.main.bounds.size
        if UIInterfaceOrientationIsPortrait(orientation) {
            imageSize = UIScreen.main.bounds.size
        }
        else {
            imageSize = CGSize(width:UIScreen.main.bounds.size.height,height:UIScreen.main.bounds.size.width)
        }
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        for window  in UIApplication.shared.windows {
           context!.saveGState()
           context!.translateBy(x: window.center.x, y: window.center.y)
           context!.concatenate(window.transform)
           context!.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x, y: -window.bounds.size.height * window.layer.anchorPoint.y)
            if orientation == .landscapeLeft {
                context!.rotate(by: CGFloat(M_PI_2))
                context!.translateBy(x: 0, y: -imageSize.width)
            }
            else if orientation == .landscapeRight {
                context!.rotate(by: CGFloat(-M_PI_2))
                context!.translateBy(x: -imageSize.height, y: 0)
            }else if orientation == .portraitUpsideDown {
                context!.rotate(by: CGFloat(M_PI))
                context!.translateBy(x: -imageSize.width, y: -imageSize.height)
            }
            
            if window.responds(to: #selector(window.drawHierarchy)) {
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
            }else {
                window.layer.render(in: context!)
            }
            context!.restoreGState()
        }
        let image:UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
       return image
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: .UIApplicationUserDidTakeScreenshot, object: nil)
    }
}
