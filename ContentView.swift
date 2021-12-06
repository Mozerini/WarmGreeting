//
//  ContentView.swift
//  WarmGreeting
//
//  Created by apple on 28.07.2021.
//
// swiftlint: disable line_length

import SwiftUI

struct ContentView: View {
    @State var searchText: String = ""
    @State var selectedSearchScopeIndex: Int = 0

    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().selectionStyle = .none
    }
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.Background, .Background2]),
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                    VStack {
                            SearchBar(text: $searchText, placeholder: "Search by name or content")
                            .background(Color.Background)
                                .zIndex(-1.0)
                            if !searchText.isEmpty {
                                Picker("", selection: $selectedSearchScopeIndex) {
                                    ForEach(0 ..< Category.allCases.count, id: \.self) { categoryIndex in
                                        let categoryType = Category.allCases[categoryIndex]
                                        Text(categoryType.rawValue).tag(categoryIndex)
                                    }
                                }.pickerStyle(SegmentedPickerStyle())
                                .zIndex(-1.0)
                            }

                        FilteredList(filterValue: searchText, categoryIndex: selectedSearchScopeIndex
                        ) { (greeting: Greeting) in
                            GreetingCellView(greeting: greeting)
                                .contextMenu {
                                    Button("Delete") {
                                        PersistentController.shared.delete(greeting)

                                    }
                                }
                        }
                    }
            }
            .navigationBarTitle(Text("Warm Greeting"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: VersesView()
                    ) {
                        Image(systemName: "dice")
                            .shadow(color: .black, radius: 10, x: 0.0, y: 0.0)
                    }
                                    }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: GreetingDetailView(greeting: nil)
                    ) {
                        Image(systemName: "plus")
                            .shadow(color: .black, radius: 10, x: 0.0, y: 0.0)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .foregroundColor(.blue)
        .accentColor(.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
