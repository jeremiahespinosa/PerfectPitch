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

    var audioRecorder:AVAudioRecorder!  //what is the question mark
    var recordedAudio:RecordedAudio!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //for initial setup
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
        //TODO: Record the users voice
        stopButton.hidden = false;
        recordingLabel.hidden = false;
        recordButton.enabled = false;
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
//        let currentDateTime = NSDate()
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "ddMMyyyy-HHmmss"
//        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let recordingName = "my_audio.wav"
        
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
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
        recordingLabel.hidden = true;
        stopButton.hidden = true;
        recordButton.enabled = true;
        
        //Inside func stopAudio(sender: UIButton)
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        //use the boolean to see if audio recording finished successfully
        if flag {
            //TODO: save the recorded audio
            recordedAudio = RecordedAudio();
            recordedAudio.filePathUrl = recorder.url;
            recordedAudio.title = recorder.url.lastPathComponent
            
            //TODO: move to the next scene aka perform segue
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

