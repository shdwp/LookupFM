//
//  DiscogsClient.swift
//  DiscogsSwift
//
//  Created by Vasyl Horbachenko on 7/6/19.
//  Copyright © 2019 shdwp. All rights reserved.
//

import Foundation
import Combine
import Alamofire

/// Discogs client
public struct DiscogsClient {
    private enum Method: String {
        case databaseSeach = "database/search"
    }
    
    private let baseUrl = "https://api.discogs.com/"
    private let apiToken = "TCxKWaRjhKbVPKzuSBTscZDcwsASRaTTZbOXwCmY"
    
    public init() {
        
    }
    
    /// Search for artist
    public func search(artist name: String) -> AnyPublisher<DiscogsMatches, Error> {
        return self.request(.databaseSeach, ["q": name, "type": "artist"])
    }
    
    /// Search for album
    public func search(album albumName: String, artist artistName: String) -> AnyPublisher<DiscogsMatches, Error> {
        return self.request(.databaseSeach, ["q": "\(artistName) \(albumName)", "type": "release"])
    }
    
    private func request<T: DiscogsModel>(_ method: Method, _ parameters: [String: Any]) -> AnyPublisher<T, Error> {
        var updatedParameters = parameters
        updatedParameters["token"] = self.apiToken
        updatedParameters["page"] = 1
        updatedParameters["perPage"] = 6

        return Alamofire.request(self.baseUrl + method.rawValue, method: .get, parameters: updatedParameters).combine()
    }
}
