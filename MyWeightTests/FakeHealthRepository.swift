//
//  FakeHealthRepository.swift
//  MyWeightTests
//
//  Created by Diogo Tridapalli on 29/10/22.
//  Copyright © 2022 Diogo Tridapalli. All rights reserved.
//

import Combine
import Foundation
@testable import HealthService


final class FakeHealthRepository: HealthRepository {
    var fetchMassResponse: Result<[DataPoint<UnitMass>], HealthRepositoryError> = .success([])
    private(set) var fetchMassCalls = 0
    func fetchMass() -> AnyPublisher<[DataPoint<UnitMass>], HealthRepositoryError> {
        fetchMassCalls += 1
        return fetchMassResponse.asAnyPublisher()
    }

    var fetchMassEntriesResponse: Result<[DataPoint<UnitMass>], HealthRepositoryError> = .success([])
    private(set) var fetchMassEntriesCalls = 0
    func fetchMass(entries: Int?) -> AnyPublisher<[DataPoint<UnitMass>], HealthRepositoryError> {
        fetchMassEntriesCalls += 1
        return fetchMassEntriesResponse.asAnyPublisher()
    }

    var saveResponse: Result<Void, HealthRepositoryError> = .success(())
    private(set) var saveMeasurementsInput = [Any]()
    private(set) var saveCalls = 0
    func save<T: Unit>(_ measurement: DataPoint<T>) -> AnyPublisher<Void, HealthRepositoryError> {
        saveCalls += 1
        saveMeasurementsInput.append(measurement)
        return saveResponse.asAnyPublisher()
    }

    var deleteResponse: Result<Void, HealthRepositoryError> = .success(())
    private(set) var deleteMeasurementsInput = [Any]()
    private(set) var deleteCalls = 0
    func delete<T: Unit>(_ measurement: DataPoint<T>) -> AnyPublisher<Void, HealthRepositoryError> {
        deleteCalls += 1
        deleteMeasurementsInput.append(measurement)
        return deleteResponse.asAnyPublisher()
    }

    var authorizationStatusResponse: HealthRepositoryAuthorizationStatus = .notDetermined
    private(set) var authorizationStatusCalls = 0
    private(set) var authorizationStatusKindInput = [DataKind]()
    func authorizationStatus(for kind: DataKind) -> HealthRepositoryAuthorizationStatus {
        authorizationStatusKindInput.append(kind)
        authorizationStatusCalls += 1
        return authorizationStatusResponse
    }

    var requestAuthorizationResponse: Result<Void, HealthRepositoryError> = .success(())
    private(set) var requestAuthorizationKindInput = [DataKind]()
    private(set) var requestAuthorizationCalls = 0
    func requestAuthorization(for kind: DataKind) -> AnyPublisher<Void, HealthRepositoryError> {
        requestAuthorizationKindInput.append(kind)
        requestAuthorizationCalls += 1
        return requestAuthorizationResponse.asAnyPublisher()
    }

    var observeChangesResponse: Result<Void, HealthRepositoryError> = .success(())
    private(set) var observeChangesCalls = 0
    private(set) var observeChangesKindsInput = [DataKind]()
    func observeChanges(in kind: DataKind) -> AnyPublisher<Void, HealthRepositoryError> {
        observeChangesKindsInput.append(kind)
        observeChangesCalls += 1
        return observeChangesResponse.asAnyPublisher()
    }

    var requestAuthorizationForExtensionResponse: Result<Void, HealthRepositoryError> = .success(())
    private(set) var requestAuthorizationForExtensionCalls = 0
    private(set) var requestAuthorizationForExtensionKindInput = [DataKind]()
    func requestAuthorizationForExtension(for kind: DataKind) -> AnyPublisher<Void, HealthRepositoryError> {
        requestAuthorizationForExtensionCalls += 1
        requestAuthorizationForExtensionKindInput.append(kind)
        return requestAuthorizationForExtensionResponse.asAnyPublisher()
    }
}

private extension Result {
    func asAnyPublisher() -> AnyPublisher<Success, Failure> {
        switch self {
        case .success(let result):
            return Just(result).setFailureType(to: Failure.self).eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
