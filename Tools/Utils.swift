//
//  Utils.swift
//  WarmGreeting
//
//  Created by apple on 17.09.2021.
//

import Foundation
public class Utils {
   public func evaluateProblem(problemNumber: Int, problemBlock: () -> Void) {
        let start = DispatchTime.now()
        problemBlock()
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000 //

        print("Time to evaluate problem \(problemNumber): \(timeInterval) seconds")
    }
    static func getQuoteArray() -> [String] {
        if let url = Bundle.main.url(forResource: "tost_data", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                let decoder = JSONDecoder()
                if let products = try? decoder.decode([String].self, from: data) {
                    return products
                }
            }
        }
        return []
    }
    static func getQuote(in array: [String]) -> String {
        let randomInt = Int.random(in: 0..<array.count)
        return array[randomInt].replacingOccurrences(of: "/", with: "")
    }
}
