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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //for initial setup
        
        recordingLabel.text = "Tap to Record"
    }

    override func viewWillAppear(animated: Bool) {
        //for showing and hiding things
        stopButton.hidden = true;
    }

    override func viewDidAppear(animated: Bool) {
        //for animations
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden = false;
        recordingLabel.text = "Recording in Progress"
        recordButton.enabled = false;
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String

        let recordingName = "my_audio.wav"  //going to leave this way so that we do not create unnecessary files
        
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)

        var maxTime = NSTimeInterval()

        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.recordForDuration(maxTime)
        audioRecorder.prepareToRecord()
        
        audioRecorder.record()
    }

    @IBAction func stopRecordingButton(sender: UIButton) {
        recordingLabel.text = "Tap to Record"
        stopButton.hidden = true;
        recordButton.enabled = true;
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        //use the boolean to see if audio recording finished successfully
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!);
            
            // move to the next scene aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else{
            //else print error
            println("Recording was not successful")
            stopButton.hidden = true;
            recordButton.enabled = true;
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

