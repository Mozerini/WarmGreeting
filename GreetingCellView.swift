//
//  GreetingCellView.swift
//  WarmGreeting
//
//  Created by apple on 02.08.2021.
//

import SwiftUI

struct GreetingCellView: View {
    @ObservedObject var greeting: Greeting

    var body: some View {
        NavigationLink(destination: GreetingDetailView(greeting: greeting, greetingState: .edit)) {
            VStack(alignment: .leading, spacing: 5, content: {
                Text(greeting.wrappedName)
                    .fontWeight(.semibold)
                    .font(.title2)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.mainColor)
                Text(greeting.wrappedContent)
                    .fontWeight(.regular)
                    .lineLimit(3)
                    .font(.caption)
                    .foregroundColor(.black)
            })
        }
        
        .padding(EdgeInsets(top: 8.0, leading: 8.0, bottom: 32.0, trailing: 8.0))
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .background(Color.Background)
        .cornerRadius(8)
        .shadow(color: .LightShadow, radius: 5, x: -6, y: -6)
        .shadow(color: .DarkShadow, radius: 5, x: 6, y: 6)
    }
}

struct GreetingCellView_Previews: PreviewProvider {
    static var previews: some View {
        GreetingCellView(greeting: Greeting())
    }
}
