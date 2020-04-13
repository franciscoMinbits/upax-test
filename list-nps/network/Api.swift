//
//  Api.swift
//  nps
//
//  Created by Ascenzo on 01/04/20.
//  Copyright © 2020 kinedu. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
  case loadNPS
  
  var method: Alamofire.HTTPMethod {
    switch self {
    case  .loadNPS:
      return .get
    }
  }
  
  var path: String! {
    switch self {
    case .loadNPS:
      return "helloWorld"
    }
  }
  
  func asURLRequest() throws -> URLRequest {
    let _path = path.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    let completeURL = "https://us-central1-bibliotecadecontenido.cloudfunctions.net/"
    let baseUrl = URL(string: completeURL)!
    let _URL = URL(string: _path!, relativeTo: baseUrl)!
    var mutableURLRequest = URLRequest(url: _URL)
    mutableURLRequest.timeoutInterval = 10
    mutableURLRequest.httpMethod = method.rawValue
    print(_URL.absoluteString)
    switch self {
    case .loadNPS:
      return try Alamofire.JSONEncoding().encode(mutableURLRequest, with: nil)
    }
  }
}
