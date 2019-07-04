//
//  Misc.swift
//  LookupFM
//
//  Created by Vasyl Horbachenko on 7/6/19.
//  Copyright © 2019 shdwp. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import Alamofire

/// Simple bindable object used to invalidate current View
final class InvalidationQuery: BindableObject {
    var didChange = PassthroughSubject<Bool, Never>()
    
    func invalidate() {
        self.didChange.send(true)
    }
}

/// SwiftUI only provides `onAppear` callback, which is not called on subsequent view tree re-creations,
/// therefore not suitable for processes starting.
/// This is a custom implementation on similar callback that is run on each view creation.
/// Due to Views being structs it require unique view uuid `token` to be passed and intended to be called on view tree creation.
fileprivate var tokens: [UUID] = []
extension View {
    func onCreate(_ token: UUID, _ closure: () -> ()) {
        if !tokens.contains(token) {
            tokens.append(token)
            closure()
        }
    }
}

/// View which loads and displays image from URLConvertible using AlamofireImage
struct URLImageView: View {
    class Binding: BindableObject {
        var didChange = PassthroughSubject<Bool, Never>()
        let url: URLConvertible?
        var image: UIImage?
        
        init(_ url: URLConvertible?) {
            self.url = url
            self.request()
        }
        
        func request() {
            if let url = self.url {
                Alamofire.request(url).responseImage {
                    self.image = $0.result.value?.af_imageAspectScaled(toFit: .init(width: 40, height: 40))
                    self.didChange.send(true)
                }
            }
        }
    }
    
    @ObjectBinding var data: Binding
    
    init(_ url: URLConvertible?) {
        self.data = Binding(url)
    }

    var body: some View {
        return Group {
            if self.data.image != nil {
                Image(uiImage: self.data.image!)
                    .clipped()
                    .scaledToFill()
                    .mask(Circle())
            } else {
                Text("...")
            }
        }
    }
}
