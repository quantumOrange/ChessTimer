//
//  ViewController.swift
//  ChessTimer
//
//  Created by David Crooks on 26/01/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion

class ClockViewController: UIViewController {
    var gameTimer = GameTimer()
    
    @IBOutlet weak var whiteClockFaceView: ClockFaceView!
    @IBOutlet weak var whitePlayerTimerView: PlayerTimerView!
    @IBOutlet weak var whiteTimeLable: UILabel!
    @IBOutlet weak var whitePlayerTriangle: TrianglePointerView!
    
    @IBOutlet weak var blackClockFaceView: ClockFaceView!
    @IBOutlet weak var blackPlayerTimerView: PlayerTimerView!
    @IBOutlet weak var blackTimeLable: UILabel!
    @IBOutlet weak var blackPlayerTriangle: TrianglePointerView!
    
    @IBAction func pause(_ sender: Any) {
        if gameTimer.isPaused {
            puaseButtons.forEach({$0.titleLabel?.text = "Pause"})
            gameTimer.unpause()
        }
        else {
            puaseButtons.forEach({$0.titleLabel?.text = "Start"})
            if gameTimer.activePlayer == .none {
                //game hasn't started - start!
            }
            else {
                //Game is on - pause!
                gameTimer.pause()
            }
            
        }
        
    }
   
    @IBAction func cancel(_ sender: Any) {
        gameTimer.pause()
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var puaseButtons: [UIButton]!

    @IBAction func clockTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .recognized {
            playClick()
            
            if gameTimer.activePlayer == .none {
               
               start()
            }
            else {
                gameTimer.switchPlayers()
            }
            updateTriangles(animated: true)
        }
    }
    
    func start() {
        puaseButtons.forEach({$0.titleLabel?.text = "Pause"})
        startClockAnimation()
    }
    
    let squashTransform:CGAffineTransform = { return CGAffineTransform.init(scaleX: 1.0, y: 0.001).aboutPoint(x:0,y:25)}()
    
