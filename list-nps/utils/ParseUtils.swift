//
//  ParseUtils.swift
//  nps
//
//  Created by Ascenzo on 01/04/20.
//  Copyright © 2020 kinedu. All rights reserved.
//

import Foundation


class ParseUtils {
    
    static func parseNPSData(data: NSDictionary) -> NPSData?{
       do {
            let json = try JSONSerialization.data(withJSONObject: data)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let data = try decoder.decode(NPSData.self, from: json)
            return data
        } catch {
          return nil
        }
    }
}
