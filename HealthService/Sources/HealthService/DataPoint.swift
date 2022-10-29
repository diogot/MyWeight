//
//  DataPoint.swift
//  
//
//  Created by Diogo Tridapalli on 22/10/22.
//

import Foundation
import HealthKit

public struct DataPoint<T: Unit> {
    public let kind: DataKind
    public let value: Measurement<T>
    public let date: Date
    public let metadata: Metadata?
    let status: Status

    public typealias Metadata = [String: Any]

    enum Status {
        case permanent(UUID)
        case transient
    }

    public init(kind: DataKind, value: Measurement<T>, date: Date, metadata: Metadata?) {
        self.kind = kind
        self.value = value
        self.date = date
        self.metadata = metadata
        status = .transient
    }
}

public enum DataKind {
    case mass

    var type: HKQuantityType {
        switch self {
        case .mass:
            return HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        }
    }
}

public extension DataPoint where T == UnitMass {

    init() {
        kind = .mass
        value = Measurement(value: 70, unit: .kilograms)
        date = Date()
        status = .transient
        metadata = nil
    }

    init(with sample: HKQuantitySample, kind: DataKind) {
        self.kind = kind
        value = Measurement(value: sample.quantity.doubleValue(for: .gramUnit(with: .kilo)),
                            unit: UnitMass.kilograms)
        date = sample.startDate
        status = .permanent(sample.uuid)
        metadata = sample.metadata
    }
}

protocol QuantitySamplable {
    var sample: HKQuantitySample { get }
}

extension DataPoint: QuantitySamplable {
    var sample: HKQuantitySample {
        if let value = value as? Measurement<UnitMass> {
            let quantity = HKQuantity(unit: .gramUnit(with: .kilo),
                                      doubleValue: value.converted(to: .kilograms).value)

            let metadata = [HKMetadataKeyWasUserEntered: true]
            return HKQuantitySample(
                type: kind.type,
                quantity: quantity,
                start: date,
                end: date,
                metadata: metadata
            )
        } else {
            fatalError("Not implemented")
        }
    }
}
