//
//  SearchModel.swift
//  githubExample
//
//  Created by 신동규 on 29/04/2019.
//  Copyright © 2019 신동규. All rights reserved.
//

struct SearchModel : Codable {
    
    public let total_count : Int?
    public let incomplete_results : Bool?
    public var items : [Items]?
    
    enum CodingKeys: String, CodingKey {
        case total_count = "total_count"
        case incomplete_results = "incomplete_results"
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total_count = try values.decodeIfPresent(Int.self, forKey: .total_count)
        incomplete_results = try values.decodeIfPresent(Bool.self, forKey: .incomplete_results)
        items = try values.decodeIfPresent([Items].self, forKey: .items)
    }
}
