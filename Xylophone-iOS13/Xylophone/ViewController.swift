//
//  ViewController.swift
//  Xylophone
//
//  Created by Angela Yu on 28/06/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func keyPress(_ sender: UIButton) {
        playSound(resource: sender.currentTitle)
    }
    
    func playSound(resource: String?) {
        guard resource != nil else {
            return
        }
        let url = Bundle.main.url(forResource: resource, withExtension: "wav")
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
            
            player = try? AVAudioPlayer(contentsOf: url!, fileTypeHint: AVFileType.wav.rawValue)
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }

}

