//
//  ShowCardViewController.swift
//  MTG-CardOfTheDay
//
//  Created by 醍醐崇紘 on 2019/07/14.
//  Copyright © 2019 醍醐崇紘. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ShowCardViewController: UIViewController {
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var showButton: UIButton!
    
    let vm: ShowCardViewModel
    let disposeBag = DisposeBag()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ vm: ShowCardViewModel) {
        self.vm = vm
        super.init(nibName: "ShowCardViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // binding to ViewModel
        vm.cardName.drive(cardNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        vm.cardImage.map { UIImage(data: $0) }
            .drive(cardImage.rx.image)
            .disposed(by: disposeBag)
        
        showButton.rx.tap
            .subscribe { [weak self] _ in
                if let strongSelf = self {
                    strongSelf.vm.fetchCard()
                }
            }
            .disposed(by: disposeBag)
    }
}
