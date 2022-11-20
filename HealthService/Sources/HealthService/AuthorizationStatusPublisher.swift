//
//  AuthorizationStatusPublisher.swift
//  
//
//  Created by Diogo Tridapalli on 19/11/22.
//

#if os(iOS)

import Combine
import Foundation
import HealthKit
import UIKit

struct AuthorizationStatusPublisher: Publisher {
    typealias Output = HealthRepositoryAuthorizationStatus
    typealias Failure = Never

    let dataKind: DataKind
    let authorizationMightHadChangedPublisher: AnyPublisher<DataKind, Never>
    let healthRepository: HealthRepository
    let notificationCenter: NotificationCenter

    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = AuthorizationSubscription(
            subscriber: subscriber,
            dataKind: dataKind,
            authorizationMightHadChangedPublisher: authorizationMightHadChangedPublisher,
            healthRepository: healthRepository,
            notificationCenter: notificationCenter
        )
        subscriber.receive(subscription: subscription)
    }
}

private final class AuthorizationSubscription<S: Subscriber>: Subscription
    where S.Input == HealthRepositoryAuthorizationStatus, S.Failure == Never
{
    private var subscriber: S?
    private var requested: Subscribers.Demand = .none

    private let dataKind: DataKind
    private let authorizationMightHadChangedPublisher: AnyPublisher<DataKind, Never>
    private let healthRepository: HealthRepository
    private let notificationCenter: NotificationCenter

    private let subscriberQueue = DispatchQueue.main
    private var updateStatusSubject = PassthroughSubject<Void, Never>()
    @Published private var currentStatus = HealthRepositoryAuthorizationStatus.notDetermined
    private var cancellables = [AnyCancellable]()


    init(subscriber: S,
         dataKind: DataKind,
         authorizationMightHadChangedPublisher: AnyPublisher<DataKind, Never>,
         healthRepository: HealthRepository,
         notificationCenter: NotificationCenter
    ) {
        self.subscriber = subscriber
        self.dataKind = dataKind
        self.authorizationMightHadChangedPublisher = authorizationMightHadChangedPublisher
        self.healthRepository = healthRepository
        self.notificationCenter = notificationCenter
    }

    func request(_ demand: Subscribers.Demand) {
        cancellables.removeAll()
        requested += demand

        guard requested > 0 else {
            subscriberQueue.async {
                self.subscriber?.receive(completion: .finished)
            }
            cleanUp()
            return
        }

        updateStatusSubject
            .prepend(())
            .sink { [weak self] _ in
                guard let me = self else {
                    return
                }
                me.currentStatus = me.healthRepository.authorizationStatus(for: me.dataKind)
            }.store(in: &cancellables)

        notificationCenter
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .map({ _ in () })
            .subscribe(updateStatusSubject)
            .store(in: &cancellables)

        authorizationMightHadChangedPublisher
            .filter { [dataKind] kind in
                kind == dataKind
            }
            .map({ _ in () })
            .subscribe(updateStatusSubject)
            .store(in: &cancellables)

        $currentStatus
            .removeDuplicates()
            .receive(on: subscriberQueue)
            .sink { [weak self] status in
                guard let me = self else {
                    return
                }

                guard let subscriber = me.subscriber, me.requested > 0 else {
                    me.complete()
                    return
                }

                me.requested += subscriber.receive(status)
                me.requested -= 1
            }.store(in: &cancellables)
    }

    func cancel() {
        cleanUp()
    }

    private func complete() {
        subscriber?.receive(completion: .finished)
        cleanUp()
    }

    private func cleanUp() {
        cancellables.removeAll()
        subscriber = nil
    }
}

#endif
