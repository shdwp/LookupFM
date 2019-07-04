//
//  NowPlayingProvider.swift
//  LookupFM
//
//  Created by Vasyl Horbachenko on 7/5/19.
//  Copyright © 2019 shdwp. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import MediaPlayer

/// Controller-like class for Now Playing view.
/// Acts as a binding, which updates itself every time now playing item changes.
final class NowPlayingProvider: BindableObject {
    struct Item {
        let artist: Artist
        let album: Album
        let track: Track
    }
    
    var didChange = PassthroughSubject<Bool, Never>()
    let player = MPMusicPlayerController.systemMusicPlayer
    
    var item: Item?

    init() {
        // push current item
        self.update()
        
        // subscribe to later changes
        NotificationCenter.default.publisher(for: .MPMusicPlayerControllerNowPlayingItemDidChange).sink { _ in
            self.update()
        }
    }
    
    /// update
    func update() {
        #if targetEnvironment(simulator)
        /*
         Simulator doesn't support MediaPlayer framework, therefore this is in place to substitute
         */
        self.item = Item(artist: Artist(id: 1, name: "Primal Scream"),
                         album: Album(id: 5, artistId: 1, name: "Vanishing Point"),
                         track: Track(id: 1, artistId: 1, albumId: 5, name: "Trainspotting"))
        return
        #endif
        
        if let mediaItem = self.player.nowPlayingItem {
            let title = mediaItem.value(forProperty: MPMediaItemPropertyTitle) as! String
            let titleId = mediaItem.value(forProperty: MPMediaItemPropertyPersistentID) as! UInt64
            
            let albumTitle = mediaItem.value(forProperty: MPMediaItemPropertyAlbumTitle) as! String
            let albumId = mediaItem.value(forProperty: MPMediaItemPropertyAlbumPersistentID) as! UInt64
            
            let artist = mediaItem.value(forProperty: MPMediaItemPropertyArtist) as! String
            let artistId = mediaItem.value(forProperty: MPMediaItemPropertyArtistPersistentID) as! UInt64
            
            self.item = Item(artist: Artist(id: artistId, name: artist),
                             album: Album(id: albumId, artistId: artistId, name: albumTitle),
                             track: Track(id: titleId, artistId: artistId, albumId: albumId, name: title))
        }
        
        self.didChange.send(true)
    }
}
