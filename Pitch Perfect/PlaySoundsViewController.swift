//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Issac Rosa on 3/5/15.
//  Copyright (c) 2015 IARBizGroup. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var stopButton: UIButton!
    
    var audioPlayer:AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer!
    
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode:AVAudioPlayerNode!
    var audioFile:AVAudioFile!
    
    // Set constants for Rate and Pitch
    let slowRate:Float = 0.5
    let normalRate: Float = 1.0
    let fastRate:Float = 2.0
    let highPitch:Float = 1000
    let lowPitch:Float = -1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer2.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAudioSlow(sender: UIButton) {
        playAudio(slowRate)
    }
    
    @IBAction func playAudioFast(sender: UIButton) {
        playAudio(fastRate)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        if(audioPlayer != nil && audioPlayer.playing){
            audioPlayer.stop()
        }
        
        if(audioPlayerNode != nil && audioPlayerNode.playing){
            audioPlayerNode.stop()
        }
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(highPitch)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(lowPitch)
    }
    
    @IBAction func playEcho(sender: UIButton) {
        playAudio(normalRate)
        
        let delay = 0.3 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue()) {
            self.playAudio2(self.normalRate)
        }
    }
    
    func playAudio(playRate: Float) {
        stopResetPlayerEngine()
        audioPlayer.rate = playRate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playAudio2(playRate: Float) {
        audioPlayer2.rate = playRate
        audioPlayer2.currentTime = 0.0
        audioPlayer2.play()
    }
        
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayerNode = AVAudioPlayerNode()
        stopResetPlayerEngine()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func stopResetPlayerEngine() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
}
