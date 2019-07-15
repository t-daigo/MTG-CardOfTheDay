//
//  CardSearchParam.swift
//  MTG-CardOfTheDay
//
//  Created by 醍醐崇紘 on 2019/07/14.
//  Copyright © 2019 醍醐崇紘. All rights reserved.
//

import Foundation

class CardSearchParam {
    let key: String
    let value: String
    
    enum Params: String {
        case random
        case gameFormat
        case colors
        case type
    }
    
    init(key: Params, value: String) {
        self.key = key.rawValue
        self.value = value
    }
}

extension CardSearchParam {
    static var defaultParam: [CardSearchParam] {
        let random = CardSearchParam(key: .random, value: "true")
        return [random]
    }
}
