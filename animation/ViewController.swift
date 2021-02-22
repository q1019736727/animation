//
//  ViewController.swift
//  animation
//
//  Created by Chiu Young on 2021/2/22.
//

import UIKit
import QuartzCore


let WIDTH = UIScreen.main.bounds.width
let HEIGHT = UIScreen.main.bounds.height

let space = WIDTH/5
let zzTop = 200.0
let zzHeight = 80.0
let lineHeight = 200.0
let lineTop = (zzTop+zzHeight/2)-(lineHeight/2)

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        let line = BrokenlineView(frame: CGRect(x: 0, y: lineTop, width: Double(WIDTH), height: lineHeight))
        view.addSubview(line)

        let ZZLab = LabelAnimated(frame: CGRect(x: 0, y: zzTop, width: Double(WIDTH), height: zzHeight))
        ZZLab.text = "ZZ"
        view.addSubview(ZZLab)

    }
    
}

class BrokenlineView: UIView{
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: lineHeight/2))
        path.addLine(to: CGPoint(x: Double(space), y: lineHeight/2))
        path.addLine(to: CGPoint(x: Double(space)*2, y: 2.5))
        path.addLine(to: CGPoint(x: Double(space)*3, y: lineHeight - 2.5))
        path.addLine(to: CGPoint(x: Double(space)*4, y: lineHeight/2))
        path.addLine(to: CGPoint(x: Double(space)*5, y: lineHeight/2))


        addLine(path: path,color: UIColor.red)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.6) {

            self.addLine(path: path,color: UIColor.black)
        }
    }
    
    func addLine(path:UIBezierPath,color:UIColor)  {
        let line = CAShapeLayer()
        line.lineCap = CAShapeLayerLineCap.round
        line.lineJoin = CAShapeLayerLineJoin.round
        line.lineWidth = 5
        line.strokeEnd = 0
        line.path = path.cgPath
        line.fillColor = UIColor.clear.cgColor
        line.strokeColor = color.cgColor
        layer.addSublayer(line)
        
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.autoreverses = false
        animation.repeatCount = MAXFLOAT
        animation.duration = 4.0

        line.add(animation,forKey:nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class LabelAnimated: UIView {
    lazy var gradientLayer: CAGradientLayer = {
        let grad = CAGradientLayer()
        grad.startPoint = CGPoint(x: 0.0, y: 0.5)
        grad.endPoint = CGPoint(x: 1.0, y: 0.5)
        let colors = [
            UIColor.clear.cgColor,
            UIColor.yellow.cgColor,
            UIColor.clear.cgColor,
        ]
        grad.colors = colors
        let locations: [NSNumber] = [
            0.0, 0.5, 1.0
        ]
        grad.locations = locations
        return grad
    }()
    
    var text: String! {
        didSet {
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            let textAttributes = [
                NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold",size: 68.0)!,
                NSAttributedString.Key.paragraphStyle: style
            ]
            let textImage = UIGraphicsImageRenderer(size: bounds.size) .image { _ in
                text.draw(in: bounds, withAttributes: textAttributes)
            }
            let maskLayer = CALayer()
            maskLayer.backgroundColor = UIColor.clear.cgColor
            maskLayer.frame = bounds.offsetBy(dx: bounds.size.width, dy: 0)
            maskLayer.contents = textImage.cgImage
            gradientLayer.mask = maskLayer
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gradientLayer.frame = CGRect(
            x: -bounds.size.width,
            y: bounds.origin.y,
            width: 3 * bounds.size.width,
            height: bounds.size.height)
        layer.addSublayer(gradientLayer)
        
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [0.0, 0.0, 0.25]
        gradientAnimation.toValue = [0.75, 1.0, 1.0]
        gradientAnimation.duration = 4.0
        gradientAnimation.repeatCount = Float.infinity
        gradientLayer.add(gradientAnimation, forKey: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

