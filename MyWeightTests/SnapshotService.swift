//
//  SnapshotService.swift
//  MyWeight
//
//  Created by Bruno Mazzo on 11/5/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation
import Nimble
import Nimble_Snapshots

public struct SnapshotService {
    let iPhonePortraitSizes = ["iPhone 4'" : CGSize(width: 320, height: 568),
                       "iPhone 4.7'" : CGSize(width: 375, height: 667),
                       "iPhone 5.5'" : CGSize(width: 414, height: 736)]

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
    
    public func snapshot(_ name: String, sizes: [String: CGSize]) -> [ScreenSnapshot] {
        return sizes.map { ScreenSnapshot(name: "\(name) - \($0.key)", record: false, size: $0.value) }
    }
    
    public func recordSnapshot(_ name: String, sizes: [String: CGSize]) -> [ScreenSnapshot] {
        return sizes.map { ScreenSnapshot(name: "\(name) - \($0.key)", record: true, size: $0.value) }
    }
}

public func ==(lhs: Expectation<Snapshotable>, rhs: [SnapshotService.ScreenSnapshot]) {
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
