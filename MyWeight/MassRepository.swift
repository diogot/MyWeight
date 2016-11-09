//
//  MassRepository.swift
//  MyWeight
//
//  Created by Bruno Mazzo on 11/6/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation

public protocol MassRepository {
    func fetch(_ completion: @escaping (_ results: [Mass]) -> Void)
}
