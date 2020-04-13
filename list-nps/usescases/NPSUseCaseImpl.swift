//
//  NPSUseCaseImpl.swift
//  nps
//
//  Created by Ascenzo on 01/04/20.
//  Copyright © 2020 kinedu. All rights reserved.
//

import Foundation

class NPSUseCaseImpl: BaseUseCaseImpl, NPSUseCaseProtocol {

  
  func loadNPS(completion: @escaping (ServiceResponse) -> Void) {
    service.loadNPS {
      switch $0 {
      case .successLoadNPS(let data):
        completion(.successLoadNPS(data: data))
      case .timeOut:
        completion(.timeOut)
      case .notConnectedToInternet:
        completion(.notConnectedToInternet)
      case .failure:
        completion(.failure)
      default:
        break
      }
    }
  }
}
