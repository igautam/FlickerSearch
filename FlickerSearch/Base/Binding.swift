//
//  Binding.swift
//  FlickerSearch
//
//  Created by RAJESH KUMAR on 30/06/20.
//  Copyright © 2020 RAJESH KUMAR. All rights reserved.
//

import Foundation

class Box<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T? {
        didSet {
            if let val = self.value {
                self.listener?(val)
            }
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        
//        if let val = value {
//            self.listener = listener
//            //listener?(val)
//        }
    }
}
