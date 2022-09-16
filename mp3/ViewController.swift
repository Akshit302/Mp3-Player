//
//  ViewController.swift
//  mp3
//
//  Created by Akshit on 06/09/22.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {

    

    @IBOutlet weak var btnPlay: UIButton!
    var audio : AVAudioPlayer?
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func btnClickedPlay(_ sender: UIButton) {
        if let audio = audio, audio.isPlaying{
           
            btnPlay.setTitle("play", for: .normal)
            audio.stop()
        } else {
         
            btnPlay.setTitle("stop", for: .normal)
            let urlString = Bundle.main.path(forResource: "audio", ofType: "mp3")
           
            do {
               
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
                
                
                guard let urlString = urlString else {
                    return
                }
                
                audio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                
                guard let audio = audio else {
                    return
                }
                audio.play()
                
                
            } catch {
                print("something wrong")
            }
        }
    }
    
    
    
  
   
    
    
}

