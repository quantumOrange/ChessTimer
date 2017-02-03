//
//  PlayerTimer.swift
//  ChessTimer
//
//  Created by David Crooks on 26/01/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import Foundation

let clockStateChangedNotification = Notification.Name("clockStateChanged")

class PlayerTimer: Equatable {
    init(time:TimeInterval,player:Player){
        playTime = time
        timeRemaining = time
        self.player = player
        self.outOfTimeNotification = Notification.Name("\(player.description())OutOfTime")
       // timeRemainingAtLastStart = time
    }
    
    var timer:Timer?
    
    let player:Player
    
    let outOfTimeNotification:Notification.Name
    
    var playTime:TimeInterval
    
    var timeRemaining:TimeInterval
    
    //only need these for fallback if not iOS10
    var timeRemainingAtStart:TimeInterval = 0.0
    var startTime = Date()
    
    func start(){
        timeRemainingAtStart = timeRemaining
        startTime = Date()
        
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {timer in
                let ellapsedTime = self.startTime.timeIntervalSinceNow
                self.timeRemaining = self.timeRemainingAtStart + ellapsedTime
                
                if self.timeRemaining < 0.0 {
                    print("\(self.player.description()) out of time on iOS10")
                    self.timeRemaining = 0.0
                    self.pause()
                    NotificationCenter.default.post(name:self.outOfTimeNotification, object: nil)
                }
                
                NotificationCenter.default.post(name: clockStateChangedNotification, object: nil)
            })
        } else {
            
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(PlayerTimer.fallBack), userInfo: nil, repeats: true)
            
            
            
            
        }
    }
    
    //for iOS9
    @objc func fallBack() {
        let ellapsedTime = startTime.timeIntervalSinceNow
        self.timeRemaining = timeRemainingAtStart + ellapsedTime
        
        if self.timeRemaining < 0.0 {
            print("\(self.player.description()) out of time on iOS9")
            self.timeRemaining = 0.0
            self.pause()
            NotificationCenter.default.post(name:self.outOfTimeNotification, object: nil)
        }
        NotificationCenter.default.post(name: clockStateChangedNotification, object: nil)
    }
    
    func pause() {
        timer?.invalidate()
    }
    
    func reset() {
        timer?.invalidate()
        timeRemaining = playTime
    }
    
}

func ==(_ lhs: PlayerTimer, _ rhs: PlayerTimer) -> Bool {
    return lhs.playTime == rhs.playTime && lhs.timeRemaining == rhs.timeRemaining
}
