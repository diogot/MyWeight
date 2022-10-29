//
//  Publisher+Extensions.swift
//  MyWeight
//
//  Created by Diogo Tridapalli on 15/10/22.
//  Copyright © 2022 Diogo Tridapalli. All rights reserved.
//

import Combine
import Foundation

extension Publisher {
    func sink<T: AnyObject>(weak object: T,
                            receiveCompletion: ((T, Subscribers.Completion<Self.Failure>) -> Void)? = nil,
                            receiveValue: ((T, Self.Output) -> Void)? = nil) -> AnyCancellable {
        sink { [weak object] completion in
            guard let object = object else {
                return
            }
            receiveCompletion?(object, completion)
        } receiveValue: { [weak object] value in
            guard let object = object else {
                return
            }
            receiveValue?(object, value)
        }
    }

    @available(*, deprecated, renamed: "removeDuplicates")
    func distinctUntilChanged(by predicate: @escaping (Self.Output, Self.Output) -> Bool) -> Publishers.RemoveDuplicates<Self> {
        removeDuplicates(by: predicate)
    }

    @available(*, deprecated, renamed: "prepend")
    func startWith(_ elements: Self.Output...) -> Publishers.Concatenate<Publishers.Sequence<[Self.Output], Self.Failure>, Self> {
        prepend(elements)
    }
}

public extension Publisher where Output: Equatable {
    @available(*, deprecated, renamed: "removeDuplicates")
    func distinctUntilChanged() -> Publishers.RemoveDuplicates<Self> {
        removeDuplicates()
    }
}
