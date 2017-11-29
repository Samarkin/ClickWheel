import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var clickWheel: ClickWheelView!
    private var nightMode: Bool = false
    @IBAction func nightModeTap(_ sender: UIButton) {
        nightMode = !nightMode
        if nightMode {
            view.backgroundColor = .black
            clickWheel.backgroundColor = .black
            clickWheel.wheelColor = .white
        }
        else {
            view.backgroundColor = .white
            clickWheel.backgroundColor = .white
            clickWheel.wheelColor = .black
        }
    }
}
