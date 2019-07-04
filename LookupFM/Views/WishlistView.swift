//
//  WithlistView.swift
//  LookupFM
//
//  Created by Vasyl Horbachenko on 7/5/19.
//  Copyright © 2019 shdwp. All rights reserved.
//

import Foundation
import SwiftUI

struct WishlistView: View {
    @EnvironmentObject var locator: Locator
    @ObjectBinding var query = InvalidationQuery()

    var body: some View {
        VStack {
            List(self.locator.wishlistProvider.fetch()) { item in
                HStack {
                    Text(item.description)
                    Spacer()
                    Button("Unwishlist") {
                        self.locator.wishlistProvider.remove(item: item)
                        self.query.invalidate()
                    }
                }
            }
        }
    }
}
