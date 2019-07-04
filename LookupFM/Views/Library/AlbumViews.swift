//
//  AlbumViews.swift
//  LookupFM
//
//  Created by Vasyl Horbachenko on 7/5/19.
//  Copyright © 2019 shdwp. All rights reserved.
//

import Foundation
import SwiftUI
import LastFmSwift
import DiscogsSwift

fileprivate struct AlbumDetailView: View {
    let uuid = UUID()
    let artist: Artist
    let album: Album
    
    @EnvironmentObject var locator: Locator
    @ObjectBinding var query: CloudInfoProvider.Query<CloudAlbum> = .init()

    var body: some View {
        self.onCreate(self.uuid) {
            self.locator.cloudInfoProvider.fetch(album: self.album.name, artist: self.artist.name, into: self.query)
        }

        return VStack(alignment: .leading) {
            Text("by \(self.artist.name)").offset(x: 30, y: 0).font(.headline)
            Divider()
            Text("Tracks:").font(.headline)
            if self.query.item != nil {
                List(self.query.item!.tracks) {
                    Text($0.name)
                }
            }
        }
            .navigationBarTitle("\(self.album.name)")
    }
}

fileprivate struct SimilarArtistCell: View {
    let uuid = UUID()
    let artist: CloudArtist
    
    @EnvironmentObject var locator: Locator
    @ObjectBinding var query: CloudInfoProvider.Query<DiscogsItem> = .init()

    var body: some View {
        self.onCreate(self.uuid) {
            self.locator.cloudInfoProvider.fetchThumbnail(artist: self.artist.name, into: self.query)
        }
        
        return VStack {
            if self.query.item != nil {
                URLImageView(self.query.item!.thumbnail)
            }
            
            Text(self.artist.name).font(.system(size: 9))
        }
    }
}

fileprivate struct ArtistDetailView: View {
    let uuid = UUID()
    let artist: Artist
    
    @EnvironmentObject var locator: Locator
    @ObjectBinding var query: CloudInfoProvider.Query<[CloudArtist]> = .init()

    var body: some View {
        self.onCreate(uuid) {
            self.locator.cloudInfoProvider.fetchSimilar(artist: self.artist.name, into: self.query)
        }
        
        return HStack {
            if self.query.item != nil {
                ForEach(self.query.item![0...4]) {
                    SimilarArtistCell(artist: $0).environmentObject(self.locator)
                }
            }
        }
    }
}

fileprivate struct AlbumsListViewCell: View {
    let uuid = UUID()
    let artist: Artist
    let album: Album
    
    @EnvironmentObject var locator: Locator
    @ObjectBinding var databaseQuery: MusicDatabaseProvider.Query<Album> = .init()
    @ObjectBinding var cloudQuery: CloudInfoProvider.Query<DiscogsItem> = .init()
    
    var body: some View {
        self.onCreate(self.uuid) {
            self.locator.cloudInfoProvider.fetchThumbnail(artist: self.artist.name, album: self.album.name, into: self.cloudQuery)
        }

        return HStack {
            if self.cloudQuery.item != nil {
                URLImageView(self.cloudQuery.item?.thumbnail)
            }
            
            NavigationLink(self.album.name,
                           destination: AlbumDetailView(artist: self.artist, album: self.album).environmentObject(self.locator))
        }
    }
}

fileprivate struct AlbumsListView: View {
    let uuid = UUID()
    let artist: Artist

    @EnvironmentObject var locator: Locator
    @ObjectBinding var databaseQuery: MusicDatabaseProvider.Query<Album> = .init()
    
    var body: some View {
        self.onCreate(self.uuid) {
            self.locator.musicDatabaseProvider.queryAlbums(for: self.artist, into: self.databaseQuery)
        }

        return VStack {
            if self.databaseQuery.items != nil {
                List(self.databaseQuery.items!) {
                    AlbumsListViewCell(artist: self.artist, album: $0)
                }
            } else {
                Text("None")
            }
        }
    }
}

struct ArtistAlbumsListView: View {
    let artist: Artist
    
    @EnvironmentObject var locator: Locator
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Similar:").font(.headline).offset(x: 30, y: 0)
            ArtistDetailView(artist: self.artist).environmentObject(self.locator)
            Divider()
            Text("Local albums:").font(.headline).offset(x: 30, y: 0)
            AlbumsListView(artist: self.artist).environmentObject(self.locator)
        }
            .navigationBarTitle(artist.name)
    }
}
