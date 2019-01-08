//
//  SeatGeekApiError.swift
//  SeatGeekService
//
//  Created by Maksim Orlovich on 1/3/19.
//

import Foundation

public struct SeatGeekApiError: Error {
    public let message: String
    public let code: Int?
}

// Error reporting by Seatgeek API is inconsistent...
// It appears to have these two variants, but possibly others too
//
// {
//     "status": 400,
//     "message": "page size too large. maximum 5000",
//     "meta": {
//         "status": 400
//     }
// }
//
// {
//     "status": "error",
//     "themes": [],
//     "message": "Not Found",
//     "code": 404,
//     "domain_information": []
// }
extension SeatGeekApiError: Decodable {
    private enum CodingKeys: CodingKey {
        case message
        case status
        case code
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try values.decode(String.self, forKey: .message)
        
        if let status = try? values.decode(Int.self, forKey: .status) {
            self.code = status
        } else if let code = try? values.decode(Int.self, forKey: .code) {
            self.code = code
        } else {
            self.code = nil
        }
    }
}
