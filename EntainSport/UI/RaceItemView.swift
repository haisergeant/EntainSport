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
    let accessibilityMeetingName: String
    let raceName: String
    let accessibilityRaceName: String
    let raceNumber: String
    let accessibilityRaceNumber: String
    let time: String
    let accessibilityTime: String
    let timeColor: Color
    
}

struct RaceItemView: View {
    @Environment(\.dynamicTypeSize) var typeSize
    let viewModel: RaceItemViewModel
    
    private var horizontalPadding: Double {
        isBigTypeSize ? 12 : 8
    }
    
    private var verticalPadding: Double {
        isBigTypeSize ? 8 : 12
    }
    
    private var isBigTypeSize: Bool {
        typeSize > ViewConstant.bigSize
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
                    .accessibilityIdentifier("Race.Meeting.Name")
                    .accessibilityLabel(viewModel.accessibilityMeetingName)
                Text(viewModel.raceName)
                    .foregroundColor(.neutralLight)
                    .accessibilityIdentifier("Race.Name")
                    .accessibilityLabel(viewModel.accessibilityRaceName)
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
                        .accessibilityIdentifier("Race.Number")
                        .accessibilityLabel(viewModel.accessibilityRaceNumber)
                    Spacer()
                }
                .padding(.vertical, verticalPadding)
                .padding(.horizontal, horizontalPadding)
                .frame(maxWidth: isBigTypeSize ? .infinity : 34)
                
                Divider()
                    .overlay(.neutralDark)
                
                // count down timer
                VStack {
                    Text(viewModel.time)
                        .font(.headline)
                        .foregroundColor(viewModel.timeColor)
                        .accessibilityIdentifier("Race.Number")
                        .accessibilityLabel(viewModel.accessibilityTime)
                    Spacer()
                }
                .padding(.vertical, verticalPadding)
                .padding(.horizontal, horizontalPadding)
                .frame(maxWidth: isBigTypeSize ? .infinity : 86)
            }
            .adaptStack()
            .frame(width: isBigTypeSize ? 100 : 120)
        }
        
        .padding(.leading, 20)
    }
}

#Preview {
    VStack {
        RaceItemView(viewModel: RaceItemViewModel(imageName: RaceCategory.greyhound.imageName,
                                                  meetingName: "Townsville",
                                                  accessibilityMeetingName: "Townsville",
                                                  raceName: "Shelly Dennis",
                                                  accessibilityRaceName: "Shelly Dennis",
                                                  raceNumber: "2",
                                                  accessibilityRaceNumber: "Race number 2",
                                                  time: "5m 4s",
                                                  accessibilityTime: "5 minutes 4 seconds",
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
