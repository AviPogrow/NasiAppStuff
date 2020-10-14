

import UIKit
import Lottie

class ProgressIndicator: UIView {
    
    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet weak var vwAnimated: AnimationView!
    
    class func initWith(frame:CGRect) -> ProgressIndicator {
        let indicator  = Bundle.main.loadNibNamed("ProgressIndicator", owner:self, options:nil)?.first as! ProgressIndicator
        indicator.frame = frame
        return indicator
    }
    
    class func shared() -> ProgressIndicator {
        return ProgressIndicator.initWith(frame:UIScreen.main.bounds)
    }
    
    func show( at superView:UIView) {
        self.frame = superView.bounds
        self.tag = 19518
        addTo(superView: superView)
        animateRotation()
    }
    
    func hide() {
      //  vwAnimated.loopAnimation = false
        vwAnimated!.stop()
        vwAnimated.layer.removeAllAnimations()
        self.removeFromSuperview()
    }
    
    func animateRotation() {
        vwAnimated!.play()
        vwAnimated.layer.cornerRadius = 10
        vwAnimated.backgroundColor = UIColor.clear
        vwAnimated.contentMode = .scaleAspectFill
        vwAnimated.loopMode = LottieLoopMode.loop
        vwAnimated.play()
    }
    
    func addTo(superView:UIView) {
        superView.addSubview(self)
        
        let top = NSLayoutConstraint.init(item:superView, attribute:.top, relatedBy:.equal, toItem:self, attribute:.top, multiplier: 1.0, constant:0)
        let right = NSLayoutConstraint.init(item:superView, attribute:.leading, relatedBy:.equal, toItem:self, attribute:.leading, multiplier: 1.0, constant:0)
        let botom = NSLayoutConstraint.init(item:superView, attribute:.bottom, relatedBy:.equal, toItem:self, attribute:.bottom, multiplier: 1.0, constant:0)
        let left = NSLayoutConstraint.init(item:superView, attribute:.trailing, relatedBy:.equal, toItem:self, attribute:.trailing, multiplier: 1.0, constant:0)
        
        superView.addConstraints([top,right,botom,left])
    }
}
