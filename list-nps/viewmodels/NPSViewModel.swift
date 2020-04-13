//
//  NPSViewModel.swift
//  nps
//
//  Created by Ascenzo on 02/04/20.
//  Copyright © 2020 kinedu. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Firebase

final class NPSViewModel {
  private let locator: BaseUseCaseLocatorProtocol
  var colorValue = BehaviorRelay<String?>(value: nil)
  var errorMessage: BehaviorRelay<String?> = BehaviorRelay(value: nil)
  var isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
  var npsData: BehaviorRelay<NPSData?> =  BehaviorRelay(value: nil)
  var items: BehaviorRelay<[Int]> =  BehaviorRelay(value: [1,2,3])
  var ref: DatabaseReference?
  var refStorage: StorageReference?
  var uploadedImage: BehaviorRelay<Bool> = BehaviorRelay(value: false)
  var username = BehaviorRelay<String>(value: "")
  init( locator: BaseUseCaseLocatorProtocol) {
    self.locator = locator
    ref = Database.database().reference()
    refStorage = Storage.storage().reference()
    ref?.child("color").observe(DataEventType.value, with: { (snapshot) in
      if let color = snapshot.value as? String {
        self.colorValue.accept(color)
      }
    })
    loadNPS()
  }
  
  func loadNPS(refresh: Bool  = false){
    if let npsUseCase = locator.getUseCase(ofType: NPSUseCaseProtocol.self)  {
      isLoading.accept(true)
      if refresh {
        npsData.accept(nil)
      }
      
      npsUseCase.loadNPS(){[weak self] result in
        self?.didFinish(result: result)
      }
    }
  }
  func uploadMedia( data: Data?) {
    if self.username.value.count < 1 {
      errorMessage.accept("empty name")
      return
    }
    guard let data = data else {
      errorMessage.accept("empty image")
      return
    }
    
    isLoading.accept(true)
    refStorage?.child("\(self.username.value).png").putData(data, metadata: nil) { (metadata, error) in
      self.isLoading.accept(false)
      if error != nil {
        self.uploadedImage.accept(false)
      } else {
        self.uploadedImage.accept(true)
      }
    }
    
  }
}

extension NPSViewModel {
  private func didFinish(result: ServiceResponse) {
    isLoading.accept(false)
    switch result {
    case .successLoadNPS(let data):
      self.npsData.accept(data)
    default:
      errorMessage.accept("connection error")
    }
  }
  
  private func saveData(data: NPSData){
    
  }
}
