//
//  ListInterfaceController.swift
//  watch Extension
//
//  Created by Diogo on 18/03/17.
//  Copyright © 2017 Diogo Tridapalli. All rights reserved.
//

import Combine
import HealthService
import WatchKit

class ListInterfaceController: WKInterfaceController {

    @IBOutlet var mainGroup: WKInterfaceGroup!
    @IBOutlet var lastEntryInterfaceLabel: WKInterfaceLabel!
    @IBOutlet var massInterfaceLabel: WKInterfaceLabel!
    @IBOutlet var dateInterfaceLabel: WKInterfaceLabel!
    @IBOutlet var addInterfaceButton: WKInterfaceButton!

    @IBOutlet var goToiPhoneGroup: WKInterfaceGroup!
    @IBOutlet var goToiPhoneInterfaceLabel: WKInterfaceLabel!
    @IBOutlet var doneInterfaceButton: WKInterfaceButton!

    private let healthService: HealthRepository = HealthService()

    private var cancellables = Set<AnyCancellable>()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        set(state: .start)
    }
    
    override func willActivate() {
        verifyAuthorization()
        super.willActivate()
    }

    override func didDeactivate() {
        invalidateUserActivity()
        super.didDeactivate()
    }
    
    func loadCurrentMass() {
        healthService.fetchMass(entries: 1).first()
            .sink(weak: self, receiveValue: { me, masses in
                if let mass = masses.first {
                    me.set(state: .show(mass))
                } else {
                    me.set(state: .noEntry)
                }
            }).store(in: &cancellables)
    }

    // MARK: - State

    enum State {
        case start
        case accessDenied
        case accessNotDetermined
        case noEntry
        case show(DataPoint<UnitMass>)
    }

    func set(state: State) {
        updateUserActivity(with: state)
        switch state {
            case .start:
                updateView(with: .loading)
            case .accessDenied:
                updateView(with: .denied)
            case .accessNotDetermined:
                updateView(with: .notDetermined)
                healthService.requestAuthorization(for: .mass)
                    .sink(weak: self, receiveCompletion: { _, completion in
                        Log.error(completion.error)
                    }).store(in: &cancellables)
            case .noEntry:
                updateView(with: .noEntry)
            case .show(let mass):
                updateView(with: .mass(mass))
        }
    }

    // MARK: - ViewModel

    func updateView(with viewModel: ListInterfaceControllerViewModel) {
        switch viewModel {
        case let .main(mass, date):
            lastEntryInterfaceLabel.setText(viewModel.lastEntryText)
            massInterfaceLabel.setText(mass)
            dateInterfaceLabel.setText(date)
            addInterfaceButton.setTitle(viewModel.buttonText)
            mainGroup.setHidden(false)
            goToiPhoneGroup.setHidden(true)
        case let .goToIphone(text):
            goToiPhoneInterfaceLabel.setText(text)
            mainGroup.setHidden(true)
            goToiPhoneGroup.setHidden(false)
            doneInterfaceButton.setTitle(viewModel.buttonText)
        }
    }

    // MARK: - Actions

    @IBAction func verifyAuthorization() {
        let status = healthService.authorizationStatus(for: .mass)
        Log.debug(status)
        switch status {
            case .authorized:
                loadCurrentMass()
            case .notDetermined:
                set(state: .accessNotDetermined)
            case .denied:
                set(state: .accessDenied)
        }
    }

    @IBAction func addMassAction() {
        pushController(withName: "add", context: nil)
    }

    // MARK: - User Activity

    func updateUserActivity(with state: State) {
        let userInfo: [String: Any]

        switch state {
        case .start:
            userInfo = [:]
        case .accessDenied:
            userInfo = [:]
        case .accessNotDetermined:
            userInfo = [:]
        case .noEntry:
            userInfo = [:]
        case .show(_):
            userInfo = [:]
        }

        let userActivity = NSUserActivity(activityType: UserActivityService.ActivityType.list.rawValue)
        userActivity.userInfo = userInfo
        update(userActivity)
    }

}
