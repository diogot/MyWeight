//
//  HealthRepository.swift
//  
//
//  Created by Diogo Tridapalli on 22/10/22.
//

import Combine
import Foundation

public protocol HealthRepository {
    func fetchMass() -> AnyPublisher<[DataPoint<UnitMass>], HealthRepositoryError>
    func fetchMass(entries: Int?) -> AnyPublisher<[DataPoint<UnitMass>], HealthRepositoryError>
    func save<T>(_ measurement: DataPoint<T>) -> AnyPublisher<Void, HealthRepositoryError>
    func delete<T>(_ measurement: DataPoint<T>) -> AnyPublisher<Void, HealthRepositoryError>
    func authorizationStatus(for kind: DataKind) -> HealthRepositoryAuthorizationStatus
    func requestAuthorization(for kind: DataKind) -> AnyPublisher<Void, HealthRepositoryError>
    func observeChanges(in kind: DataKind) -> AnyPublisher<Void, HealthRepositoryError>
#if os(iOS)
    func authorizationStatusPublisher(for kind: DataKind) -> AnyPublisher<HealthRepositoryAuthorizationStatus, Never>
    func requestAuthorizationForExtension(for kind: DataKind) -> AnyPublisher<Void, HealthRepositoryError>
#endif
}

public enum HealthRepositoryError: Error {
    case fetchError(Error)
    case wrongFetchedResults
    case mismatchingFetchedResults
    case idNotFound
    case unableToDelete(Error)
    case authorizationForExtensionFailed(Error)
    case authorizationFailed(Error)
    case saveFailed(Error)
    case changeObservationsFailed(Error)
}

public enum HealthRepositoryAuthorizationStatus {
    case notDetermined
    case denied
    case authorized
}
