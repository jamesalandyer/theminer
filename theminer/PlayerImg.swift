//
//  playerImg.swift
//  theminer
//
//  Created by James Dyer on 3/26/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import Foundation
import UIKit

class PlayerImg: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func playAnimation(state: String, replay: Int, original: Int, type: String) {
        
        self.image = UIImage(named: "\(type)\(state)\(original).png")
        
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        
        if original == 1 {
            for index in 1...4 {
                let img = UIImage(named: "\(type)\(state)\(index).png")
                imgArray.append(img!)
            }
        } else if original == 5 {
            for index in 1...5 {
                let img = UIImage(named: "\(type)\(state)\(index).png")
                imgArray.append(img!)
            }
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = replay
        self.startAnimating()
    }
}
