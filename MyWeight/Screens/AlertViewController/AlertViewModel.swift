//
//  AlertViewModel.swift
//  MyWeight
//
//  Created by Diogo on 26/02/17.
//  Copyright © 2017 Diogo Tridapalli. All rights reserved.
//

import UIKit

public struct AlertViewModel {
    public let title: String
    public let message: String
    public let actions: [Action]

    public struct Action {
        public let title: String
        public let block: (UIAlertController) -> Void
    }
}
