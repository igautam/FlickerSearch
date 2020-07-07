//
//  AppDelegate.swift
//  FlickerSearch
//
//  Created by RAJESH KUMAR on 27/06/20.
//  Copyright © 2020 RAJESH KUMAR. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var indicatorView: UIActivityIndicatorView?
    var loaderBgView: UIView?
    
    static var delegate = UIApplication.shared.delegate as! AppDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

//MARK:- Setup Activity Indicator
//MARK:-
extension AppDelegate {
    func showIndicatorView() {
        if loaderBgView == nil {
            loaderBgView = UIView(frame: (self.window?.frame)!)
            loaderBgView?.backgroundColor = UIColor(red: 120.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 0.5)
            
            indicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            indicatorView?.style = .whiteLarge
            indicatorView?.center = (loaderBgView?.center)!
            loaderBgView?.addSubview(indicatorView!)
                 
            indicatorView?.startAnimating()
            window?.addSubview(loaderBgView!)
        }
    }
    
    func hideIndicatorView() {
        if let view = loaderBgView {
            indicatorView?.stopAnimating()
            view.removeFromSuperview()
            loaderBgView = nil
        }
    }
}