    func updateTriangles(animated:Bool) {
        if !animated {
            if gameTimer.blackIsActive {
                blackPlayerTriangle.transform = CGAffineTransform.identity
            }
            else {
                blackPlayerTriangle.transform = squashTransform
            }
            if gameTimer.whiteIsActive {
                whitePlayerTriangle.transform = CGAffineTransform.identity
            }
            else {
                whitePlayerTriangle.transform = squashTransform
            }
        }
        
        var showDelay = 0.0
        let animationTime = 0.15
        
        func squashAndHide(view:UIView){
            UIView.animate(withDuration:animationTime, delay: 0.0, options: .curveEaseIn, animations: {
                view.transform = self.squashTransform
            }, completion: {didComple in
            })
        }
        
        func show(view:UIView){
            UIView.animate(withDuration: animationTime, delay: showDelay , options: .curveEaseOut, animations: {
                view.transform = CGAffineTransform.identity
            }, completion: {didComple in
                
            })
        }
        
        //1) Hide
        if !gameTimer.blackIsActive && blackPlayerTriangle.transform.isIdentity {
            showDelay = animationTime
            squashAndHide(view: blackPlayerTriangle)
        }
        if !gameTimer.whiteIsActive && whitePlayerTriangle.transform.isIdentity {
            showDelay = animationTime
            squashAndHide(view: whitePlayerTriangle)
        }
        
        //2)show
        if gameTimer.whiteIsActive {
            show(view: whitePlayerTriangle)
        }
        if gameTimer.blackIsActive {
            show(view: blackPlayerTriangle)
        }

    }
    
    
    func gameOverAlert() {
        print("Game over alert")
        playChime()
        let alert = UIAlertController(title: "Game Over", message: "\(gameTimer.winner) won by timeout", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.gameTimer.reset()
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Lifecycle and Viewcontroller overrides
    var currentAttitude:CMAttitude? { didSet {
            if let attitude = currentAttitude {
                if deviceIsHorizontalFaceup(attitude: attitude) {
                    if blackPlayerTimerView.transform.isIdentity {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.blackPlayerTimerView.transform = CGAffineTransform.init(rotationAngle: CGFloat(M_PI))
                        })
                    }
                }
                else {
                    if !blackPlayerTimerView.transform.isIdentity {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.blackPlayerTimerView.transform = CGAffineTransform.identity
                        })
                    }
                }
            }
        }
    }
    
    
    func deviceIsHorizontalFaceup(attitude:CMAttitude) -> Bool {
        let R = attitude.rotationMatrix
        //the vector (-R.m31,-R.m32,-R.m33) is gravity vector is device referance frame.
        let tolerance = 0.01
        return R.m33 > 1.0 - tolerance
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ClockViewController.updateClockViews), name: clockStateChangedNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ClockViewController.gameOverAlert), name: gameOverNotification, object:nil)
        
        //CMMotionManager *mManager = [(APLAppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager];
        let manager = CMMotionManager()
        
        
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.05
            
            manager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: {deviceManager, error in
                self.currentAttitude = manager.deviceMotion?.attitude
                })
            
            /*
            manager.startDeviceMotionUpdates(to:OperationQueue.main) {
                [weak self] (data: CMDeviceMotion?, error: Error?) in {
                    currentAttitude = self.motionManager.deviceMotion.attitude
                }
            */
        }
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //updateClockViews()
        if gameTimer.activePlayer == .none {
            clearClockFaces()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTriangles(animated: false)
        updateClockTimeLables()
    }
    
    override var shouldAutorotate:Bool {
        return false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    
    //MARK: - Clocks 
    
    
    var animateClockTimer:Timer?
    var clockAnimationProgress:CGFloat = 0.0
    let clockAnimationTimeInterval = 0.02
    func startClockAnimation() {
        clockAnimationProgress = 0.0
        animateClockTimer = Timer.scheduledTimer(timeInterval:clockAnimationTimeInterval, target: self, selector: #selector(animateClock), userInfo: nil, repeats: true)
    }
    
    func animateClock() {
        let duration = 0.5
        let increment = clockAnimationTimeInterval/duration
        clockAnimationProgress += CGFloat(increment)
       
        whiteClockFaceView.clockFace = createClockFace(fraction:clockAnimationProgress, in: whiteClockFaceView.bounds)
        blackClockFaceView.clockFace = createClockFace(fraction:clockAnimationProgress, in: blackClockFaceView.bounds)
        
        if clockAnimationProgress >= 1.0 {
            animateClockTimer?.invalidate()
            animateClockTimer = nil
           
            gameTimer.start()
            updateTriangles(animated: true)
        }
    }
    
    func clearClockFaces() {
        whiteClockFaceView.clockFace = createClockFace(fraction:0.0, in: whiteClockFaceView.bounds)
        blackClockFaceView.clockFace = createClockFace(fraction:0.0, in: blackClockFaceView.bounds)
    }
    func updateClockTimeLables() {
        whiteTimeLable.text = timeString(player: gameTimer.whitePlayer)
        blackTimeLable.text = timeString(player: gameTimer.blackPlayer)
    }
    
    func updateClockViews() {
        
        updateClockTimeLables()
        
        whiteClockFaceView.isActive = gameTimer.whiteIsActive
        blackClockFaceView.isActive = gameTimer.blackIsActive
        
       
        whiteClockFaceView.clockFace = createClockFace(timer: gameTimer.whitePlayer, in: whiteClockFaceView.bounds)
        blackClockFaceView.clockFace = createClockFace(timer: gameTimer.blackPlayer, in: blackClockFaceView.bounds)
        
    }
    
    func timeString(player:PlayerTimer) -> String {
        let oneMinute = 60
        let totalSeconds = Int(player.timeRemaining)
        let minutes = totalSeconds/oneMinute
        let seconds = totalSeconds%oneMinute
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    func createClockFace(timer:PlayerTimer, in rect:CGRect) -> ClockFace {
        let fraction = CGFloat( timer.timeRemaining/timer.playTime)
        return createClockFace(fraction: fraction, in: rect)
    }
    
    func createClockFace(fraction:CGFloat, in rect:CGRect) -> ClockFace {
        let angle = twoPi*fraction
        return ClockFace(center:rect.center, radius: 0.5*rect.width, angle:angle)
    }
    
    //MARK: -  Sound
    var soundID:SystemSoundID = 0
    
    func playSound(name:String) {
        let filePath = Bundle.main.path(forResource: name, ofType: "wav")
        let fileURL = NSURL(fileURLWithPath: filePath!)
        
        AudioServicesCreateSystemSoundID(fileURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    func playClick() {
        playSound(name:"digi_plink")
    }
    
    func playChime() {
        playSound(name:"chime_bell_ding")
    }
}

