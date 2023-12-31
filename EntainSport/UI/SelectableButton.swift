//
//  SelectableButton.swift
//  EntainSport
//
//  Created by Hai Le on 23/10/2023.
//

import SwiftUI

class SelectableButtonViewModel: ObservableObject {
    let image: Image
    let title: String
    
    @Binding var selectedState: Bool
    
    init(image: Image, title: String, selected: Binding<Bool>) {
        self.image = image
        self.title = title
        self._selectedState = selected
    }
}

struct SelectableButton: View {
    @ObservedObject var viewModel: SelectableButtonViewModel
    var body: some View {
        Button(action: {
            viewModel.selectedState.toggle()
        }, label: {
            VStack {
                viewModel.image
                    .renderingMode(.template)
                    .resizable()
                    .padding(4)
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(viewModel.selectedState ? .secondary2 : .neutralLight)
                
                Text(viewModel.title)
                    .foregroundColor(viewModel.selectedState ? .secondary2 : .neutralLight)
                    .font(.footnote)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
        })
        .accessibilityIdentifier("Selectable.Button")
        .accessibilityLabel("\(viewModel.title) button - \(viewModel.selectedState ? "selected" : "unselected")")
    }
}

#Preview {
    SelectableButton(viewModel: SelectableButtonViewModel(image: Image(systemName:  "pencil"),
                                                          title: "Pencil",
                                                          selected: .constant(true)))
}


