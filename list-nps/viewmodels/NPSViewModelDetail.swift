//
//  NPSViewModelDetail.swift
//  list-nps
//
//  Created by Ascenzo on 13/04/20.
//  Copyright © 2020 mm. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Firebase

final class NPSViewModelDetail {
  private let locator: BaseUseCaseLocatorProtocol
  var questions: BehaviorRelay<[NPSQuestion]> =  BehaviorRelay(value: [])
  var colors: BehaviorRelay<[String]> =  BehaviorRelay(value: [])
  var npsData: BehaviorRelay<NPSData?> =  BehaviorRelay(value: nil)
  init( locator: BaseUseCaseLocatorProtocol) {
    self.locator = locator
   
    
  }
  
}
