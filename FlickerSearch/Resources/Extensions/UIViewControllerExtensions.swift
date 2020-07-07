//
//  UIViewControllerExtensions.swift
//  FlickerSearch
//
//  Created by RAJESH KUMAR on 07/07/20.
//  Copyright © 2020 RAJESH KUMAR. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlertWithTitle(_ title: String, message: String) {
        let alertCntrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertCntrl.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertCntrl, animated: true, completion: nil)
    }
}
