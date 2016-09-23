//
//  Card.swift
//  Match.cat.GuangZ
//
//  Created by Guang on 7/7/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import Foundation
import UIKit

class Deck {
    var photoList = [Photo]()
    var imageList = [UIImage]()
    var cardAmount: Int = 0

    func shuffle(card: [UIImage]) -> [UIImage] {
        var cardCopy = card
        var newDeck = [UIImage]()
        let total = cardCopy.count
        for i in 0 ..< total {
            let cardsCount = cardCopy.count
            let random = Int(arc4random_uniform(UInt32(cardsCount)))
            let randomCard = cardCopy[random]
            cardCopy.removeAtIndex(random)
            newDeck.append(randomCard)
            print(card[i])
        }
        return newDeck
    }
}