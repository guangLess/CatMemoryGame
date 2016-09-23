//
//  extension.swift
//  Match.cat.GuangZ
//
//  Created by Guang on 7/7/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func fadeIn() {
     UIView.animateWithDuration(1.3, delay: 0.3, options: .CurveEaseIn, animations: {
        self.alpha = 1.0
        }, completion: nil)
    }
    func fadeOut() {
      UIView.animateWithDuration(1.7, delay: 0.5, options: .CurveEaseOut, animations: {
        self.alpha = 0.0
        }, completion: nil)
        }
}