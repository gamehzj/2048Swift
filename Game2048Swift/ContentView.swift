//
//  ContentView.swift
//  Game2048Swift
//
//  Created by shoothzj on 2022/2/3.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var vm = ViewModel()

    let rows: [GridItem] = {
        let screenHeight = UIScreen.main.bounds.size.height
        return Array(repeating: .init(.fixed(CGFloat(screenHeight / 5))), count: 4)
    }()
    var body: some View {
        Text("Score: " + String(vm.score))
        let width = UIScreen.main.bounds.size.width
        LazyHGrid(rows: rows, spacing: 10) {
            ForEach(0...15, id: \.self) { item in
                CardView(vm: vm.data[item])
                        .frame(minWidth: width / 5)
            }
        }
                .onAppear {
                    vm.initNumber()
                }
                .gesture(DragGesture(minimumDistance: 5, coordinateSpace: .local)
                        .onEnded({ value in
                            print("swipe width", value.translation.width, "swipe height", value.translation.height)
                            // judge if left/right or up/down
                            if fabs(Double(value.translation.width)) > fabs((Double(value.translation.height))) {
                                if value.translation.width < 0 {
                                    vm.swipeLeft()
                                }
                                if value.translation.width > 0 {
                                    vm.swipeRight()
                                }
                            } else {
                                if value.translation.height < 0 {
                                    vm.swipeUp()
                                }
                                if value.translation.height > 0 {
                                    vm.swipeDown()
                                }
                            }
                        }))
                .alert("Game Over!", isPresented: $vm.gameOver, actions: {
                    // actions
                }, message: {
                    Text("Score is " + String(vm.score))
                })
    }

}

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var gameOver: Bool = false
        @Published var score: Int = 0
        @Published var data: [CardView.ViewModel] = [CardView.ViewModel]()

        init() {
            for _ in 0..<16 {
                data.append(CardView.ViewModel())
            }
        }

        func initNumber() {
            print("start to init number")
            // random choose two
            addRandomNumber()
            addRandomNumber()
            print("end to init number")
        }

        // swipe
        func swipeUp() {
            print("swipe up")
            var merge: Bool = false
            var x = 0
            while x < 4 {
                var y = 0
                while y < 4 {
                    for temp in y + 1..<4 {
                        if (data[aux(x, temp)].getNum() > 0) {
                            if (data[aux(x, y)].getNum() <= 0) {
                                data[aux(x, y)].setText(data[aux(x, temp)].getNum());
                                data[aux(x, temp)].setText(0);
                                y -= 1;
                                merge = true;
                            } else if (data[aux(x, y)].getNum() == data[aux(x, temp)].getNum()) {
                                data[aux(x, y)].setText(data[aux(x, temp)].getNum() * 2);
                                data[aux(x, temp)].setText(0);
                                addScore(data[aux(x, y)].getNum());
                                merge = true;
                            }
                            break;
                        }
                    }
                    y += 1
                }
                x += 1
            }
            if merge {
                addRandomNumber()
                isGameOver()
            }
        }

        func swipeDown() {
            print("swipe down")
            var merge: Bool = false
            var x = 0
            while x < 4 {
                var y = 3
                while y >= 1 {
                    print("debug down loop y ", y)
                    for temp in stride(from: y - 1, through: 0, by: -1) {
                        if (data[aux(x, temp)].getNum() > 0) {
                            if (data[aux(x, y)].getNum() <= 0) {
                                data[aux(x, y)].setText(data[aux(x, temp)].getNum());
                                data[aux(x, temp)].setText(0);
                                y += 1;
                                merge = true;
                            } else if (data[aux(x, y)].getNum() == data[aux(x, temp)].getNum()) {
                                data[aux(x, y)].setText(data[aux(x, temp)].getNum() * 2);
                                data[aux(x, temp)].setText(0);
                                addScore(data[aux(x, y)].getNum());
                                merge = true;
                            }
                            break;
                        }
                    }
                    y -= 1
                }
                x += 1
            }
            if merge {
                addRandomNumber()
                isGameOver()
            }
        }

        func swipeLeft() {
            print("swipe left")
            var merge: Bool = false
            var y = 0
            while y < 4 {
                var x = 0
                while x < 4 {
                    for temp in x + 1..<4 {
                        if (data[aux(temp, y)].getNum() > 0) {
                            if (data[aux(x, y)].getNum() <= 0) {
                                data[aux(x, y)].setText(data[aux(temp, y)].getNum());
                                data[aux(temp, y)].setText(0);
                                x -= 1;
                                merge = true;
                            } else if (data[aux(x, y)].getNum() == data[aux(temp, y)].getNum()) {
                                data[aux(x, y)].setText(data[aux(temp, y)].getNum() * 2);
                                data[aux(temp, y)].setText(0);
                                addScore(data[aux(x, y)].getNum());
                                merge = true;
                            }
                            break;
                        }
                    }
                    x += 1
                }
                y += 1
            }
            if merge {
                addRandomNumber()
                isGameOver()
            }
        }

        func swipeRight() {
            print("swipe right")
            var merge: Bool = false
            var y = 0
            while y < 4 {
                var x = 3
                while x >= 1 {
                    for temp in stride(from: x - 1, through: 0, by: -1) {
                        if (data[aux(temp, y)].getNum() > 0) {
                            if (data[aux(x, y)].getNum() <= 0) {
                                data[aux(x, y)].setText(data[aux(temp, y)].getNum());
                                data[aux(temp, y)].setText(0);
                                x += 1;
                                merge = true;
                            } else if (data[aux(x, y)].getNum() == data[aux(temp, y)].getNum()) {
                                data[aux(x, y)].setText(data[aux(temp, y)].getNum() * 2);
                                data[aux(temp, y)].setText(0);
                                addScore(data[aux(x, y)].getNum());
                                merge = true;
                            }
                            break;
                        }
                    }
                    x -= 1
                }
                y += 1
            }
            if merge {
                addRandomNumber()
                isGameOver()
            }
        }

        func isGameOver() {
            for y in 0..<4 {
                for x in 0..<4 {
                    if (data[aux(x, y)].isFree()
                            || (x > 0 && data[aux(x, y)].getNum() == data[aux(x - 1, y)].getNum())
                            || (x < 3 && data[aux(x, y)].getNum() == data[aux(x + 1, y)].getNum())
                            || (y > 0 && data[aux(x, y)].getNum() == data[aux(x, y - 1)].getNum())
                            || (y < 3 && data[aux(x, y)].getNum() == data[aux(x, y + 1)].getNum())
                       ) {
                        gameOver = false;
                        return
                    }
                }
            }
            gameOver = true;
        }

        func addScore(_ score: Int) {
            self.score += score
        }


        func addRandomNumber() {
            let temp = randomGetFreePoint()
            print("start to set idx", temp, "number to 2")
            data[temp].setText(calRandomNumber())
            print("end to set idx", temp, "number to 2")
        }

        func calRandomNumber() -> Int {
            let number = RandomUtil.number(max: 10)
            return number == 9 ? 4 : 2
        }

        private func randomGetFreePoint() -> Int {
            while true {
                let x = RandomUtil.number(max: 4)
                let y = RandomUtil.number(max: 4)
                if data[x * 4 + y].isFree() {
                    print("random x is", x, "random y is", y, "free, lucky")
                    return x * 4 + y
                } else {
                    print("random x is", x, "random y is", y, "has been used")
                }
            }
        }

        private func aux(_ x: Int, _ y: Int) -> Int {
            print("debug cal x index", x, "y index", y, "idx", x * 4 + y)
            return x * 4 + y;
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
