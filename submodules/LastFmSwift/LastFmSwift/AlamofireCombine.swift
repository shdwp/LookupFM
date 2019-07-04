//
//  AlamofireCombine.swift
//  LastFmSwift
//
//  Created by Vasyl Horbachenko on 7/4/19.
//  Copyright © 2019 shdwp. All rights reserved.
//

import Foundation
import Combine
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

/// - NOTE: This is a file copied from `AlamofireCombine` dependency due to Cocoapods spec limitation of not being able to include dev. dependencies

/// Publisher implementation for Alamofire DataRequest responseObject.
/// If request is successful it will send parsed object as a value and complete stream with .finished,
/// otherwise it will complete stream with .failure providing original error
fileprivate class AlamofireCombinePublisher<T>: Publisher {
    typealias Output = T
    typealias Failure = Error
    
    let subject = PassthroughSubject<Output, Failure>()
    let request: DataRequest
    
    init(_ request: DataRequest) {
        self.request = request
    }

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        self.subject.receive(subscriber: subscriber)
    }
    
    /// Provide response callback for Alamofire call
    /// - Returns: Closure that is intended to be run as a completion handler for Alamofire `responseObject`
    func responseCallback() -> (DataResponse<Output>) -> () {
        return {
            switch $0.result {
            case .success(let s):
                self.subject.send(s)
                self.subject.send(completion: .finished)
            case .failure(let e):
                self.subject.send(completion: .failure(e))
            }
        }
    }
}

internal extension DataRequest {
    /// Provide publisher which would send request result using `responseObject`
    ///
    /// - Returns: type-erased publisher
    func combine<T: Mappable>() -> AnyPublisher<T, Error> {
        let subject = AlamofireCombinePublisher<T>(self)
        self.responseString {
            print($0)
        }
        
        print(self)
        self.responseObject(completionHandler: subject.responseCallback())
        return AnyPublisher(subject)
    }
}
