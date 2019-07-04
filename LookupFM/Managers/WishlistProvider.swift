//
//  WishlistProvider.swift
//  LookupFM
//
//  Created by Vasyl Horbachenko on 7/7/19.
//  Copyright © 2019 shdwp. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import RealmSwift

/// Realm-compatible wishlist item
final class WishlistedItem: Object, Identifiable {
    @objc dynamic var label = ""
    
    override var description: String {
        return self.label
    }
}

/// Wishlist provider. Save, remove and restore wishlisted items.
final class WishlistProvider {
    let realm = try! Realm()

    /// Wishlist item
    func wishlist<T: CustomStringConvertible>(item: T) {
        try! self.realm.write {
            let wishlistedItem = WishlistedItem()
            wishlistedItem.label = item.description
            
            self.realm.add(wishlistedItem)
        }
    }
    
    /// Remove item from wishlist
    func remove(item: WishlistedItem) {
        try! self.realm.write {
            self.realm.delete(item)
        }
    }
    
    /// Fetch stored items
    func fetch() -> Results<WishlistedItem> {
        return self.realm.objects(WishlistedItem.self)
    }
}
