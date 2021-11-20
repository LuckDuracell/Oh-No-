//
//  ContentView.swift
//  Oh No!
//
//  Created by Luke Drushell on 11/19/21.
//

import SwiftUI

struct ContentView: View {
    
    let screenSize = UIScreen.main.bounds
    @State var bgOpacity = false
    
    @State var shift: Double = 1
    @State var hideText = true
    @State var hideText2 = true
    @State var breakHeart = false
    @State var revealButton = false
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ZStack {
            
            Background()
                .edgesIgnoringSafeArea(.all)
                .scaleEffect(shift)
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        withAnimation {
                            bgOpacity = true
                        }
                    })
                    Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
                        shift += 0.0005
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                        withAnimation(.spring(), {
                            hideText = false
                        })
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                        withAnimation(.spring(), {
                            hideText2 = false
                        })
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                        withAnimation(.linear, {
                            breakHeart = true
                        })
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                        withAnimation(.easeIn, {
                            revealButton = true
                        })
                    })
                })
            
            ZStack {
                Rectangle()
                    .ignoresSafeArea()
                    .background(.thinMaterial)
                ZStack {
                    VStack {
                        Text(hideText ? "" : "Oh no!")
                            .bold()
                            .padding()
                            .font(.system(size: 30))
                            .foregroundColor(.white)
//                        Image(systemName: breakHeart ? "heart.fill" : "heart.fill")
//                            .resizable()
//                            .frame(width: 100, height: 92, alignment: .center)
//                            .scaledToFit()
//                            .foregroundColor(.pink)
                        ZStack {
                            Text(breakHeart ? "💔" : "❤️")
                                .font(.system(size: 120))
                                .padding(-30)
                            Text("♦️")
                                .modifier(hideText ? ParticlesModifier() : ParticlesModifier())
                        }
                        Text(hideText2 ? "" : "Your COVID-19 Results came back positive")
                            .bold()
                            .padding()
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    } .padding(.top, hideText2 ? 0 : -150)
                        Button {
                            openURL(URL(string: "https://www.cdc.gov/coronavirus/2019-ncov/if-you-are-sick/steps-when-sick.html")!)
                        } label: {
                            Text("Click here for more Info")
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 300, height: 50, alignment: .center)
                                .background(Color.red)
                                .cornerRadius(10)
                                .padding()
                                .opacity(revealButton ? 1 : 0)
                        }
                        .padding(.top, 200)
                }
            }
            .opacity(bgOpacity ? 1 : 0)
        }
        .onTapGesture {
            shift = 1
            hideText = true
            hideText2 = true
            bgOpacity = false
            revealButton = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                withAnimation {
                    bgOpacity = true
                }
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                withAnimation(.spring(), {
                    hideText = false
                })
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                withAnimation(.easeIn, {
                    hideText2 = false
                })
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                withAnimation(.easeIn, {
                    revealButton = true
                })
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                withAnimation(.easeIn(duration: 1), {
                    breakHeart = true
                })
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

struct ParticlesModifier: ViewModifier {
    @State var time = 0.0
    @State var scale = 0.1
    let duration = 0.8
    
    func body(content: Content) -> some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                content
                    .scaleEffect(scale)
                    .modifier(FireworkParticlesGeometryEffect(time: time))
                    .opacity(((duration-time) / duration))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                withAnimation (.easeOut(duration: duration)) {
                    self.time = duration
                    self.scale = 1.0
                }
            })
        }
    }
}

struct HiddenParticles: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

struct FireworkParticlesGeometryEffect : GeometryEffect {
    var time : Double
    var speed = Double.random(in: 20 ... 100)
    var direction = Double.random(in: 0.5 ... 2.5)
    
    var animatableData: Double {
        get { time }
        set { time = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        let xTranslation = speed * cos(direction) * time
        let yTranslation = speed * sin(direction) * time
        let affineTranslation =  CGAffineTransform(translationX: xTranslation, y: yTranslation)
        return ProjectionTransform(affineTranslation)
    }
}
