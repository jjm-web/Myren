//
//  PaddingLabel.swift
//  Myren
//
//  Created by 장준명 on 2022/11/17.
//
import Foundation
import UIKit

class PaddingLabel: UILabel {

    @IBInspectable var topPadding: CGFloat = 0.0
    @IBInspectable var leftPadding: CGFloat = 0.0
    @IBInspectable var bottomPadding: CGFloat = 0.0
    @IBInspectable var rightPadding: CGFloat = 0.0
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.topPadding = padding.top
        self.leftPadding = padding.left
        self.bottomPadding = padding.bottom
        self.rightPadding = padding.right
    }
       
    override func drawText(in rect: CGRect) {
        let padding = UIEdgeInsets.init(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)
        super.drawText(in: rect.inset(by: padding))
    }
       
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += self.leftPadding + self.rightPadding
        contentSize.height += self.topPadding + self.bottomPadding
        return contentSize
    }

}

class UIPaddedButton: UIButton {
  let padding = UIEdgeInsets(top: 14, left: 27, bottom: 14, right: 10)

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
    return contentRect.inset(by: padding)
  }
}

