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
    var timer: Timer?
    let cookingTime: [String: Float] = ["Soft": 300.0, "Medium": 420.0, "Hard": 720.0]
    let barColors = ["Soft": 0xE14500, "Medium": 0xC3A541, "Hard": 0xC6B87F]
    var time: Float?
    var secondsRemaining: Float?
    var alarmPlayer: AVAudioPlayer?
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var screenTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.setProgress(0.0, animated: false)
    }
    
    @IBAction func choseCookingDegree(_ sender: UIButton) {
        guard timer == nil else {
            return
        }
        let cookingDegree = sender.currentTitle!
        time = cookingTime[cookingDegree]
        secondsRemaining = time ?? 0.0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: true, repeats: true)
        setColorForProgressBar(hex: barColors[cookingDegree]!)
        screenTitle.text = "\(cookingDegree) is in progress..."
    }

    @objc func updateTimer() {
        let progress: Float = (time! - secondsRemaining!) / time!
        progressBar.setProgress(progress, animated: true)
        if secondsRemaining == 0.0 {
            timer?.invalidate()
            timer = nil
            playAlarmSound()
            screenTitle.text = "Done"
            resetScreenTitle()
            return
        }
        secondsRemaining! -= 1.0
    }
    
    func playAlarmSound() {
        let sound = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
            alarmPlayer = try? AVAudioPlayer(contentsOf: sound!)
            alarmPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func setColorForProgressBar(hex: Int) {
        progressBar.setProgress(0.0, animated: false)
        let color = UIColor(red: CGFloat((Float((hex & 0xff0000) >> 16)) / 255.0), green: CGFloat((Float((hex & 0xff00) >> 8)) / 255.0), blue: CGFloat((Float((hex & 0xff) >> 0)) / 255.0), alpha: 1.0)
        progressBar.tintColor = color
    }
    
    func resetScreenTitle() {
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { _ in
            self.progressBar.setProgress(0.0, animated: false)
            self.screenTitle.text = "How do you like your eggs?"
        }
    }
    
}
