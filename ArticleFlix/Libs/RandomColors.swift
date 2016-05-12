//
//  RandomColors.swift
//  ArticleFlix
//
//  Created by Shaher Kassam on 28/02/16.
//  Copyright © 2016 Shaher Kassam. All rights reserved.
//

import Foundation
import UIKit

func generateRandomData(rows: Int, itemsPerRow: Int) -> [[UIColor]] {
    let numberOfRows = rows
    let numberOfItemsPerRow = itemsPerRow
    
    return (0..<numberOfRows).map { _ in
        return (0..<numberOfItemsPerRow).map { _ in UIColor.randomColor() }
    }
}

extension UIColor {
    class func randomColor() -> UIColor {
        
        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}