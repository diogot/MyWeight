//
//  UIAlertView+AlertViewModel.swift
//  MyWeight
//
//  Created by Diogo on 26/02/17.
//  Copyright © 2017 Diogo Tridapalli. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(with viewModel: AlertViewModel) {
        self.init(title: viewModel.title,
                  message: viewModel.message,
                  preferredStyle: .alert)

        viewModel.actions
            .map { actionViewModel in
                return UIAlertAction(title: actionViewModel.title,
                                     style: .default,
                                     handler: { [weak self] _ in
                                        guard let me = self else {
                                            return
                                        }
                                        actionViewModel.block(me)
                                     })
            }
            .forEach { addAction($0) }
    }
}
