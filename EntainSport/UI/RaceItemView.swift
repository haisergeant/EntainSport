//
//  RaceItemView.swift
//  EntainSport
//
//  Created by Hai Le on 24/10/2023.
//

import SwiftUI

private struct ViewConstant {
    static let bigSize = DynamicTypeSize.xLarge
}

struct RaceItemViewModel {
    let imageName: String
    let meetingName: String
    let raceName: String
    let raceNumber: String
    let time: String
    let timeColor: Color
    
    init(imageName: String, 
         meetingName: String,
         raceName: String,
         raceNumber: String,
         time: String,
         timeColor: Color) {
        
        self.imageName = imageName
        self.meetingName = meetingName
        self.raceName = raceName
        self.raceNumber = raceNumber
        self.time = time
        self.timeColor = timeColor
    }
}

struct RaceItemView: View {
    @Environment(\.dynamicTypeSize) var typeSize
    let viewModel: RaceItemViewModel
    
    private var horizontalPadding: Double {
        typeSize > ViewConstant.bigSize ? 8 : 10
    }
    
    private var verticalPadding: Double {
        typeSize > ViewConstant.bigSize ? 8 : 12
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Image
            VStack {
                Image(viewModel.imageName)
                    .renderingMode(.template)
                    .resizable()
                    .padding(4)
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.neutralLight)
                Spacer()
            }
            .padding(.vertical, 12)
            
            
            // Meeting name & race name
            VStack(alignment: .leading) {
                Text(viewModel.meetingName)
                    .foregroundColor(.background)
                Text(viewModel.raceName)
                    .foregroundColor(.neutralLight)
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            
            Spacer()
            
            Divider()
                .overlay(.neutralDark)
            
            
            Group {
                // race number
                VStack {
                    Text(viewModel.raceNumber)
                        .foregroundColor(.background)
                    Spacer()
                }
                .padding(.vertical, verticalPadding)
                .padding(.horizontal, horizontalPadding)
                .frame(maxWidth: typeSize > ViewConstant.bigSize ? .infinity : 40)
                
                Divider()
                    .overlay(.neutralDark)
                
                // count down timer
                VStack {
                    Text(viewModel.time)
                        .font(.headline)
                        .foregroundColor(viewModel.timeColor)
                    Spacer()
                }
                .padding(.vertical, verticalPadding)
                .padding(.horizontal, horizontalPadding)
                .frame(maxWidth: typeSize > ViewConstant.bigSize ? .infinity : 80)
            }
            .adaptStack()
            .frame(width: typeSize > ViewConstant.bigSize ? 100 : 120)
        }
        
        .padding(.leading, 20)
    }
}

#Preview {
    VStack {
        RaceItemView(viewModel: RaceItemViewModel(imageName: RaceCategory.greyhound.imageName,
                                                  meetingName: "Townsville",
                                                  raceName: "Shelly Dennis",
                                                  raceNumber: "2",
                                                  time: "5m 4s",
                                                  timeColor: .secondary2))
        .background(.main)
    }
}

extension Group where Content: View {
    func adaptStack() -> some View {
        modifier(AdaptableStack())
    }
}

struct AdaptableStack: ViewModifier {
    @Environment(\.dynamicTypeSize) var typeSize
    
    func body(content: Content) -> some View {
        if typeSize > ViewConstant.bigSize {
            VStack {
                content
            }
        } else {
            HStack {
                content
            }
        }
    }
    
    
    
}
