//
//  GreetingDetailView.swift
//  WarmGreeting
//
//  Created by apple on 04.08.2021.
//
// swiftlint:disable multiple_closures_with_trailing_closure
import SwiftUI
//import SwiftSpeech

enum GreetingState {
    case edit
    case add
}
struct GreetingDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let greeting: Greeting?
    @State private var color: Color = .black
    @State private var greetingViewState = GreetingViewState()
    @State private var showingActionSheet = false
    @State private var shareActionSheet = false
    @State private var placeholder: String = "Enter text"
    @State private var editBgr = false
    @State private var editfont = false
    @State private var takePic = false
    @State private var greetingStyle = GreetingStyle()
    var greetingState: GreetingState = .add
    var body: some View {
        ZStack {
            Color.Background
                .ignoresSafeArea()
            ZStack {
            GreetingEditView(greetingViewState: $greetingViewState, greetingStyle: $greetingStyle, takePic: $takePic)
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
            if greetingState == .edit {
                if let greeting = self.greeting  {
                    self.greetingViewState.name =  greeting.wrappedName
                    self.greetingViewState.content = greeting.wrappedContent
                    self.greetingViewState.category =  greeting.wrappedCategory
                    self.greetingViewState.favourite =  greeting.favourite
                    self.greetingViewState.mark =  greeting.wrappedMark
                }
            }
//            SwiftSpeech.requestSpeechRecognitionAuthorization()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: {
//                                    saveGreeting()
                                    self.presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image(systemName: "chevron.left")
                                        .renderingMode(.template)
                                        .foregroundColor(.black)
                                },
                            trailing:
                                HStack {
                                    if greetingState == .edit {
                                    Button(action: {
                                        showingActionSheet = true
                                    }) {
                                        Image(systemName: "trash")
                                            .renderingMode(.template)
                                            .foregroundColor(.black)
                                    }
                                    .alert(isPresented: $showingActionSheet) {
                                        Alert(
                                            title: Text("Are you sure you want to delete this?"),
                                            message: Text("There is no undo"),
                                            primaryButton: .destructive(Text("Delete")) {
                                                print("Deleting...")
                                                if greetingState == . edit {
                                                    if let greeting = greeting {
                                                        PersistentController.shared.delete(greeting)
                                                    }
                                                }
                                                self.presentationMode.wrappedValue.dismiss()
                                            },
                                            secondaryButton: .cancel()
                                        )
                                    }
                                }
                                    Button(action: {
                                        saveGreeting()
                                    }) {
                                        Image(systemName: "checkmark")
                                            .renderingMode(.template)
                                            .foregroundColor(.black)
                                    }
                                })
    }
    func saveGreeting() {
       
        if greetingState == .edit {
            if let greeting = greeting {
                PersistentController.shared.update(greeting, by: greetingViewState)
            }
        } else {
            PersistentController.shared.createGreeting(with: greetingViewState)
        }
        
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct GreetingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        return GreetingDetailView(greeting: Greeting())
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    func takeScreenshot(origin: CGPoint, size: CGSize) -> UIImage {
        let window = UIWindow(frame: CGRect(origin: origin, size: size))
        let hosting = UIHostingController(rootView: self)
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return hosting.view.screenShot
    }
}

extension UIView {
    var screenShot: UIImage {
        let rect = self.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)
        let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return capturedImage
    }
}
