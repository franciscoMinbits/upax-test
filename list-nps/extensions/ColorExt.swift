//
//  ColorExt.swift
//  list-nps
//
//  Created by Ascenzo on 06/04/20.
//  Copyright © 2020 mm. All rights reserved.
//

import Foundation
import Foundation
import UIKit

extension UIColor {
    
    class func baseColorA() -> UIColor {
        return UIColor(named: "BaseColorA")!
    }
  class func baseColorB() -> UIColor {
        return UIColor(named: "BaseColorB")!
    }
  func hexStringToUIColor (hex:String) -> UIColor {
      var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

      if (cString.hasPrefix("#")) {
          cString.remove(at: cString.startIndex)
      }

      if ((cString.count) != 6) {
          return UIColor.gray
      }

      var rgbValue:UInt64 = 0
      Scanner(string: cString).scanHexInt64(&rgbValue)

      return UIColor(
          red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
          green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
          blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
          alpha: CGFloat(1.0)
      )
  }
}
