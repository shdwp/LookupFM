//
//  OverviewView.swift
//  LookupFM
//
//  Created by Vasyl Horbachenko on 7/4/19.
//  Copyright © 2019 shdwp. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct OverviewView: View {
    @EnvironmentObject var locator: Locator
    
    var body: some View {
        VStack {
            TabbedView {
                ArtistListView()
                    .tabItem { Text("Library") }
                    .tag(0)
                
                WishlistView()
                    .tabItem { Text("Wishlist") }
                    .tag(1)
                
                SearchView()
                    .tabItem { Text("Search" )}
                    .tag(2)
            }
            
            HStack {
                NowPlayingView()
            }
                .padding(10)
        }
    }
}
