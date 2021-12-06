//
//  GreetingEditView.swift
//  WarmGreeting
//
//  Created by apple on 09.08.2021.
//

import SwiftUI
import SwiftSpeech
struct GreetingEditView: View {
    @Binding var takePic: Bool
    @Binding var greetingViewState: GreetingViewState
    @State private var showingActionSheet = false
    @State private var placeholder: String = "Enter text"
    @Binding private var greetingStyle: GreetingStyle
    @State private var shareActionSheet = false
    @State private var editBgr = false
    @State private var editfont = false
    
    init( greetingViewState: Binding<GreetingViewState>,
          greetingStyle: Binding<GreetingStyle>, takePic: Binding<Bool>) {
        UITextView.appearance().backgroundColor = .clear
        self._greetingViewState = greetingViewState
        self._greetingStyle = greetingStyle
        self._takePic = takePic
    }
    var body: some View {
        ZStack {
        VStack {
            TextField("Enter task name", text: $greetingViewState.name)
                .foregroundColor(.mainColor)
                .font(.largeTitle)
                .padding(EdgeInsets(top: 8.0, leading: 8.0, bottom: 12.0, trailing: 8.0))
            Group {
                ZStack{
                VStack {
                    GeometryReader { geometry in
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
                    HStack(alignment: .center, spacing: 5, content: {
                       
                        Spacer()
                        Button(action: {
                                editBgr = false
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
                            editBgr = false
                            editfont.toggle()
                        }, label: {
                            Image(systemName: "character.textbox")
                                .foregroundColor(.black)
                        })
                        Button(action: {
                            editfont = false
                            editBgr.toggle()
                        }, label: {
                            Image(systemName: "photo")
                                .foregroundColor(.black)
                        })
                    
                    })
                    .padding(EdgeInsets(top: 10.0, leading: 8.0, bottom: 10.0, trailing: 8.0))
                    .background(Color.white.opacity(0.8).blur(radius: 0.7))
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .background(Color.Background)
            .cornerRadius(8)
            .shadow(color: .LightShadow, radius: 5, x: -10, y: -10)
            .shadow(color: .DarkShadow, radius: 5, x: 6, y: 6)
            .padding(EdgeInsets(top: 8.0, leading: 8.0, bottom: 32.0, trailing: 8.0))
            
            HStack(alignment: .center, spacing: 15, content: {
                Spacer()
                Text(greetingViewState.category.description)
                    .foregroundColor(.mainColor)
                    .onTapGesture {
                        self.showingActionSheet = true
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .actionSheet(isPresented: $showingActionSheet) {
                        ActionSheet(title: Text("Category"), message: Text("Change category"), buttons:
                                        getCategoryBtn()
                        )
                    }
                Spacer()
                SwiftSpeech.RecordButton()
                    .swiftSpeechRecordOnHold()
                    .onRecognizeLatest(update: $greetingViewState.content)
                RatingView(rating: $greetingViewState.mark)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
            })
            .padding(EdgeInsets(top: 0.0, leading: 18.0, bottom: 16.0, trailing: 18.0))
            
        }
        if editBgr {
            VStack {
                Spacer()
                LayerView(bgImage: $greetingStyle.bgImage, editBgr: $editBgr)
                    .frame(alignment: .bottom)
                    .ignoresSafeArea()
            }
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
        .onAppear {
            SwiftSpeech.requestSpeechRecognitionAuthorization()
        }
    }
    func getCategoryBtn() -> [Alert.Button] {
        var buttons: [Alert.Button] = []
        buttons = Category.allCases.map({ item in
            Alert.Button.default(Text(item.description)) { greetingViewState.category = item   }
        })
        buttons.append(Alert.Button.cancel())
        return buttons
    }
    var greetingCard: some View {
        ZStack {
            if let image = greetingStyle.bgImage {
                image
                    .resizable()
                    .scaledToFill()
                Color.white.opacity(0.2)
            }
            ZStack {
                if self.greetingViewState.content.isEmpty {
                    TextEditor(text: $placeholder)
                        .font(.body)
                        .foregroundColor(.gray)
                        .disabled(true)
                        .padding(EdgeInsets(top: 18.0, leading: 8.0, bottom: 32.0, trailing: 8.0))
                }
                TextEditor(text: $greetingViewState.content)
                    .foregroundColor(greetingStyle.color)
                    .font(.custom(greetingStyle.fontname,
                                  size: CGFloat(greetingStyle.fontSize)).weight(greetingStyle.weight))
                    .opacity(self.greetingViewState.content.isEmpty ? 0.25 : 1)
                    .padding(EdgeInsets(top: 18.0, leading: 8.0, bottom: 32.0, trailing: 8.0))
            }
        }
    }
}

struct GreetingEditView_Previews: PreviewProvider {
    static var previews: some View {
        GreetingEditView(greetingViewState: .constant(GreetingViewState(name: "Happy Wish",
                                                                            category: .colleagues,
                                                                            content: "Your birthday has come around after 365 days. That's a pretty long time. Deal with the pressure because that how diamonds are made. Happy birthday.",
                                                                            favourite: true,
                                                                            mark: 5)),
                         greetingStyle: .constant(GreetingStyle()), takePic: .constant(false))
    }
}
