//
//  ShowCardViewModel.swift
//  MTG-CardOfTheDay
//
//  Created by 醍醐崇紘 on 2019/07/14.
//  Copyright © 2019 醍醐崇紘. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class ShowCardViewModel {
    let disposeBag = DisposeBag()
    let provider: MoyaProvider<MTGAPI>
    
    var cardName: Driver<String>
    var cardImage: Driver<Data>
    
    private var card = Driver<Cards.Card>.never()
    private let cardModel: CardModel
    
    init() {
        provider = MoyaProvider<MTGAPI>()
        cardModel = CardModel()
        
        cardName = cardModel.name
            .asDriver(onErrorDriveWith: Driver.empty())
        
        cardImage = cardModel.imageUrl
            .asDriver(onErrorDriveWith: Driver.empty())
            .filterNil()
            .map { URL(string: $0) }
            .filterNil()
            .map { try? Data(contentsOf: $0) }
            .filterNil()
        
        fetchCard()
    }
    
    func fetchCard() {
        provider.rx.request(.CardSearch(CardSearchParam.defaultParam))
            .filterSuccessfulStatusCodes()
            .map(Cards.self)
            .map { e -> Cards.Card in
                let filtered = e.cards.filter { !$0.type.contains("Basic") && $0.imageUrl != nil }
                return filtered.randomElement()!
            }
            .asObservable()
            .subscribe { [weak self] card in
                if let strongSelf = self,
                   let cardElement = card.element {
                    strongSelf.cardModel.setProperties(cardElement)
                }
            }
            .disposed(by: disposeBag)
    }
}
