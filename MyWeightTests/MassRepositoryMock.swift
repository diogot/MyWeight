//
//  MassRepositoryMock.swift
//  MyWeightTests
//
//  Created by Diogo Tridapalli on 25/11/17.
//  Copyright © 2017 Diogo Tridapalli. All rights reserved.
//

import Foundation
@testable import MyWeight

class MassRepositoryMock: MassRepository {
    var authorizationStatus: MassRepositoryAuthorizationStatus = .notDetermined

    var fetchResponse: [Mass]?
    func fetch(_ completion: @escaping (_ results: [Mass]) -> Void) {
        completion(self.fetchResponse ?? [])
    }

    var saveError: Error?
    func save(_ mass: Mass, completion: @escaping (Error?) -> Void) {
        completion(saveError)
    }

    var requestAuthorizationError: Error?
    func requestAuthorization(_ completion: @escaping (Error?) -> Void) {
        completion(requestAuthorizationError)
    }

    func requestAuthorizationForExtension() {
    }

    var deleteResponse: Error?
    public func delete(_ mass: Mass, completion: @escaping (Error?) -> Void) {
        completion(self.deleteResponse)
    }
}
