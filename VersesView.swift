//
//  VersesView.swift
//  WarmGreeting
//
//  Created by apple on 03.10.2021.
//

import SwiftUI
let defaultTimeRemainding: CGFloat = 4
struct VersesView: View {
    let imageSize: CGFloat = 50.0// Utils().optimalSize(normal: 50.0, small: 30)
    @State var showTost: Bool = true
    @State var showIndicator: Bool = false
    @State var showQuote: Bool = false
    var quoteArray = Utils.getQuoteArray()
    @State var timeRemaining: CGFloat = -1
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var coeff: CGFloat =  0.25 //Utils().optimalSize(normal: 0.2, small: 0.25)
        @State private var placeholder: String = ""
    @State private var imageName: String = ""
    //    @State private var greetingViewState = GreetingViewState()
    @State private var greetingStyle = GreetingStyle()
//    @State private var editBgr = false
    
    @State private var editfont = false
    @State private var takePic = false
    @State private var shareActionSheet = false

    var body: some View {
        ZStack {
            Color.Background
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                    ZStack {
                      
                            if showTost  {
                                Text("Random-Tost-Text".localized)
                                    .font(.title)
                                    .foregroundColor(.mainColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            if showIndicator {
                                HStack(alignment: .center) {
                                    Spacer()
                                indicatorView
                                    Spacer()
                                }
                            }
                        Group {
                            GeometryReader { geometry in
                                if showQuote {
                                greetingCard
                                    .onChange(of: takePic, perform: { (value) in
                                        if value {
                                            let image = greetingCard.takeScreenshot(origin:
                                                                                        geometry.frame(in: .global).origin,
                                                                                    size: geometry.size)
                                            takePic = false
                                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                        }
                                    })
                            }
                            if editfont {
                                VStack {
                                    Spacer()
                                    FontView(fontName: $greetingStyle.fontname, editFont: $editfont, fontSize: $greetingStyle.fontSize)
                                        .frame(alignment: .bottom)
                                        .ignoresSafeArea()
                                }
                            }
                        }
                    }
                        Spacer()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .background(Color.Background)
                    .cornerRadius(8)
                    .shadow(color: .LightShadow, radius: 5, x: -10, y: -10)
                    .shadow(color: .DarkShadow, radius: 5, x: 6, y: 6)
                    .padding(EdgeInsets(top: 8.0, leading: 8.0, bottom: 32.0, trailing: 8.0))
                
                Spacer()
                Button(action: {
                    showTost = false
                    showIndicator = true
                    timeRemaining = defaultTimeRemainding
                    showQuote = false
                }, label: {
                    Text("Random-Tost-Button".localized)
                        .foregroundColor(.mainColor)
                        .padding()
                        .padding(.horizontal)
                        .frame(width: UIScreen.screenWidth - CGFloat(4*imageSize), height: imageSize)
                        .background(Color.Background)
                        .cornerRadius(CGFloat(imageSize / 2))
                        .shadow(color: .gray.opacity(0.8), radius: 3, x: 0, y: 4)
                })
                
            }
        } .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else if timeRemaining == 0 {
                timeRemaining = -1
                showIndicator = false
                showQuote = true
                showTost = false
                placeholder = Utils.getQuote(in: quoteArray)
               imageName = "rb_\(Int.random(in: 1..<22))"
            }
        }
        .navigationBarItems(trailing:
                                HStack {
                                    Button(action: {
                                            editfont = false
                                            shareActionSheet = true                                        }) {
                                        Image(systemName: "square.and.arrow.up")
                                            .renderingMode(.template)
                                            .foregroundColor(.black)
                                    }
                                    .alert(isPresented: $shareActionSheet) {
                                        Alert(
                                            title: Text("Import Card"),
                                            message: Text("Image will be saved to the photo galery"),
                                            primaryButton: .destructive(Text("Import")) {
                                                print("Deleting...")
                                                takePic.toggle()
                                            },
                                            secondaryButton: .cancel()
                                        )
                                    }
                                    ColorPicker("", selection: $greetingStyle.color)
                                    Button(action: {
                                        editfont.toggle()
                                    }, label: {
                                        Image(systemName: "character.textbox")
                                            .foregroundColor(.black)
                                    })
                                })
        
    }
    private var indicatorView: some View {
        ActivityIndicatorView(isVisible: $showIndicator, type: .flickeringDots)
            .foregroundColor(.blue)
            .frame(width: 100, height: 100, alignment: .center)
    }
    var greetingCard: some View {
        ZStack {
            if let image = Image(imageName){
                image
                    .resizable()
                Color.white.opacity(0.2)
            }
            ZStack {
                Text(placeholder)
                    .foregroundColor(greetingStyle.color)
                    .font(.custom(greetingStyle.fontname,
                                  size: CGFloat(greetingStyle.fontSize)).weight(greetingStyle.weight))
                    .padding(EdgeInsets(top: 8.0, leading: 8.0, bottom: 32.0, trailing: 8.0))
            }
        }
        
    }
}
struct VersesView_Previews: PreviewProvider {
    static var previews: some View {
        VersesView()
    }
}
