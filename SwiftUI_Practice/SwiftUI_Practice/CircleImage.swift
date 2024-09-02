//
//  CircleImage.swift
//  SwiftUI_Practice
//
//  Created by Jihoon on 9/2/24.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("turtlerock")
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 10)
    }
}

#Preview {
    CircleImage()
}
