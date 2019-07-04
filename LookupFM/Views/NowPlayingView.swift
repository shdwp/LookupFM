//
//  NowPlayingView.swift
//  LookupFM
//
//  Created by Vasyl Horbachenko on 7/5/19.
//  Copyright © 2019 shdwp. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import DiscogsSwift

fileprivate struct SimilarArtistCell: View {
    let uuid = UUID()
    let name: String

    @EnvironmentObject var locator: Locator
    @ObjectBinding var query: CloudInfoProvider.Query<DiscogsItem> = .init()
    
    var body: some View {
        self.onCreate(self.uuid) {
            self.locator.cloudInfoProvider.fetchThumbnail(artist: self.name, into: self.query)
        }
        
        return VStack {
            if self.query.item != nil {
                URLImageView(self.query.item!.thumbnail)
            }
            
            Text(self.name).font(.system(size: 9))
        }
    }
}

struct NowPlayingView: View {
    let uuid = UUID()
    
    @EnvironmentObject var locator: Locator
    @ObjectBinding var provider = NowPlayingProvider()
    @ObjectBinding var query: CloudInfoProvider.Query<[CloudArtist]> = .init()
    
    var body: some View {
        self.onCreate(uuid) {
            self.provider.didChange.sink { _ in
                self.updateSimilar()
            }

            self.updateSimilar()
        }

        return VStack {
            HStack {
                if self.provider.item != nil {
                    Text("Now playing: \(self.provider.item!.track.name) - \(self.provider.item!.artist.name)")
                }
            }
            
            if self.query.item != nil {
                HStack {
                    Text("Similar:")
                    ForEach(self.query.item![0...2]) {
                        SimilarArtistCell(name: $0.name)
                    }
                }
            }
        }
    }
    
    func updateSimilar() {
        if let name = self.provider.item?.artist.name {
            self.locator.cloudInfoProvider.fetchSimilar(artist: name, into: self.query)
        }
    }
}

