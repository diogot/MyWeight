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

    @IBOutlet var massInterfaceLabel: WKInterfaceLabel!
    @IBOutlet var dateInterfaceLabel: WKInterfaceLabel!

    @IBOutlet var mainGroup: WKInterfaceGroup!
    @IBOutlet var notRequestedGroup: WKInterfaceGroup!
    @IBOutlet var deniedGroup: WKInterfaceGroup!

    let massRepository: MassService = MassService()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        massInterfaceLabel.setText("Loading ...")
        dateInterfaceLabel.setText("")
    }
    
    override func willActivate() {
        verifyAuthorization()
        super.willActivate()
    }
    
    @IBAction func verifyAuthorization() {
        Log.debug(massRepository.authorizationStatus)
        switch massRepository.authorizationStatus {
        case .authorized:
            loadCurrentMass()
            mainGroup.setHidden(false)
            notRequestedGroup.setHidden(true)
            deniedGroup.setHidden(true)
        case .notDetermined:
            mainGroup.setHidden(true)
            notRequestedGroup.setHidden(false)
            deniedGroup.setHidden(true)
            massRepository.requestAuthorization() { [weak self] error in
                Log.error(error)
            }
        case .denied:
            mainGroup.setHidden(true)
            notRequestedGroup.setHidden(true)
            deniedGroup.setHidden(false)
        }
    }

    func loadCurrentMass() {
        massRepository.fetch(entries: 1) { samples in
            if let mass = samples.first {
                let massFormatter = MeasurementFormatter()
                massFormatter.numberFormatter.minimumFractionDigits = 1
                massFormatter.numberFormatter.maximumFractionDigits = 1
                massFormatter.unitOptions = .providedUnit

                self.massInterfaceLabel.setText(massFormatter.string(from: mass.value))

                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .short
                dateFormatter.doesRelativeDateFormatting = true

                self.dateInterfaceLabel.setText(dateFormatter.string(from: mass.date))
            } else {
                self.massInterfaceLabel.setText("No entry")
                self.dateInterfaceLabel.setText("")
            }
        }
    }

    @IBAction func addMassAction() {
        pushController(withName: "add", context: nil)
    }

}
