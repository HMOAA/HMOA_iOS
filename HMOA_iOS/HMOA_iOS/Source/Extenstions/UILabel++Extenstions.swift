
import UIKit

extension UILabel {
 
    func setLabelUI(_ text: String, font: Fonts, size: CGFloat, color: Colors) {
        self.textColor = .customColor(color)
        self.font = .customFont(font, size)
        self.text = text
    }
    
    // 자간, 행간 설정
    func setLineSpacing(kernValue: Double = 0.0,
                        lineSpacing: CGFloat = 0.0,
                        lineHeightMultiple: CGFloat = 0.0) {
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString: NSMutableAttributedString
        if let labelAttributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.kern,
                                      value: kernValue,
                                      range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
    
    // line height
    func setTextWithLineHeight(text: String?, lineHeight: CGFloat) {
            if let text = text {
                let style = NSMutableParagraphStyle()
                style.maximumLineHeight = lineHeight
                style.minimumLineHeight = lineHeight
                
                let attributes: [NSAttributedString.Key: Any] = [
                    .paragraphStyle: style,
                    .baselineOffset: (lineHeight - font.lineHeight) / 4
                ]
                    
                let attrString = NSAttributedString(string: text, attributes: attributes)
                self.attributedText = attrString
            }
        }
}
