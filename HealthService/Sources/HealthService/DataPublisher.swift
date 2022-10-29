//
//  DataPublisher.swift
//  
//
//  Created by Diogo Tridapalli on 22/10/22.
//

import Combine
import Foundation
import HealthKit

struct DataPublisher: Publisher {
    typealias Output = Void
    typealias Failure = HealthRepositoryError

    let kind: DataKind
    let healthStore: HealthStoreProtocol

    func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = DataSubscription(
            subscriber: subscriber, kind: kind,
            healthStore: healthStore
        )
        subscriber.receive(subscription: subscription)
    }
}

private final class DataSubscription<S: Subscriber>: NSObject, Subscription
where S.Input == Void, S.Failure == HealthRepositoryError {
    private var subscriber: S?
    private var requested: Subscribers.Demand = .none

    private let kind: DataKind
    private var healthStore: HealthStoreProtocol?
    private var query: HKQuery?

    init(subscriber: S, kind: DataKind, healthStore: HealthStoreProtocol) {
        self.subscriber = subscriber
        self.kind = kind
        self.healthStore = healthStore
    }

    func request(_ demand: Subscribers.Demand) {
        requested = demand

        guard requested > 0 else {
            subscriber?.receive(completion: .finished)
            return
        }

        startQuery()
    }

    func cancel() {
        if let query = query {
            healthStore?.stop(query)
        }
        subscriber = nil
        query = nil
        healthStore = nil
    }

    private func complete() {
        subscriber?.receive(completion: .finished)
        cancel()
    }

    private func fail(with error: HealthRepositoryError) {
        subscriber?.receive(completion: .failure(error))
        cancel()
    }

    private func startQuery() {
        let query = HKObserverQuery(sampleType: kind.type, predicate: nil) { [weak self] query, completion, error in
            guard let me = self else {
                return
            }

            guard let subscriber = me.subscriber else {
                me.complete()
                return
            }

            guard me.requested > 0 else {
                me.complete()
                return
            }

            if let error = error {
                me.fail(with: .changeObservationsFailed(error))
                return
            }

            me.requested += subscriber.receive(())
            me.requested -= 1
        }
        self.query = query
        healthStore?.execute(query)
    }
}

