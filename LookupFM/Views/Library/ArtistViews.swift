//
//  ArtistViews.swift
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

fileprivate struct ArtistListViewCell: View {
    let uuid = UUID()
    @EnvironmentObject var locator: Locator
    
    let artist: Artist
    @ObjectBinding var query = CloudInfoProvider.Query<DiscogsItem>()
    
    init(artist: Artist) {
        self.artist = artist
    }

    var body: some View {
        self.onCreate(self.uuid) {
            print("fetch thumbnail")
            self.locator.cloudInfoProvider.fetchThumbnail(artist: self.artist.name, into: self.query)
        }
        print("refresh")
        
        return NavigationLink(destination: ArtistAlbumsListView(artist: self.artist).environmentObject(self.locator)) {
            if self.query.item != nil {
                URLImageView(self.query.item?.thumbnail)
            }
            
            Text(self.artist.name)
        }
    }
}

struct ArtistListView: View {
    let uuid = UUID()
    @EnvironmentObject var locator: Locator
    @ObjectBinding var databaseQuery: MusicDatabaseProvider.Query<Artist> = .init()
    @ObjectBinding var cloudArtistQuery: CloudInfoProvider.Query<LastFMArtist> = .init()
    
    init() {
        
    }
    
    var body: some View {
        self.onCreate(self.uuid) {
            self.locator.musicDatabaseProvider.queryArtists(into: self.databaseQuery)
        }
        
        return NavigationView {
            VStack {
                if self.databaseQuery.items != nil {
                    List(self.databaseQuery.items!) {
                        ArtistListViewCell(artist: $0).environmentObject(self.locator)
                    }
                } else {
                    Text("None")
                }
            }
                .navigationBarTitle("Artists")
        }
    }
}

