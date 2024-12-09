//
//  DriverRow.swift
//  Travel
//
//  Created by Isaque da Silva on 12/9/24.
//

import SwiftUI

struct DriverRow: View {
    @Binding var wasChosen: Int?
    
    let id: Int
    let name: String
    let description: String
    let vehicle: String
    let rating: Int
    let rideValue: Double
    
    var body: some View {
        HStack {
            Group {
                if wasChosen == id {
                    Icon.circleFill.systemImage
                } else {
                    Icon.circle.systemImage
                }
            }
            .contentTransition(.symbolEffect(.replace))
            .onTapGesture {
                withAnimation(.smooth) {
                    if wasChosen == nil {
                        wasChosen = id
                    } else {
                        wasChosen = nil
                    }
                }
            }
            
            LabeledContent {
                VStack(alignment: .trailing) {
                    Text("\(vehicle)")
                        .font(.headline)
                    
                    Text(rideValue, format: .currency(code: "BRL"))
                        .font(.headline)
                    RatingStars(rating: rating)
                }
            } label: {
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.title2)
                        .bold()
                    
                    Text(description)
                        .font(.callout)
                        .lineLimit(2)
                }
                .padding(.trailing, 10)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.secondary.opacity(0.3))
        }
    }
}

extension DriverRow {
    enum Icon: String {
        case circle
        case circleFill = "circle.fill"
        
        var systemImage: Image {
            .init(systemName: self.rawValue)
        }
    }
}

#Preview {
    DriverRow(
        wasChosen: .constant(nil),
        id: 1,
        name: "Tim Cook",
        description: "Nice to meet you, I'm Tim. You can come in and enjoy the trip, because with my skills I will take you to your destination, focusing on your safety, agility and satisfaction. Just don't talk to me too much, because I don't like being interrupted when I'm concentrating.",
        vehicle: "Tesla Model 3",
        rating: 4,
        rideValue: 10.0
    )
    .padding(.horizontal)
}
