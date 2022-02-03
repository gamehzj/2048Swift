//
//  RandomUtil.swift
//  Game2048Swift
//
//  Created by shoothzj on 2022/2/3.
//

import Foundation

public class RandomUtil {
    public static func number(max: Int) -> Int {
        Int.random(in: 0..<max)
    }
}
