
import UIKit

extension UILabel {
 
    func setLabelUI(_ text: String, font: Fonts, size: CGFloat, color: Colors) {
        self.textColor = .customColor(color)
        self.font = .customFont(font, size)
        self.text = text
    }
}
