import Foundation
import UIKit
import SnapKit

extension UIButton {
    func jachiguBtn(text: String, cnt: String) {
        self.setTitle(text + " " + cnt, for: .normal)
        self.backgroundColor = UIColor(red: 37/255, green: 38/255, blue: 42/255, alpha: 1)
        self.layer.opacity = 0.85
        self.layer.cornerRadius = 10
        self.titleLabel?.font = UIFont.systemFont(ofSize: 9)
    }
}
