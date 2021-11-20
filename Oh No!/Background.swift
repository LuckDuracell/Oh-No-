//
//  Background.swift
//  Oh No!
//
//  Created by Luke Drushell on 11/19/21.
//

import SwiftUI

struct Background: View {
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            ForEach((1...60), id: \.self) {_ in
                    Circle()
                    .frame(width: CGFloat.random(in: 5..<80), alignment: .center)
                    .position(x: CGFloat.random(in: 1..<400), y: CGFloat.random(in: 1..<800))
                    .foregroundColor(.red)
            }
            ForEach((1...50), id: \.self) {_ in
                    Circle()
                    .frame(width: CGFloat.random(in: 5..<80), alignment: .center)
                    .position(x: CGFloat.random(in: 1..<400), y: CGFloat.random(in: 1..<800))
                    .foregroundColor(.gray)
            }
        }
        
    }
}

struct Background_Previews: PreviewProvider {
    static var previews: some View {
        Background()
    }
}
