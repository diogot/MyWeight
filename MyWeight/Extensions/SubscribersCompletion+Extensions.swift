//
//  SubscribersCompletion+Extensions.swift
//  MyWeight
//
//  Created by Diogo Tridapalli on 15/10/22.
//  Copyright © 2022 Diogo Tridapalli. All rights reserved.
//

import Combine

public extension Subscribers.Completion {
    var error: Failure? {
        guard case let .failure(error) = self  else {
            return nil
        }
        return error
    }
}
