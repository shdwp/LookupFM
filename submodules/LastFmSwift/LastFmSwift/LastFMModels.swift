//
//  LastFMModels.swift
//  LastFmSwift
//
//  Created by Vasyl Horbachenko on 7/4/19.
//  Copyright © 2019 shdwp. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftUI

/// ObjectMapper protocol require models to be either classes or mutable structures,
/// therefore, every property in this file is declared as Optional `var`.

/// General protocol to hide ObjectMapper dependency
public protocol LastFMModel: Mappable { }

/// Image
public struct LastFMImage: LastFMModel {
    public enum Size: String {
        case small = "small"
        case medium = "medium"
        case large = "large"
        case extralarge = "extralarge"
    }
    
    public var id: String {
        return self.url ?? ""
    }
    
    public var size: Size?
    public var url: String?
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        self.size <- map["size"]
        self.url <- map["#text"]
    }
}

/// Track
public struct LastFMTrack: LastFMModel {
    public var name: String?
    public var duration: String?

    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        self.name <- map["name"]
        self.duration <- map["duration"]
    }
}

/// Artist
public struct LastFMArtist: LastFMModel {
    public var name: String?
    public var images: [LastFMImage]?

    public init?(map: Map) {
        
    }

    public mutating func mapping(map: Map) {
        self.name <- map["name"]
        self.images <- map["image"]
    }
}

/// Album
public struct LastFMAlbum: LastFMModel {
    public var name: String?
    public var artist: String?
    public var images: [LastFMImage]?
    public var tracks: [LastFMTrack]?
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        self.name <- map["name"]
        self.artist <- map["artist"]
        self.images <- map["image"]
        self.tracks <- map["tracks.track"]
    }
}

public struct LastFMAlbumResult: LastFMModel {
    public var album: LastFMAlbum?
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        self.album <- map["album"]
    }
}

/// Track search result
public struct LastFMTrackMatches: LastFMModel {
    public var results: [LastFMTrack]?

    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        self.results <- map["results.trackmatches.track"]
    }
}

/// Similar artists search result
public struct LastFMSimilarArtists: LastFMModel {
    public var results: [LastFMArtist]?
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        self.results <- map["similarartists.artist"]
    }
}

/// Album search result
public struct LastFMAlbumMatches: LastFMModel {
    public var results: [LastFMAlbum]?
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        self.results <- map["results.albummatches.album"]
    }
}

/// Artist search result
public struct LastFMArtistMatches: LastFMModel {
    public var results: [LastFMArtist]?
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        self.results <- map["results.artistmatches.artist"]
    }
}
