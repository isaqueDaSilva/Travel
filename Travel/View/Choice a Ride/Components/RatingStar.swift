//
//  RatingStar.swift
//  Travel
//
//  Created by Isaque da Silva on 12/9/24.
//

import SwiftUI

// TODO: Remove this view
struct RatingStars: View {
    let rating: Int
    private var offColor = Color.gray
    private var onColor = Color.green
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { number in
                Image(systemName: "star")
                    .scaledToFit()
                    .foregroundStyle(number > rating ? offColor : onColor)
                    .frame(width: 20)
            }
        }
    }
    
    init(rating: Int) {
        self.rating = rating
    }
}

#Preview {
    RatingStars(rating: 4)
}
