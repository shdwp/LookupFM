//
//  ViewsEnvironment.swift
//  LookupFM
//
//  Created by Vasyl Horbachenko on 7/4/19.
//  Copyright © 2019 shdwp. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import LastFmSwift

/// I use a simple service locator pattern for DI, which is inserted via EnvironmentObject into the views.
/// Most services in this class act as controllers.
/// This should've been injected via .environmentObject into root view and then automatically propagated
/// by SwiftUI, but that doesn't work yet, therefore it's manually injected into each created view.
class Locator: BindableObject {
    /// not used but required
    var didChange = PassthroughSubject<Bool, Never>()
    
    /// provider for local music database
    let musicDatabaseProvider = MusicDatabaseProvider()
    
    /// provider for lastfm&discogs models
    let cloudInfoProvider = CloudInfoProvider()
    
    /// wishlist provider
    let wishlistProvider = WishlistProvider()
}
