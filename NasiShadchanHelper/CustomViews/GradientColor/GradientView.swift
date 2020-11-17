
import UIKit

@IBDesignable
class GradientButton: UIButton {
    
    // Comma(,) seprated hex codes of gradient colors
    @IBInspectable var gradientColors: String!
    
    //  Gradient style possible values only 0,1,2
    @IBInspectable var gradientStyle:Int = 1
    
    //  Gradient color alpha possible values only 0 to 1
    @IBInspectable var colorsAlpha:CGFloat = 1.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateGradientColors()
    }
    
    func updateGradientColors() {
        if gradientColors != nil {
            let aryGradientColors = gradientColors.components(separatedBy: ",")
            let style = GradientStyle(rawValue: gradientStyle)
            self.backgroundColor = UIColor.gradient(style:style!, frame:bounds, hexColors: aryGradientColors,alpha:colorsAlpha)
        }
    }
}

@IBDesignable
class GradientTransView: UIView {
    
// Comma(,) seprated hex codes of gradient colors
    @IBInspectable var gradientColors: String!
    
//  Gradient style possible values only 0,1,2
    @IBInspectable var gradientStyle:Int = 1
    
//  Gradient color alpha possible values only 0 to 1
    @IBInspectable var colorsAlpha:CGFloat = 1.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateGradientColors()
    }
    
    func updateGradientColors() {
        if gradientColors != nil {
            let aryGradientColors = gradientColors.components(separatedBy: ",")
            let style = GradientStyle(rawValue: gradientStyle)
            self.backgroundColor = UIColor.gradient(style:style!, frame:bounds, hexColors: aryGradientColors,alpha:colorsAlpha)
        }
    }
}

//MARK: Gradient Type
@objc enum GradientStyle : Int {
    
    case leftToRight
    
    case radial
    
    case topToBottom
    
    case diagonal
    
}

//MARK: -UIColor
extension UIColor {    
    // Gradient color with Hex codes and specific style Frame Dependant
    class func gradient(style:GradientStyle,frame:CGRect,hexColors:[String]) -> UIColor {
        if hexColors.count == 0 {
            return Constant.AppColor.colorAppTheme
        }
        else {
            var cgColors = [CGColor]()
            hexColors.forEach({ (hexCode) in
                cgColors.append(withHex(hex: hexCode, alpha: 1.0).cgColor)
            })
            return gradient(style: style, frame: frame, colors: cgColors)
        }
    }
    
    // Gradient color with Hex codes & alpha and specific style Frame Dependant
    class func gradient(style:GradientStyle,frame:CGRect,hexColors:[String],alpha:CGFloat) -> UIColor {
        if hexColors.count == 0 {
            return Constant.AppColor.colorAppTheme
        }
        else {
            var cgColors = [CGColor]()
            hexColors.forEach({ (hexCode) in
                cgColors.append(withHex(hex: hexCode, alpha: alpha).cgColor)
            })
            return gradient(style: style, frame: frame, colors: cgColors)
        }
    }
    
    // Gradient color with radial style Frame InDependant
    class func gradient(frame:CGRect,colors:[CGColor]) -> UIColor {
        return gradient(style:.radial, frame:frame, colors: colors)
    }
    
    // Gradient color with radial style and HexColors Frame InDependant
    class func gradient(frame:CGRect,hexColors:[String]) -> UIColor {
        if hexColors.count == 0 {
            return Constant.AppColor.colorAppTheme
        }
        else {
            var cgColors = [CGColor]()
            hexColors.forEach({ (hexCode) in
                cgColors.append(withHex(hex: hexCode, alpha: 1.0).cgColor)
            })
            return gradient(style:.radial, frame: frame, colors: cgColors)
        }
    }
    
    // Gradient color with specific style and CGColors Frame Dependant
    class func gradient(style:GradientStyle,frame:CGRect,colors:[CGColor]) -> UIColor {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        
        if style == .leftToRight || style == .topToBottom {
            gradientLayer.colors = colors
            if style == .leftToRight {
                gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 0.5)
            }
            
            UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, false, UIScreen.main.scale)
            gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
            let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return UIColor.init(patternImage: gradientImage!)
        }
        else if style == .diagonal {
            gradientLayer.colors = colors
            gradientLayer.startPoint = CGPoint.init(x: 1.0, y: 0.0)
            gradientLayer.endPoint = CGPoint.init(x: 0.0, y: 1.0)
            
            UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, false, UIScreen.main.scale)
            gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
            let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return UIColor.init(patternImage: gradientImage!)
        }
        else {
            UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
            let locations:[CGFloat] = [0.0,1.0]
            
            //Default to the RGB Colorspace
            let myColorspace = CGColorSpaceCreateDeviceRGB()
            let arrayRef:CFArray = colors as CFArray
            
            //Create our Gradient
            let gradient = CGGradient.init(colorsSpace:myColorspace, colors: arrayRef, locations: locations);
            
            // Normalise the 0-1 ranged inputs to the width of the image
            let centerPoint = CGPoint.init(x: frame.size.width*0.5, y: frame.size.height*0.5)
            let radius = min(frame.size.width, frame.size.height)*1.0
            
            // Draw our Gradient
            UIGraphicsGetCurrentContext()?.drawRadialGradient(gradient!, startCenter:centerPoint, startRadius:0, endCenter: centerPoint, endRadius: radius, options: .drawsAfterEndLocation)
            
            let gradientImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext()
            
            return UIColor.init(patternImage: gradientImage!)
        }
    }
}
