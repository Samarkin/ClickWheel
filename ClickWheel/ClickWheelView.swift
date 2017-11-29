import UIKit

private let inWheelRadius: CGFloat = 0.25
private let outWheelRadius: CGFloat = 0.5
private let clickThreshold: CGFloat = 0.1

@IBDesignable
class ClickWheelView: UIView {
    @IBInspectable var wheelColor: UIColor = .black
    @IBInspectable var textColor: UIColor?
    override func draw(_ rect: CGRect) {
        let t = min(rect.height, rect.width)
        let outrect = CGRect(x: 0, y: 0, width: t, height: t)
        let inrect = CGRect(x: (t * inWheelRadius), y: (t * inWheelRadius), width: (t * outWheelRadius), height: (t * outWheelRadius))
        let outpath = UIBezierPath(ovalIn: outrect)
        let inpath = UIBezierPath(ovalIn: inrect)
        
        wheelColor.setFill()
        outpath.fill()
        (backgroundColor ?? .white).setFill()
        inpath.fill()

        let s = NSString.init(string: "\(value)%")
        let attr: [NSAttributedStringKey : Any] = [
            .font : UIFont(name: "Helvetica", size: 20)!,
            .foregroundColor : textColor ?? wheelColor
        ]
        let textSize = s.size(withAttributes: attr)
        let textH = textSize.height
        let textW = textSize.width
        let textrect = CGRect(x: (t-textW)/2, y: (t-textH)/2, width: textW, height: textH)
        s.draw(in: textrect, withAttributes: attr)
    }
    var feedbackGenerator: UISelectionFeedbackGenerator? = nil
    var curAngle: CGFloat = .nan
    var value: Int = 0
    func getAngle(touch: UITouch) -> CGFloat? {
        let t = min(frame.height, frame.width)
        let point = touch.location(in: self)
        let x = point.x - t/2
        let y = point.y - t/2
        let dist = sqrt(x*x + y*y)
        let ans = t*inWheelRadius < dist && dist < t*outWheelRadius ? atan2(x, y) : nil
        return ans
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO: Multitouch
        guard let touch = touches.first else {
            return
        }
        feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator?.prepare()
        if let a = getAngle(touch: touch) {
            curAngle = a
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        if let a = getAngle(touch: touch) {
            if abs(a - curAngle) > clickThreshold {
                if a - curAngle > .pi {
                    curAngle += 2 * .pi
                }
                else if curAngle - a > .pi {
                    curAngle -= 2 * .pi
                }
                let newValue = max(0, min(100, value + Int((curAngle-a) / clickThreshold)))
                curAngle = a
                if newValue != value {
                    value = newValue
                    feedbackGenerator?.selectionChanged()
                    feedbackGenerator?.prepare()
                    setNeedsDisplay()
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        feedbackGenerator = nil
        curAngle = .nan
    }
}
