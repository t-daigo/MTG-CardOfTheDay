//
//  Card.swift
//  MTG-CardOfTheDay
//
//  Created by 醍醐崇紘 on 2019/07/14.
//  Copyright © 2019 醍醐崇紘. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

struct Cards: Codable {
    let cards: [Card]
    
    struct Card: Codable {
        let name: String
        let names: [String]?
        let type: String
        let multiverseid: Int?
        let imageUrl: String?
        let foreignNames: [ForeignNames]?
        let id: String?
        
        struct ForeignNames: Codable {
            let name: String
            let imageUrl: String?
            let language: String
        }
    }
}

class CardModel {
    var name: BehaviorRelay<String>
    var imageUrl: BehaviorRelay<String?>
    
    init() {
        name = BehaviorRelay(value: "")
        imageUrl = BehaviorRelay(value: nil)
    }
    
    func setProperties(_ card: Cards.Card) {
        var filtered: Cards.Card.ForeignNames?
        if let foreign = card.foreignNames {
            filtered = foreign.first(where: { $0.language == "Japanese" && $0.imageUrl != nil })
        }
        
        let name = filtered != nil ? filtered!.name : card.name
        let imageUrl: String? = filtered != nil ? filtered!.imageUrl : card.imageUrl
        
        self.name.accept(name)
        self.imageUrl.accept(imageUrl)
    }
}
