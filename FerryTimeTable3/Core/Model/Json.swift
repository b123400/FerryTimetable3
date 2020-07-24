//
//  json.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/24.
//  Copyright © 2020 b123400. All rights reserved.
//

import Foundation

enum FailableJson<T: Decodable>: Decodable {
    case fail(DecodingError)
    case success(T)
    
    init(from decoder: Decoder) throws {
        do {
            let value = try T.init(from: decoder)
            self = .success(value)
        } catch let error as DecodingError {
            self = .fail(error)
        }
    }
}
