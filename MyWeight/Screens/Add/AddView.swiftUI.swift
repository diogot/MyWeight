//
//  AddView.swiftUI.swift
//  MyWeight
//
//  Created by Bruno Mazzo on 21/8/2022.
//  Copyright © 2022 Diogo Tridapalli. All rights reserved.
//

import Foundation
import SwiftUI

public struct AddViewFromSwiftUI: View {
    var style = Style()
    
    let massService: MassRepository
    var delegate: IsPresentingDelegate
    
    @State var mass =  Mass()
    
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            ZStack {
                HStack {
                    Button("Cancel") {
                        didEnd()
                    }.buttonStyle(BackButton())
                    Spacer()
                }
                
                Text("New entry")
                    .font(Font(style.title3))
                    .foregroundColor(Color(style.textColor))
                    .padding(style.grid * 3)
            }
            Divider().background(Color(style.separatorColor))
       
            Spacer()
            
            DatePicker("", selection: $mass.date, in: ...Date())
                .datePickerStyle(.wheel)
                .pickerStyle(.wheel)
                .fixedSize()
            Spacer()
            
            MassPickerFromUIKit(currentMass: $mass.value)
            
            Spacer()
            Button("Save") {
                massService.save(mass) { (error) in
                    Log.debug("Error = \(error.debugDescription)")
                }

                didEnd()
                
            }.buttonStyle(BlueButton())
                .padding(.bottom, Style().grid * 2)
        }
    }
    
    func didEnd() {
        self.delegate.didEnd()
    }
}

struct BackButton: ButtonStyle {
    
    let style = Style()
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font(style.subhead))
            .foregroundColor(Color(style.textColor))
            .padding(style.grid * 2)
    }
    
    
}

struct BlueButton: ButtonStyle {
    
    let style = Style()
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font(style.title3))
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(Color(style.tintColor))
            .foregroundColor(Color(style.textInTintColor))
            .clipShape(RoundedRectangle(cornerRadius:style.grid / 2))
            .padding(.horizontal)
    }
}


// Just to compare previews
private struct AddViewFromUIKit: UIViewRepresentable {
    
    var viewModel: AddViewModel
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> some UIView {
        return AddView(frame: .zero, viewModel: viewModel)
    }
    
}

struct AddView_Preview: PreviewProvider {
    static var previews: some View {
        
        let viewModel = AddViewModel(initialMass: Mass(), now: Date(), didTapCancel: {
            print("Cancel")
        }, didTapSave: { mass in
            print("Save \(mass)")
        })
        
        
        return Group {
            AddViewFromUIKit(viewModel: viewModel).previewDisplayName("UIKit")
            AddViewFromSwiftUI(massService: MassService(), delegate: IsPresentingDelegate()).previewDisplayName("SwiftUI")
        }
    }
}
