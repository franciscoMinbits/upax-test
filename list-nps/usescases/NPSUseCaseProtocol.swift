//
//  NPSUseCaseProtocol.swift
//  nps
//
//  Created by Ascenzo on 01/04/20.
//  Copyright © 2020 kinedu. All rights reserved.
//

import Foundation

protocol NPSUseCaseProtocol {
  func loadNPS(completion: @escaping (ServiceResponse) -> Void)
}
