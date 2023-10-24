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
                    .foregroundColor(viewModel.selectedState ? .orange : .gray)
                
                Text(viewModel.title)
                    .foregroundColor(viewModel.selectedState ? .orange : .gray)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
        })
    }
}

#Preview {
    SelectableButton(viewModel: SelectableButtonViewModel(image: Image(systemName:  "pencil"),
                                                          title: "Pencil",
                                                          selected: .constant(true)))
}
