//
//  CloudInfoProvider.swift
//  LookupFM
//
//  Created by Vasyl Horbachenko on 7/5/19.
//  Copyright © 2019 shdwp. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import LastFmSwift
import DiscogsSwift
import Alamofire
import AlamofireImage

/// Workaround for SwiftUI inability to iterate over another package models.
/// Only used in `lookup(search:into:)` since its users are the only ones iterating over results.
struct CloudArtist: Identifiable, Hashable, CustomStringConvertible {
    var id: String {
        return self.name
    }
    
    var description: String {
        return self.name
    }
    
    let name: String
    
    init?(basedOn artist: LastFMArtist) {
        guard let name = artist.name else { return nil }
        
        self.name = name
    }
}

struct CloudTrack: Identifiable, Hashable, CustomStringConvertible {
    var id: String {
        return self.name
    }
    
    var description: String {
        return self.name
    }
    
    let name: String
    
    init?(basedOn track: LastFMTrack) {
        guard let name = track.name else { return nil }
        self.name = name
    }
}

struct CloudAlbum: Identifiable, Hashable, CustomStringConvertible {
    var id: String {
        return self.artist + self.name
    }
    
    var description: String {
        return self.name
    }
    
    let artist: String
    let name: String
    let tracks: [CloudTrack]

    init?(basedOn album: LastFMAlbum?) {
        guard let album = album else { return nil }
        guard let name = album.name else { return nil }
        guard let artist = album.artist else { return nil }
        
        self.name = name
        self.artist = artist
        self.tracks = (album.tracks?.compactMap { CloudTrack(basedOn: $0) }) ?? []
    }
}

/// Controller-like class for cloud information.
/// Requests data from LastFM/Discogs and returns it back to the view to display.
///
/// Methods to query data accept a query instance in order to not enforce object creation flow for views
/// (it's already highly enforced by SwiftUI and bringing additional dependency is just asking for trouble).
class CloudInfoProvider {
    /// bindable object query for results
    class Query<T>: BindableObject, Subscriber {
        typealias Input = T
        typealias Failure = Error
        
        var item: T?
        var didChange = PassthroughSubject<Bool, Never>()
        
        init() {
            
        }
        
        func receive(subscription: Subscription) {
            subscription.request(.unlimited)
        }
        
        func receive(_ input: T) -> Subscribers.Demand {
            self.item = input

            self.didChange.send(true)
            return .unlimited
        }
        
        func receive(completion: Subscribers.Completion<Error>) {
            // there's no need to complete the stream once
            // request is truly finished, since it only results
            // in unnecessary UI update
        }
    }
    
    let lastFm = LastFMClient()
    let discogs = DiscogsClient()
    
    /// fetch album tracks
    func fetchTracks(album albumName: String, artist artistName: String, into query: Query<LastFMTrackMatches>) {
    }

    /// fetch album info
    func fetch(album albumName: String, artist artistName: String, into query: Query<CloudAlbum>) {
        self.lastFm.fetchInfo(album: albumName, artist: artistName)
            .compactMap { CloudAlbum(basedOn: $0.album) }
            .print()
            .subscribe(query)
    }

    /// fetch artist info
    func fetch(artist name: String, into query: Query<LastFMArtist>) {
        self.lastFm.search(artist: name)
            .compactMap { $0.results?.first }
            .subscribe(query)
    }
    
    /// fetch thumbnail of artist
    func fetchThumbnail(artist name: String, into query: Query<DiscogsItem>) {
        self.discogs.search(artist: name)
            .compactMap { $0.results?.first }
            .subscribe(query)
    }
    
    /// fetch thumbnail of album
    func fetchThumbnail(artist artistName: String, album albumName: String, into query: Query<DiscogsItem>) {
        self.discogs.search(album: albumName, artist: artistName)
            .compactMap { $0.results?.first }
            .subscribe(query)
    }
    
    func fetchSimilar(artist name: String, into query: Query<[CloudArtist]>) {
        self.lastFm.fetchSimilarTo(artist: name)
            .map { item in
                return (item.results?.compactMap { CloudArtist(basedOn: $0) }) ?? []
            }.subscribe(query)
    }
    
    /// search for query
    func search(query term: String, into query: Query<([CloudArtist], [CloudAlbum])>) {
        self.lastFm.search(artist: term)
            // combine artist search with album search
            .combineLatest(self.lastFm.search(album: term))
            .map { result in
                // Transform SwiftUI-incompatible LastFMArtist/LastFMAlbum into CloudArtist/CloudAlbum
                return ((result.0.results?.compactMap { CloudArtist(basedOn: $0) }) ?? [],
                        (result.1.results?.compactMap { CloudAlbum(basedOn: $0) }) ?? [] )
        }
        .subscribe(query)
    }
}
