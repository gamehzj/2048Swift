//
//  CardView.swift
//  Game2048Swift
//
//  Created by shoothzj on 2022/2/3.
//

import SwiftUI

struct CardView: View {

    @StateObject var vm = ViewModel()

    var body: some View {
        ZStack {
            Rectangle()
                    .fill(getColor(vm.number).0)
                    .zIndex(1)
            Text(vm.text)
                    .foregroundColor(getColor(vm.number).1)
                    .zIndex(1000)
                    .transition(AnyTransition.opacity.combined(with: .scale))
        }.clipped().cornerRadius(5)
    }

    fileprivate let colorScheme: [(Color, Color)] = [
        // 2
        (Color(red: 0.91, green: 0.87, blue: 0.83, opacity: 1.00), Color(red: 0.42, green: 0.39, blue: 0.35, opacity: 1.00)),
        // 4
        (Color(red: 0.90, green: 0.86, blue: 0.76, opacity: 1.00), Color(red: 0.42, green: 0.39, blue: 0.35, opacity: 1.00)),
        // 8
        (Color(red: 0.93, green: 0.67, blue: 0.46, opacity: 1.00), Color.white),
        // 16
        (Color(red: 0.94, green: 0.57, blue: 0.38, opacity: 1.00), Color.white),
        // 32
        (Color(red: 0.95, green: 0.46, blue: 0.33, opacity: 1.00), Color.white),
        // 64
        (Color(red: 0.94, green: 0.35, blue: 0.23, opacity: 1.00), Color.white),
        // 128
        (Color(red: 0.91, green: 0.78, blue: 0.43, opacity: 1.00), Color.white),
        // 256
        (Color(red: 0.91, green: 0.78, blue: 0.37, opacity: 1.00), Color.white),
        // 512
        (Color(red: 0.90, green: 0.77, blue: 0.31, opacity: 1.00), Color.white),
        // 1024
        (Color(red: 0.91, green: 0.75, blue: 0.24, opacity: 1.00), Color.white),
        // 2048
        (Color(red: 0.91, green: 0.74, blue: 0.18, opacity: 1.00), Color.white),
    ]

    fileprivate func getColor(_ number: Int) -> (Color, Color) {
        if number == 0 {
            return (Color(red: 0.78, green: 0.73, blue: 0.68, opacity: 1.00), Color.black)
        }
        let index = Int(log2(Double(number))) - 1
        if index < 0 || index >= colorScheme.count {
            fatalError("No color for such number")
        }
        return colorScheme[index]
    }

    class ViewModel: ObservableObject {
        @Published var number: Int = 0
        @Published var text: String = ""

        func setText(_ num: Int) {
            number = num
            if num == 0 {
                text = String("")
            } else {
                text = String(num)
            }
        }

        func getNum() -> Int {
            number
        }

        func isFree() -> Bool {
            number == 0
        }
    }
}
