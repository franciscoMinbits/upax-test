//
//  UserRepositoryImpl.swift
//  nps
//
//  Created by Ascenzo on 01/04/20.
//  Copyright © 2020 kinedu. All rights reserved.
//

import Foundation

class UserRepositoryImpl: UserRepositoryProtocol {
  func loadNPSData(id: Int) -> NPSData? {
    return nil
  }
  
  

  func loadNPSData() -> [NPSData] {
     return []
  }
  
  
  func saveNPSData(data: [NPSData],completionHandler: @escaping (_ success:Bool, _ data:[NPSData]) -> Void) {
  }
}
