//
//  SearchView.swift
//  LookupFM
//
//  Created by Vasyl Horbachenko on 7/5/19.
//  Copyright © 2019 shdwp. All rights reserved.
//

import Foundation
import SwiftUI
import LastFmSwift
import DiscogsSwift

fileprivate struct SearchMatchCell<T: CustomStringConvertible>: View {
    typealias FetchThumbnailClosure = (CloudInfoProvider.Query<DiscogsItem>) -> Void
    
    let uuid = UUID()
    let item: T
    let fetchThumbnailClosure: FetchThumbnailClosure

    @EnvironmentObject var locator: Locator
    @ObjectBinding var query = CloudInfoProvider.Query<DiscogsItem>()
    
    init(_ item: T, _ fetchThumbnailClosure: @escaping FetchThumbnailClosure) {
        self.item = item
        self.fetchThumbnailClosure = fetchThumbnailClosure
    }
    
    var body: some View {
        self.onCreate(self.uuid) {
            self.fetchThumbnailClosure(self.query)
        }
        
        return HStack {
            if self.query.item != nil {
                URLImageView(self.query.item!.thumbnail)
            }
            
            Text(self.item.description)
            Spacer()
            Button("Wishlist") {
                self.locator.wishlistProvider.wishlist(item: self.item)
            }
        }
    }
}

struct SearchView: View {
    @EnvironmentObject var locator: Locator
    @ObjectBinding var query = CloudInfoProvider.Query<([CloudArtist], [CloudAlbum])>()
    @State var searchQuery = ""

    var body: some View {
        VStack {
            HStack {
                Text("Search term: ")
                TextField("Input query",
                          text: self.$searchQuery,
                          onEditingChanged: { _ in }) {
                            self.locator.cloudInfoProvider.search(query: self.searchQuery, into: self.query)
                }
            }.padding(10)

            if self.query.item != nil {
                Text("Artists: ")
                List(self.query.item!.0) { artist in
                    SearchMatchCell(artist) {
                        self.locator.cloudInfoProvider.fetchThumbnail(artist: artist.name, into: $0)
                    }.environmentObject(self.locator)
                }
                Divider()
                
                Text("Albums: ")
                List(self.query.item!.1) { album in
                    SearchMatchCell(album) {
                        self.locator.cloudInfoProvider.fetchThumbnail(artist: album.artist, album: album.name, into: $0)
                    }.environmentObject(self.locator)
                }
            } else {
                Spacer()
            }
        }
    }
}
