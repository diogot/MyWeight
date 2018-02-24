//
//  MassRepository.swift
//  MyWeight
//
//  Created by Bruno Mazzo on 11/6/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation

public protocol MassRepository {
    var authorizationStatus: MassRepositoryAuthorizationStatus { get }
    func fetch(_ completion: @escaping (_ results: [Mass]) -> Void)
    func save(_ mass: Mass, completion: @escaping (_ error: Error?) -> Void)
    func delete(_ mass: Mass, completion: @escaping (_ error: Error?) -> Void)
    func requestAuthorization(_ completion: @escaping (_ error: Error?) -> Void )
    #if os(iOS)
    func requestAuthorizationForExtension()
    #endif
}

public enum MassRepositoryAuthorizationStatus {
    case notDetermined
    case denied
    case authorized
}
