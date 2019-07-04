//
//  LastFMClient.swift
//  LastFmSwift
//
//  Created by Vasyl Horbachenko on 7/4/19.
//  Copyright © 2019 shdwp. All rights reserved.
//

import Foundation
import Combine
import Alamofire

/// Last FM client class
public struct LastFMClient {
    private enum Method: String {
        case trackSearch = "track.search"
        case albumSearch = "album.search"
        case albumGetInfo = "album.getInfo"
        case artistGetSimilar = "artist.getSimilar"
        case artistSearch = "artist.search"
    }
    
    private let baseUrl = URL(string: "http://ws.audioscrobbler.com/2.0/")!
    private let apiKey = "b086ce1bca41603217a2124bf7c1528d"

    public init() {
        
    }

    /// Search for track
    public func search(track name: String, artist: String) -> AnyPublisher<LastFMTrackMatches, Error> {
        return self.request(.trackSearch, ["track": name, "artist": artist])
    }

    /// Search for album using only album name
    public func search(album albumName: String) -> AnyPublisher<LastFMAlbumMatches, Error> {
        return self.request(.albumSearch, ["album": albumName])
    }
    
    /// Search for artist
    public func search(artist name: String) -> AnyPublisher<LastFMArtistMatches, Error> {
        return self.request(.artistSearch, ["artist": name])
    }
    
    /// Search for album using artist and album name
    public func fetchInfo(album albumName: String, artist artistName: String) -> AnyPublisher<LastFMAlbumResult, Error> {
        return self.request(.albumGetInfo, ["album": albumName, "artist": artistName])
    }

    /// Search for similar artists
    public func fetchSimilarTo(artist name: String) -> AnyPublisher<LastFMSimilarArtists, Error> {
        return self.request(.artistGetSimilar, ["artist": name, "autocorrect": 1])
    }

    private func request<T: LastFMModel>(_ method: Method, _ parameters: [String: Any]) -> AnyPublisher<T, Error> {
        var updatedParameters = parameters
        updatedParameters["method"] = method.rawValue
        updatedParameters["api_key"] = self.apiKey
        updatedParameters["format"] = "json"
        updatedParameters["limit"] = 6
        
        return Alamofire.request(self.baseUrl, method: .get, parameters: updatedParameters).combine()
    }
    
}
