//
//  MassPicker.swiftUI.swift
//  MyWeight
//
//  Created by Bruno Mazzo on 21/8/2022.
//  Copyright © 2022 Diogo Tridapalli. All rights reserved.
//

import Foundation
import SwiftUI

struct MassPickerFromUIKit: UIViewRepresentable, SwiftUIDelegate {
    
    @Binding var currentMass: Measurement<UnitMass>
    
    func updateUIView(_ uiView: MassPicker, context: Context) {
        uiView.currentMass = currentMass
        uiView.delegate = self
        
    }
    func makeUIView(context: Context) -> MassPicker {
        let view = MassPicker()
        
        view.currentMass = currentMass
        view.delegate = self
        
        return view
    }
    
    func massDidChange(_ newMass: Measurement<UnitMass>) {
        self.currentMass = newMass
    }
}

struct MassPicker_Preview: PreviewProvider {
    static var previews: some View {
        MassPickerFromUIKit(currentMass: .constant(Measurement(value: 0, unit: .kilograms))).previewLayout(.sizeThatFits)
    }
}
