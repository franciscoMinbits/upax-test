//
//  NPSData.swift
//  nps
//
//  Created by Ascenzo on 01/04/20.
//  Copyright © 2020 kinedu. All rights reserved.
//

import Foundation


class NPSData: Codable {
  var colors:[String] = []
  var questions:[NPSQuestion] = []
}
class NPSQuestion: Codable {
  var total = 0
  var text = ""
  var chartData:[NPSCharData] = []
  
}

class NPSCharData: Codable {
  var percetnage = 0
  var text = ""
}
