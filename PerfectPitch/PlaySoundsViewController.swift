//
//  PlaySoundsViewController.swift
//  PerfectPitch
//
//  Created by jeremiah espinosa on 8/27/15.
//  Copyright (c) 2015 Jeremiah Espinosa. All rights reserved.
//
import AVFoundation
import UIKit

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {

    var audioPlayer : AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var avAudioEngine:AVAudioEngine!
    var avAudioPlayerNode:AVAudioPlayerNode!
    var avAudioFile : AVAudioFile!
    
    @IBOutlet weak var stopPlayingAudioButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.delegate = self
        audioPlayer.enableRate = true
        avAudioEngine = AVAudioEngine()
        avAudioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)        
    }
    
    override func viewWillAppear(animated: Bool) {
        shouldWeShowStopButton(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(true)
    }
  
    @IBAction func stopPlayingAudio(sender: UIButton) {
        
        audioPlayer.stop()
        
        stopAndResetAudioEngine()
        
        shouldWeShowStopButton(false)
    }
    
    @IBAction func playSlowedDown(sender: UIButton) {
        playAudio(false)
    }
    
    @IBAction func playVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000, shouldPlayReverb: false, shouldPlayEcho: false)
    }
    
    func shouldWeShowStopButton(shouldShow: Bool){

        if shouldShow {
            stopPlayingAudioButton.hidden = false
        }
        else{
            stopPlayingAudioButton.hidden = true
        }
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playAudioWithVariablePitch(0, shouldPlayReverb: false, shouldPlayEcho: true)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000, shouldPlayReverb: false, shouldPlayEcho: false)
    }
    
    func stopAndResetAudioEngine(){
        audioPlayer.stop()
        avAudioEngine.stop()
        avAudioEngine.reset()
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playAudioWithVariablePitch(0, shouldPlayReverb: true, shouldPlayEcho: false)
    }
    
    func playAudioWithVariablePitch(pitch: Float, shouldPlayReverb: Bool, shouldPlayEcho: Bool){
        stopAndResetAudioEngine()
        
        var audioPlayerNode = AVAudioPlayerNode()
        
        avAudioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        var effect = AVAudioUnitReverb()
        
        if shouldPlayReverb {
            var reverb = AVAudioUnitReverb()
            reverb.loadFactoryPreset(AVAudioUnitReverbPreset.Plate)
            reverb.wetDryMix = 50
            avAudioEngine.attachNode(reverb)
            avAudioEngine.connect(audioPlayerNode, to: reverb, format: nil)
            avAudioEngine.connect(reverb, to: avAudioEngine.outputNode, format: nil)
        }
        else if shouldPlayEcho{

            var echoNode = AVAudioUnitDelay()
            echoNode.delayTime = NSTimeInterval(0.3)
            
            avAudioEngine.attachNode(echoNode)
            
            // Connect Player --> AudioEffect
            avAudioEngine.connect(audioPlayerNode, to: echoNode, format: nil)
            
            // Connect AudioEffect --> Output
            avAudioEngine.connect(echoNode, to: avAudioEngine.outputNode, format: nil)
        }
        else{

            //playing with a pitch modification
            avAudioEngine.attachNode(changePitchEffect)
            
            avAudioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
            avAudioEngine.connect(changePitchEffect, to: avAudioEngine.outputNode, format: nil)
        }
        

        audioPlayerNode.scheduleFile(avAudioFile, atTime: nil, completionHandler: nil)
        
        avAudioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
        shouldWeShowStopButton(true)
    }
    
    func playAudio(isFast: Bool){
        stopAndResetAudioEngine()
        
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        
        if isFast {
            audioPlayer.rate = 2.0
        }
        else{
            audioPlayer.rate = 0.5
        }
        
        audioPlayer?.play()
        
        shouldWeShowStopButton(true)
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        shouldWeShowStopButton(false)
    }
}
