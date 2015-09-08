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
    var avAudioPlayerNode:AVAudioPlayerNode!
    var avAudioFile : AVAudioFile!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func stopAndResetAudioEngine(){
        audioPlayer.stop()
        avAudioEngine.stop()
        avAudioEngine.reset()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        stopAndResetAudioEngine()
        
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
    
    func playAudio(isFast: Bool){
        stopAndResetAudioEngine()
        
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
}
