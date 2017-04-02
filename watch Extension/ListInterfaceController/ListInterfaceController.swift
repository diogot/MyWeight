//
//  ListInterfaceController.swift
//  watch Extension
//
//  Created by Diogo on 18/03/17.
//  Copyright © 2017 Diogo Tridapalli. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ListInterfaceController: WKInterfaceController {

    @IBOutlet var mainGroup: WKInterfaceGroup!
    @IBOutlet var lastEntryInterfaceLabel: WKInterfaceLabel!
    @IBOutlet var massInterfaceLabel: WKInterfaceLabel!
    @IBOutlet var dateInterfaceLabel: WKInterfaceLabel!
    @IBOutlet var addInterfaceButton: WKInterfaceButton!

    @IBOutlet var goToiPhoneGroup: WKInterfaceGroup!
    @IBOutlet var goToiPhoneInterfaceLabel: WKInterfaceLabel!
    @IBOutlet var doneInterfaceButton: WKInterfaceButton!

    let massRepository: MassService = MassService()

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
        massRepository.fetch(entries: 1) { [weak self] samples in
            guard let me = self else {
                return
            }
            if let mass = samples.first {
                me.set(state: .show(mass))
            } else {
                me.set(state: .noEntry)
            }
        }
    }

    // MARK: - State

    enum State {
        case start
        case accessDenied
        case accessNotDetermined
        case noEntry
        case show(Mass)
    }

    func set(state: State) {
        switch state {
        case .start:
            updateView(with: .loading)
        case .accessDenied:
            updateView(with: .denied)
        case .accessNotDetermined:
            updateView(with: .notDetermined)
            massRepository.requestAuthorization() { error in
                Log.error(error)
            }
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
            massInterfaceLabel.setText(mass)
            dateInterfaceLabel.setText(date)
            mainGroup.setHidden(false)
            goToiPhoneGroup.setHidden(true)
        case let .goToIphone(text):
            goToiPhoneInterfaceLabel.setText(text)
            mainGroup.setHidden(true)
            goToiPhoneGroup.setHidden(false)
        }
    }

    // MARK: - Actions

    @IBAction func verifyAuthorization() {
        Log.debug(massRepository.authorizationStatus)
        switch massRepository.authorizationStatus {
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
}
