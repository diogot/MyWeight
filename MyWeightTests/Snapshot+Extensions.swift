//
//  Snapshot+Extensions.swift
//  MyWeight
//
//  Created by Bruno Mazzo on 11/2/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation
import Nimble
import Nimble_Snapshots

public struct ScreenSnapshot {
    let name: String
    let record: Bool
    let size: CGSize
    
    init(name: String, record: Bool, size: CGSize) {
        self.name = name
        self.record = record
        self.size = size
    }
}

public func snapshotScreen(_ name: String, sizes: [String: CGSize]) -> [ScreenSnapshot] {
    return sizes.map { ScreenSnapshot(name: "\(name) - \($0.key)", record: false, size: $0.value) }
}

public func recordSnapshotScreen(_ name: String, sizes: [String: CGSize]) -> [ScreenSnapshot] {
    return sizes.map { ScreenSnapshot(name: "\(name) - \($0.key)", record: true, size: $0.value) }
}

public func ==(lhs: Expectation<Snapshotable>, rhs: [ScreenSnapshot]) {
    rhs.forEach {
        do {
            try lhs.expression.evaluate()?.snapshotObject?.bounds = CGRect(origin: CGPoint.zero, size: $0.size)
        } catch {
            fail()
        }
        
        if $0.record {
            lhs.to(recordSnapshot(named: $0.name))
        } else {
            lhs.to(haveValidSnapshot(named: $0.name))
        }
    }
}
