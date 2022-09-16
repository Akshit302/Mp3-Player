//
//  PlayerControls.swift
//  mp3
//
//  Created by Akshit on 08/09/22.
//

import UIKit


protocol playerSlider: class{
    func onValueChanged(progress: Float, timePast: TimeInterval)
}

class PlayerControls: ViewWithXib {
    private let maximumUnitCount = 2
    private let sliderMinimumValue: Float = 0
    private let sliderMaximumValue: Float = 1.0
    
    
    // MARK: properties
    var delegate : playerSlider?
    var duration : TimeInterval = TimeInterval() {
        didSet {
            updateProgress(self.progress)
        }
    }
    
    var progress: Float{
        set(newValue) {
            guard !isDragging else {
                return
            }
            updateProgress(newValue)
        }
        get{
            return _progress
        }
    }
    
    private var _progress: Float = 0
    private var isDragging = false
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var lblStart: UILabel!
    
    @IBOutlet weak var lblRemain: UILabel!
    @IBAction func sliderView(_ sender: Any) {
        updateProgress(slider.value)
    }
    private func updateProgress(_ progress: Float) {
        var actualValue = progress >= sliderMinimumValue ? progress: sliderMinimumValue
        actualValue = progress <= sliderMaximumValue ? actualValue: sliderMaximumValue
        
        self._progress = actualValue
        self.slider.value = actualValue
        let pastInterval = Float(duration)*actualValue
        let remainInterval = Float(duration)-pastInterval
        self.lblStart.text = intervalToString(TimeInterval(pastInterval))
        self.lblRemain.text = intervalToString(TimeInterval(remainInterval))
    }
    private func intervalToString(_ interval: TimeInterval) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.maximumUnitCount = maximumUnitCount
        return formatter.string(from: interval)

    }
    override func initUI() {
        super.initUI()
        self.slider.addTarget(self, action: #selector (dragDidBegin), for: .touchDragInside)
        self.slider.addTarget(self, action: #selector (dragDidEnd), for: .touchUpInside)
        
    }
    
    
     @objc private func dragDidBegin() {
         isDragging = true
     }
     @objc private func dragDidEnd() {
         self.isDragging = false
         self.notifyDelegate()
     }
     private func notifyDelegate() {
         let timePast = self.duration * Double(slider.value)
         self.delegate?.onValueChanged(progress: slider.value, timePast: timePast)
     }

}
