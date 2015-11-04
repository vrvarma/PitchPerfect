//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Vikas Varma on 3/17/15.
//  Copyright (c) 2015 Vikas Varma. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseResumeButton: UIButton!
    
    let resumeImage = UIImage(named:"resume") as UIImage?
    let pauseImage = UIImage(named:"pause") as UIImage?
    
    let recordingTxt = "Recording in progress"
    let pauseRecordingTxt="Recording paused"
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    //Variable to manage the state of the pause button
    var isPaused:Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool) {
        
        resetComponents()
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        
        recordingLabel.hidden=false
        recordingLabel.text = recordingTxt
        recordingButton.enabled=false
        stopButton.hidden=false
        pauseResumeButton.hidden=false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        
        audioRecorder = try! AVAudioRecorder(URL: filePath!, settings: [ : ])
        audioRecorder.delegate=self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    //Action method to stop recording.
    @IBAction func stopRecording(sender: UIButton) {
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
        resetComponents()
    }
    
    //Action method to pause and resume recording
    @IBAction func pauseResume(sender: UIButton) {
        
        if(!isPaused){
            
            pauseResumeButton.setImage(resumeImage,forState:.Normal)
            recordingLabel.text = pauseRecordingTxt
            isPaused=true
            audioRecorder.pause()
            
        }else{
            
            //pauseResumeButton.setTitle("pause", forState: UIControlState.Normal)
            pauseResumeButton.setImage(pauseImage,forState:.Normal)
            recordingLabel.text = recordingTxt
            isPaused=false
            audioRecorder.record()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier=="stopRecording"){
            
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            
            playSoundsVC.recordedAudio = data
        }
    }
    
    func resetComponents(){
        
        stopButton.hidden=true
        recordingButton.enabled=true
        recordingLabel.hidden=false
        recordingLabel.text="Tap to Record"
        pauseResumeButton.setImage(pauseImage,forState:.Normal)
        pauseResumeButton.hidden=true
        isPaused=false
    }
    
    func  audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if(flag){
            
            recordedAudio = RecordedAudio(url: recorder.url,title: recorder.url.lastPathComponent)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        }else{
            
            print("Recording was not successful")
            recordingButton.enabled=true
            stopButton.hidden=true
            pauseResumeButton.hidden=true
        }
        
    }
}


