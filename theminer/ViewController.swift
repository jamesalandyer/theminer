//
//  ViewController.swift
//  theminer
//
//  Created by James Dyer on 3/21/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var golemImg: PlayerImg!
    
    @IBOutlet weak var minerImg: PlayerImg!

    @IBOutlet weak var heartImg: DragImg!
    
    @IBOutlet weak var foodImg: DragImg!
    
    @IBOutlet weak var skullImg1: UIImageView!
    
    @IBOutlet weak var skullImg2: UIImageView!
    
    @IBOutlet weak var skullImg3: UIImageView!
    
    @IBOutlet weak var livespanel: UIImageView!
    
    @IBOutlet weak var skulls: UIStackView!
    
    @IBOutlet weak var items: UIStackView!
    
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var characterType: String!
    var penalties = 0
    var timer: NSTimer!
    var playerHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterType = "miner"
        
        foodImg.dropTarget = minerImg
        heartImg.dropTarget = minerImg
        
        minerImg.playAnimation("idle", replay: 0, original: 1, type: characterType)
        
        skullImg1.alpha = DIM_ALPHA
        skullImg2.alpha = DIM_ALPHA
        skullImg3.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.itemDroppedOnCharacter(_:)), name: "onTargetDropped", object: nil)
        
        do {
            let resourcePath = NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!
            let url = NSURL(fileURLWithPath: resourcePath)
            try musicPlayer = AVAudioPlayer(contentsOfURL: url)
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        startTimer()
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        if penalties < 3 {
            playerHappy = true
            startTimer()
            
            disable()
            
            if currentItem == 0 {
                sfxHeart.play()
            } else {
                sfxBite.play()
            }
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        if !playerHappy {
            penalties += 1
            sfxSkull.play()
            
            if penalties == 1 {
                skullImg1.alpha = OPAQUE
                skullImg2.alpha = DIM_ALPHA
            } else if penalties == 2 {
                skullImg2.alpha = OPAQUE
                skullImg3.alpha = DIM_ALPHA
            } else if penalties >= 3 {
                skullImg3.alpha = OPAQUE
            } else {
                skullImg1.alpha = DIM_ALPHA
                skullImg2.alpha = DIM_ALPHA
                skullImg3.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
        }
        
        let rand = arc4random_uniform(2)
        if penalties < 3 {
            if rand == 0 {
                foodImg.alpha = DIM_ALPHA
                foodImg.userInteractionEnabled = false
                
                heartImg.alpha = OPAQUE
                heartImg.userInteractionEnabled = true
            } else {
                foodImg.alpha = OPAQUE
                foodImg.userInteractionEnabled = true
                
                heartImg.alpha = DIM_ALPHA
                heartImg.userInteractionEnabled = false
            }
        }
        
        currentItem = rand
        playerHappy = false
    }
    
    func gameOver() {
        timer.invalidate()
        disable()
        sfxDeath.play()
        minerImg.playAnimation("dead", replay: 1, original: 5, type: characterType)
    }
    
    func disable() {
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
    }

}

