//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let eggTimes = ["Soft": 5, "Medium": 8, "Hard": 12]
    var player: AVAudioPlayer? = nil
    var secondsRemaining: Int? = nil
    var totalDurationInSeconds: Int? = nil
    var timer: Timer? = nil
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBAction func hardnessSelector(_ sender: UIButton) { 
        let hardness = sender.currentTitle!
        label.text = hardness
        
        secondsRemaining = eggTimes[hardness]! * 60
        totalDurationInSeconds = secondsRemaining
        
        if timer != nil {
            timer!.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    
    @objc func timerCallback() {
        // Count down.
        secondsRemaining! -= 1
        
        // Calculate new progress percentage.
        let elapsedTime = totalDurationInSeconds! - secondsRemaining!
        let progress = Float(elapsedTime) / Float(totalDurationInSeconds!)
        
        // Update progress view.
        progressView.progress = progress
        
        // When the time is up.
        if (secondsRemaining == 0) {
            timer!.invalidate()
            label.text = "Done!"
            playSound()
        }
    }
    
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
