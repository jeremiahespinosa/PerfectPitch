//
//  PlaySoundsViewController.swift
//  PerfectPitch
//
//  Created by jeremiah espinosa on 8/27/15.
//  Copyright (c) 2015 Jeremiah Espinosa. All rights reserved.
//
import AVFoundation
import UIKit

class PlaySoundsViewController: UIViewController {

    var audioPlayer : AVAudioPlayer!;
    var receivedAudio: RecordedAudio!;
    var avAudioEngine:AVAudioEngine!
    var avAudioPlayerNode:AVAudioPlayerNode! //connected to mp3 file and actually play recorded sound; attach to audio engine
    var avAudioFile : AVAudioFile!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //TODO: path to file
        
        //have to convert string to nsurl for avaudioplayer
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){        //
//        var filePathUrl = NSURL.fileURLWithPath(filePath);
//        }
//        else{
//            println("The filepath is empty");
//        }
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil);
        audioPlayer.enableRate = true;
        avAudioEngine = AVAudioEngine()
        avAudioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(true);
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        avAudioEngine.stop()
        avAudioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        
        avAudioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        avAudioEngine.attachNode(changePitchEffect)
        
        avAudioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        avAudioEngine.connect(changePitchEffect, to: avAudioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(avAudioFile, atTime: nil, completionHandler: nil)
        avAudioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }

    @IBAction func stopPlayingAudio(sender: UIButton) {
        audioPlayer.stop();
    }
    
    @IBAction func playSlowedDown(sender: UIButton) {
        playAudio(false);
    }
    
    @IBAction func playVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    func playAudio(isFast: Bool){
        audioPlayer.stop();
        audioPlayer.currentTime = 0.0;
        
        if isFast {
            audioPlayer.rate = 2.0;
        }
        else{
            audioPlayer.rate = 0.5;
        }
        
        audioPlayer?.play();
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
