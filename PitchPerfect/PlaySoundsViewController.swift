//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Vikas Varma on 3/17/15.
//  Copyright (c) 2015 Vikas Varma. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var engine :AVAudioEngine!
    var audioFile:AVAudioFile!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()        
        var error:NSError?
        engine=AVAudioEngine()
        audioFile = AVAudioFile(forReading: recordedAudio.filePathUrl, error: &error)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func playSlow(sender: UIButton) {
        
        playChangedRatePitchAudio(0.5,pitch:1)
    }
    @IBAction func playFast(sender: UIButton) {
        
        playChangedRatePitchAudio(1.5,pitch:1)
    }
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        playChangedRatePitchAudio(1,pitch:1000)
    }
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        
        playChangedRatePitchAudio(1,pitch:-1000)
    }
    
    func playChangedRatePitchAudio(rate:Float ,pitch:Float){
        
        engine.stop()
        engine.reset()
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        changePitchEffect.rate=rate
        
        var audioPlayerNode = AVAudioPlayerNode()
        
        engine.attachNode(audioPlayerNode)
        
        engine.attachNode(changePitchEffect)
        
        engine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        engine.connect(changePitchEffect, to: engine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        engine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        engine.stop()
        engine.reset()
    }
    
}
