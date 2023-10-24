//
//  RaceItemView.swift
//  EntainSport
//
//  Created by Hai Le on 24/10/2023.
//

import SwiftUI

struct RaceItemViewModel {
    let imageName: String
    let meetingName: String
    let raceName: String
    let raceNumber: String
    let time: TimeInterval
    
    init(imageName: String, meetingName: String, raceName: String, raceNumber: String, time: TimeInterval) {
        self.imageName = imageName
        self.meetingName = meetingName
        self.raceName = raceName
        self.raceNumber = raceNumber
        self.time = time
    }
    
    
}

struct RaceItemView: View {
    let viewModel: RaceItemViewModel
    var body: some View {
        HStack(spacing: 8) {
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
            .padding(.leading, 12)
            
            Spacer()
            
            Divider()
                .overlay(.neutralDark)
                .frame(width: 2)
            
            // race number
            VStack {
                Text(viewModel.raceNumber)
                    .foregroundColor(.background)
                Spacer()
            }
            .padding(.vertical, 12)
            .frame(width: 40)
            
            Divider()
                .overlay(.neutralDark)
            
            // count down timer
            VStack {
                ZStack {
                    Text("test")
                        .foregroundColor(.background)
                 
                }
                Spacer()
            }
            .padding(.vertical, 12)
            .frame(width: 60)
        }
        
        .padding(.leading, 20)
    }
}

#Preview {
    VStack {
        RaceItemView(viewModel: RaceItemViewModel(imageName: RaceCategory.greyhound.imageName,
                                                  meetingName: "Townsville",
                                                  raceName: "Shelly Dennis",
                                                  raceNumber: "No \n2",
                                                  time: 1698138900))
        .background(.main)
    }
}
