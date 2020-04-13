//
//  ApplicationExt.swift
//  nps
//
//  Created by Ascenzo on 05/04/20.
//  Copyright © 2020 kinedu. All rights reserved.
//

import Foundation
import UIKit
extension UIApplication {
  
  
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
