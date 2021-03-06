//
//  RecordsSoundViewController.swift
//  PerfectPitch
//
//  Created by jeremiah espinosa on 8/24/15.
//  Copyright (c) 2015 Jeremiah Espinosa. All rights reserved.
//

import UIKit
import AVFoundation

class RecordsSoundViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //for initial setup
        
        recordingLabel.text = "Tap to Record"
    }

    override func viewWillAppear(animated: Bool) {
        //for showing and hiding things
        stopButton.hidden = true
        pauseButton.hidden = true
    }

    override func viewDidAppear(animated: Bool) {
        //for animations
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        if pauseButton.enabled{
            shouldStartRecordingOrResume(true)
        }
        else{
            shouldStartRecordingOrResume(false)
        }
    }
    
    func shouldStartRecordingOrResume(shouldStartFresh: Bool){
        pauseButton.hidden = false
        pauseButton.enabled = true
        
        recordButton.enabled = false
        
        stopButton.hidden = false
        recordingLabel.text = "Recording in Progress"
        recordButton.enabled = false
        
        if shouldStartFresh {
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
            
            let recordingName = "my_audio.wav"  //going to leave this way so that we do not create unnecessary files
            
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            
            
            var session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(AVAudioSessionCategoryRecord)
            } catch _ {
            }
            
            var maxTime = NSTimeInterval()
            
            //audioRecorder = try? AVAudioRecorder(URL: filePath, settings: nil)
            
            guard let filePathURL = NSURL.fileURLWithPathComponents(pathArray) else {
                print("Unknown error setting up URL: \(pathArray)")
                return
            }
            do {
                audioRecorder = try AVAudioRecorder(URL: filePathURL, settings: [:])
            } catch let error as NSError {
                print("error setting up Audio Recorder: \(error.localizedDescription)")
                return
            }
            
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.recordForDuration(maxTime)
            audioRecorder.prepareToRecord()
            
            audioRecorder.record()
        }
        else{
            audioRecorder.record()
        }
    }

    @IBAction func resumeRecordingButton(sender: UIButton) {
        shouldStartRecordingOrResume(false)
    }
    
    @IBAction func pauseRecordingButton(sender: UIButton) {
        recordingLabel.text = "Paused. Tap to resume recording"
        pauseButton.enabled = false
        
        recordButton.enabled = true
        
        audioRecorder.pause()
    }
    
    @IBAction func stopRecordingButton(sender: UIButton) {
        recordingLabel.text = "Tap to Record"
        stopButton.hidden = true
        recordButton.enabled = true
        
        audioRecorder.stop()
        var audioSession: Bool
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            audioSession = true
        } catch _ {
            audioSession = false
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        //use the boolean to see if audio recording finished successfully
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            // move to the next scene aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else{
            //else print error
            stopButton.hidden = true
            recordButton.enabled = true
        }
    }
    
    //gets called just before segue is about to be performed
    //good place to pass any data
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }
}

