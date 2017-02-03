//
//  GameTimer.swift
//  ChessTimer
//
//  Created by David Crooks on 26/01/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import Foundation

let minute:TimeInterval = 60.0
struct Game {
    var white:Int
    var black:Int
}

enum Player {
    case black
    case white
    case none
    
    func description() -> String {
        switch self {
            case .white:
                return "White"
            case .black:
                return "Black"
        case .none:
                return "No one"
        }
    }
}

let gameOverNotification = Notification.Name("GameOver")

class GameTimer:Equatable {
  
    var winner:Player = .none {
        didSet {
            if winner != .none {
                print("\(winner.description()) won the game by timeout")
                NotificationCenter.default.post(name:gameOverNotification, object: nil)
            }
        }
    }
    
    var activePlayer:Player = .none
    
    init(){
        whitePlayer = PlayerTimer(time:1.0*minute,player:.white)
        blackPlayer = PlayerTimer(time:1.0*minute,player:.black)
        setup()
    }
    
    init(time:TimeInterval){
        whitePlayer = PlayerTimer(time:time,player:.white)
        blackPlayer = PlayerTimer(time:time,player:.black)
    }
    
    init(game:Game) {
        whitePlayer = PlayerTimer(time:TimeInterval(game.white)*minute,player:.white)
        blackPlayer = PlayerTimer(time:TimeInterval(game.black)*minute,player:.black)
    }
    
    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(GameTimer.whiteOutOfTime), name: whitePlayer.outOfTimeNotification, object:nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameTimer.blackOutOfTime), name: blackPlayer.outOfTimeNotification, object:nil)
    }
    
    @objc func whiteOutOfTime() {
        winner = .black
        self.pause()
    }
    
    @objc func blackOutOfTime() {
        winner = .white
        self.pause()
    }
    
    let whitePlayer:PlayerTimer
    let blackPlayer:PlayerTimer
    
    var whiteIsActive:Bool  {
        return activePlayer == .white
    }
    var blackIsActive:Bool {
        return activePlayer == .black
    }
    
    var totalGameTime:TimeInterval {
        get {
            return whitePlayer.playTime + blackPlayer.playTime
        }
    }
    
    func start() {
        winner = .none
        whitePlayer.start()
        activePlayer = .white
    }
    
     func switchPlayers() {
        switch activePlayer {
            case .white:
                whitePlayer.pause()
                blackPlayer.start()
                activePlayer = .black
            case .black:
                activePlayer = .white
                blackPlayer.pause()
                whitePlayer.start()
            case .none:
                activePlayer = .white
        }
    }
    
    func pause() {
        whitePlayer.pause()
        blackPlayer.pause()
    }
    
    func reset() {
        winner = .none
        activePlayer = .none
        whitePlayer.reset()
        blackPlayer.reset()
    }
}


func ==(_ lhs:GameTimer,_ rhs:GameTimer) -> Bool {
    return lhs.whitePlayer == rhs.whitePlayer && lhs.blackPlayer==rhs.blackPlayer
}
