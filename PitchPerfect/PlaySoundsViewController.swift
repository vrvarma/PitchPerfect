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
    var audioPlayerNode:AVAudioPlayerNode!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        var error:NSError?
        engine=AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        do {
            audioFile = try AVAudioFile(forReading: recordedAudio.filePathUrl)
        } catch let error1 as NSError {
            error = error1
            audioFile = nil
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func playSlow(sender: UIButton) {
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = 1.0
        changePitchEffect.rate=0.5
        playAudioEffect(changePitchEffect)
    }
    @IBAction func playFast(sender: UIButton) {
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = 1.0
        changePitchEffect.rate=1.5
        playAudioEffect(changePitchEffect)
    }
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = 1000
        changePitchEffect.rate=1
        playAudioEffect(changePitchEffect)
        
    }
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = -1000
        changePitchEffect.rate=1
        playAudioEffect(changePitchEffect)
    }
    @IBAction func playWithEcho(sender: UIButton) {
        
        let echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = 0.5
        echoEffect.feedback = 60
        echoEffect.wetDryMix = 50
        playAudioEffect(echoEffect)
    }
    
    @IBAction func playReverb(sender: UIButton) {
        
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.LargeHall)
        reverbEffect.wetDryMix = 42.0
        playAudioEffect(reverbEffect)
    }
    
    //Function to play the audio given the audioTimeEffect
    func playAudioEffect(avAudioEffect: AVAudioNode){
        
        resetAudio()
        
        audioPlayerNode = AVAudioPlayerNode()
        engine.attachNode(audioPlayerNode)
        engine.attachNode(avAudioEffect)
        
        engine.connect(audioPlayerNode, to: avAudioEffect, format: nil)
        engine.connect(avAudioEffect, to: engine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try engine.start()
        } catch _ {
        }
        
        audioPlayerNode.play()
    }
    
    func resetAudio(){
        
        audioPlayerNode.stop()
        engine.stop()
        engine.reset()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        
        resetAudio()
    }
    
}
