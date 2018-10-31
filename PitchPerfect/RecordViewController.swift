//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Abdullah Al-Mahry on 26/10/2018.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var stop: UIButton!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeState(isRecording: false)
    }
    
    
    @IBAction func recordAudio(_ sender: Any) {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        changeState(isRecording: true)
        
    }
    
    
    @IBAction func stopRecording(_ sender: Any) {
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
        
        audioRecorder.stop()
        changeState(isRecording: false)

    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Done Recording")
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // handle the state if recording or not
    func changeState (isRecording: Bool) {
        if isRecording {
            label.text = "Recording in progress"
            stop.isEnabled = true
            start.isEnabled = false
        }
        else {
            label.text = "Press button to record"
            stop.isEnabled = false
            start.isEnabled = true
        }
    }
}
