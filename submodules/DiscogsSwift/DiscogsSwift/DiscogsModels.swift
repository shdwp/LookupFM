//
//  DiscogsModels.swift
//  DiscogsSwift
//
//  Created by Vasyl Horbachenko on 7/6/19.
//  Copyright © 2019 shdwp. All rights reserved.
//

import Foundation
import ObjectMapper

/// typealias to hide ObjectMapper dependency
public typealias DiscogsModel = Mappable

/// Discogs item. Since we only need the thumbnail, it doesn't matter what the item is. Both artist and album provide it in the same way.
public struct DiscogsItem: Mappable {
    public var thumbnail: String?
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        self.thumbnail <- map["thumb"]
    }
}

/// Search matches
public struct DiscogsMatches: Mappable {
    public var results: [DiscogsItem]?
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        self.results <- map["results"]
    }
}

