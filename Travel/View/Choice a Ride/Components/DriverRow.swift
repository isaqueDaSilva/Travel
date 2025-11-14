//
//  DriverRow.swift
//  Travel
//
//  Created by Isaque da Silva on 12/9/24.
//

import SwiftUI

/*
 TODO: Implement this view to display a confirmation button and a ride price. Remove all old content.
 */
struct DriverRow: View {
    @Binding var wasChosen: DriverInformation?
    @Binding var chosenRideValue: Double?
    
    let id: Int
    let name: String
    let description: String
    let vehicle: String
    let rating: Int
    let rideValue: Double
    
    var body: some View {
        GroupBox {
            contentDescription
        } label: {
            VStack {
                HStack {
                    choiceIndicator
                    
                    rideInformation
                }
                
                rowDivider
            }
        }
        .onTapGesture {
            withAnimation(.smooth) {
                setUserChoice()
            }
        }
    }
}

extension DriverRow {
    @ViewBuilder
    private var contentDescription: some View {
        VStack(alignment: .leading) {
            Text(description)
                .font(.callout)
                .padding(.bottom, 5)
            
            RatingStars(rating: rating)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private var choiceIndicator: some View {
        Group {
            if wasChosen?.id == id {
                Icon.circleFill.systemImage
            } else {
                Icon.circle.systemImage
            }
        }
        .contentTransition(.symbolEffect(.replace))
    }
    
    @ViewBuilder
    private var rideInformation: some View {
        Text(name)
            .font(.title2)
            .bold()
        
        VStack(alignment: .trailing) {
            Text(rideValue, format: .currency(code: "BRL"))
                .font(.headline)
            
            Text("\(vehicle)")
                .font(.headline)
        }
        .multilineTextAlignment(.trailing)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    @ViewBuilder
    private var rowDivider: some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height: 1)
            .padding(5)
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

extension DriverRow {
    private func setUserChoice() {
        if wasChosen == nil {
            wasChosen = .init(id: self.id, name: self.name)
            chosenRideValue = rideValue
        } else {
            wasChosen = nil
            chosenRideValue = nil
        }
    }
}

#Preview {
    DriverRow(
        wasChosen: .constant(nil),
        chosenRideValue: .constant(nil),
        id: 1,
        name: "Tim Cook",
        description: "Nice to meet you, I'm Tim. You can come in and enjoy the trip, because with my skills I will take you to your destination, focusing on your safety, agility and satisfaction. Just don't talk to me too much, because I don't like being interrupted when I'm concentrating.",
        vehicle: "Tesla Model 3",
        rating: 4,
        rideValue: 10.0
    )
    .padding(.horizontal)
}
