//
//  HealthService.swift
//  HealthService
//
//  Created by Diogo Tridapalli on 20/08/22.
//  Copyright © 2022 Diogo Tridapalli. All rights reserved.
//

import Combine
import Foundation
import HealthKit

public final class HealthService: HealthRepository {

    let healthStore: HealthStoreProtocol

    public init(healthStore: HealthStoreProtocol = HKHealthStore()) {
        self.healthStore = healthStore
    }

    // MARK: - Fetch

    public func fetchMass() -> AnyPublisher<[DataPoint<UnitMass>], HealthRepositoryError> {
        fetchMass(entries: nil)
    }

    public func fetchMass(entries: Int?) -> AnyPublisher<[DataPoint<UnitMass>], HealthRepositoryError> {
        fetch(kind: .mass, entries: entries)
    }

    private func fetch<T: Unit>(kind: DataKind, entries: Int? = nil)-> AnyPublisher<[DataPoint<T>], HealthRepositoryError> {

        let startDate = healthStore.earliestPermittedSampleDate()
        let endData = Date()

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endData, options: HKQueryOptions())
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        return Deferred { [healthStore] in
            Future { promise in
                let query = HKSampleQuery(
                    sampleType: kind.type,
                    predicate: predicate,
                    limit: entries ?? HKObjectQueryNoLimit,
                    sortDescriptors: [sortDescriptor])
                { query, results, error in
                    if let error = error {
                        promise(.failure(.fetchError(error)))
                        return
                    }

                    guard let samples = results as? [HKQuantitySample] else {
                        promise(.failure(.wrongFetchedResults))
                        return
                    }

                    guard let points = samples.map({ DataPoint(with: $0, kind: kind) }) as? [DataPoint<T>] else {
                        promise(.failure(.mismatchingFetchedResults))
                        return
                    }
                    promise(.success(points))
                }
                healthStore.execute(query)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    // MARK: - Save

    public func save<T>(_ measurement: DataPoint<T>) -> AnyPublisher<Void, HealthRepositoryError> where T : Unit {
        let sample = measurement.sample

        return Deferred { [healthStore] in
            Future { promise in
                healthStore.save(sample) { success, error in
                    if let error = error {
                        promise(.failure(.saveFailed(error)))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    // MARK: - Delete

    public func delete<T>(_ measurement: DataPoint<T>) -> AnyPublisher<Void, HealthRepositoryError> where T : Unit {
        guard case let .permanent(id) = measurement.status else {
            return Fail(error: .idNotFound).eraseToAnyPublisher()
        }

        return Deferred { [healthStore] in
            Future { promise in
                let predicate = HKQuery.predicateForObject(with: id)
                healthStore.deleteObjects(
                    of: measurement.kind.type,
                    predicate: predicate) { success, deleted, error in
                        if let error = error {
                            promise(.failure(.unableToDelete(error)))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    // MARK: - Observation

    public func observeChanges(in kind: DataKind) -> AnyPublisher<Void, HealthRepositoryError> {
        DataPublisher(kind: kind, healthStore: healthStore)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // MARK: - Authorization

    public func authorizationStatus(for kind: DataKind) -> HealthRepositoryAuthorizationStatus {
        let status: HealthRepositoryAuthorizationStatus

        switch healthStore.authorizationStatus(for: kind.type) {
            case .notDetermined:
                status = .notDetermined
            case .sharingDenied:
                status = .denied
            case .sharingAuthorized:
                status = .authorized
            @unknown default:
                status = .notDetermined
        }

        return status
    }

    public func requestAuthorization(for kind: DataKind) -> AnyPublisher<Void, HealthRepositoryError> {
        Deferred { [healthStore] in
            Future { promise in
                let set = Set<HKSampleType>(arrayLiteral: kind.type)
                healthStore.requestAuthorization(toShare: set, read: set) { success, error in
                    if let error = error {
                        promise(.failure(.authorizationFailed(error)))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

#if os(iOS)
    public func requestAuthorizationForExtension(for kind: DataKind) -> AnyPublisher<Void, HealthRepositoryError> {
        Deferred { [healthStore] in
            Future { promise in
                healthStore.handleAuthorizationForExtension { success, error in
                    if let error = error {
                        promise(.failure(.authorizationForExtensionFailed(error)))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
#endif

}
