//
//  MusicDatabaseProvider.swift
//  LookupFM
//
//  Created by Vasyl Horbachenko on 7/4/19.
//  Copyright © 2019 shdwp. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import MediaPlayer

/// Number of models for locally stored music collection. Should be self-explanatory.
struct Artist: Hashable, Identifiable {
    var id: UInt64
    let name: String
}

struct Album: Hashable, Identifiable {
    var id: UInt64
    let artistId: UInt64
    let name: String
}

struct Track: Hashable, Identifiable {
    var id: UInt64
    let artistId: UInt64
    let albumId: UInt64
    let name: String
}

/// Controller-like class for querying local database.
/// Handles retrieval and parsing.
/// Methods to query data accept a query instance in order to not enforce object creation flow for views
/// (it's already highly enforced by SwiftUI and bringing additional dependency is just asking for trouble).
final class MusicDatabaseProvider {
    /// long-running bindable query for this provider
    class Query<T>: BindableObject {
        var items: [T]? {
            didSet(newValue) {
                self.didChange.send(newValue)
            }
        }
        
        var didChange = PassthroughSubject<[T]?, Never>()
    }
    
    /// query all artists
    func queryArtists(into query: Query<Artist>) {
        #if targetEnvironment(simulator)
        query.items = Array(self.mockedArtists.keys)
        return
        #endif
        
        query.items = MPMediaQuery.artists().items?.compactMap {
            guard let name = $0.artist else {
                return nil
            }
            
            return Artist(id: $0.persistentID, name: name)
        }
    }
    
    /// query albums for artist
    func queryAlbums(for artist: Artist, into query: Query<Album>) {
        #if targetEnvironment(simulator)
        query.items = self.mockedArtists[artist]
        return
        #endif
        
        let mediaQuery = MPMediaQuery.albums()
        mediaQuery.addFilterPredicate(MPMediaPropertyPredicate(value: artist.id, forProperty: MPMediaItemPropertyArtistPersistentID))
        query.items =  mediaQuery.items?.compactMap {
            guard let name = $0.albumTitle else {
                return nil
            }
            
            return Album(id: $0.persistentID, artistId: artist.id, name: name)
        }
    }

    #if targetEnvironment(simulator)
    /// simulator doesn't support most of the MediaPlayer framework, therefore this stub is in place
    private var mockedArtists = [
        Artist(id: 0, name: "Iggy Pop"): [
            Album(id: 0, artistId: 0, name: "The Idiot"),
            Album(id: 1, artistId: 0, name: "Lust For Life"),
        ],
        Artist(id: 1, name: "Primal Scream"): [
            Album(id: 2, artistId: 1, name: "Primal Scream"),
            Album(id: 3, artistId: 1, name: "Screamadelica"),
            Album(id: 4, artistId: 1, name: "Give Out But Don't Give Up"),
            Album(id: 5, artistId: 1, name: "Vanishing Point"),
        ],
        Artist(id: 2, name: "New Order"): [
            Album(id: 6, artistId: 2, name: "Movement"),
            Album(id: 7, artistId: 2, name: "Power, Corruption & Lies"),
            Album(id: 8, artistId: 2, name: "Low-life"),
        ],
        Artist(id: 3, name: "Pulp"): [
            Album(id: 9, artistId: 3, name: "His N Hers"),
            Album(id: 10, artistId: 3, name: "Different Class"),
        ],
    ]
    #endif
}
