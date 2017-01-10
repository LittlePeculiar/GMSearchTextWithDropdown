//
//  FloatingLabelTextField.swift
//  Example
//
//  Created by Jonathon Hibbard on 12/18/14.
//  Copyright (c) 2014 Integrated Events. All rights reserved.
//

import UIKit

class FloatingLabelTextField: UITextField {
    let floatingLabel: UILabel = UILabel()
    let floatingLabelTextColor: UIColor = UIColor.gray
    let floatingLabelIsBoundToParent: Bool = false
    let animateEvenIfNotFirstResponder: Bool = false
    let placeholderYPadding: CGFloat = 0.0
    let yPadding: CGFloat = 0.0
    let showAnimationDuration: TimeInterval = 0.3
    let hideAnimationDuration: TimeInterval = 0.3

    var floatingLabelActiveTextColor: UIColor?
    var animatedYPos: CGFloat = 0.0
    var floatingLabelFont: UIFont = UIFont.boldSystemFont(ofSize: 12.0)


    private override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }

    private func commonInit() {
        floatingLabelActiveTextColor = tintColor
        floatingLabel.alpha = 0.0
        floatingLabel.font = floatingLabelFont
        floatingLabel.textColor = floatingLabelTextColor

        if let placeholder = self.placeholder {
            setFloatingLabelText(text: placeholder)
        }

        addSubview(floatingLabel)

        clipsToBounds = floatingLabelIsBoundToParent
        layer.masksToBounds = floatingLabelIsBoundToParent

        if !floatingLabelIsBoundToParent {
            animatedYPos = -15.0
        }
    }

    func setFloatingLabelText(text: String) {
        floatingLabel.text = text
        self.setNeedsLayout()
    }

    func setFloatingLabelFont(floatingLabelFont: UIFont) {
        self.floatingLabelFont = floatingLabelFont
        self.placeholder = self.placeholder
    }
    
    func showFloatingLabel(animated: Bool) {
        let labelFrame = CGRect(x: floatingLabel.frame.origin.x, y: animatedYPos, width: floatingLabel.frame.width, height: floatingLabel.frame.height)

        if animated || animateEvenIfNotFirstResponder {
            UIView.animate(withDuration: self.showAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                self.floatingLabel.alpha = 1.0
                self.floatingLabel.frame = labelFrame
            }, completion:nil )

            return
        }

        self.floatingLabel.alpha = 1.0
        self.floatingLabel.frame = labelFrame
    }

    func hideFloatingLabel(animated: Bool) {
        if animated || self.animateEvenIfNotFirstResponder {
            let yPos = self.floatingLabel.font.lineHeight + self.yPadding

            UIView.animate(withDuration: self.hideAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                self.floatingLabel.alpha = 0.0
                self.floatingLabel.frame = CGRect(x: self.floatingLabel.frame.origin.x, y: yPos, width: self.floatingLabel.frame.width, height: self.floatingLabel.frame.height)
            }, completion:nil )

            return
        }

        self.floatingLabel.alpha = 0.0
        self.floatingLabel.frame = CGRect(x: self.floatingLabel.frame.origin.x, y: self.floatingLabel.font.lineHeight + self.yPadding, width: self.floatingLabel.frame.width, height: self.floatingLabel.frame.height)
    }

    func setLabelOriginForTextAlignment() {
        let textRect: CGRect = super.textRect(forBounds: bounds)
        var originX = textRect.origin.x

        if self.textAlignment == NSTextAlignment.center {
            originX = textRect.origin.x + (textRect.size.width / 2) - (self.floatingLabel.frame.size.width / 2)
        } else if self.textAlignment == NSTextAlignment.right {
            originX = textRect.origin.x + textRect.size.width - self.floatingLabel.frame.size.width
        }
        self.floatingLabel.frame = CGRect(x: originX, y: self.floatingLabel.frame.origin.y, width: self.floatingLabel.frame.size.width, height: self.floatingLabel.frame.size.height)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect: CGRect = super.textRect(forBounds: bounds)
        let text = self.text!

        if text.characters.count > 0 {

            var topInset: CGFloat = CGFloat(ceilf(Float(self.floatingLabel.font.lineHeight + self.placeholderYPadding)))
            topInset = min(topInset, maxTopInset())

            rect = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(topInset, 0.0, 0.0, 0.0))
        }

        return rect.integral
    }
    
    func setPlaceholder(placeholder: NSString) {
        super.placeholder = placeholder as String

        self.floatingLabel.text = placeholder as String
        self.floatingLabel.sizeToFit()
    }

    func setAttributedPlaceholder(attributedPlaceholder: NSAttributedString) {
        super.placeholder = placeholder

        self.floatingLabel.text = attributedPlaceholder.string
        self.floatingLabel.sizeToFit()
    }

    func setAttributedPlaceholder(placeholder: NSAttributedString, floatingTitle: NSString ) {
        super.attributedPlaceholder = placeholder

        self.floatingLabel.text = floatingTitle as String
        self.floatingLabel.sizeToFit()
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect: CGRect = super.editingRect(forBounds: bounds)
        let text = self.text!

        if text.characters.count > 0 {
            var topInset: CGFloat = CGFloat(ceilf(Float(self.floatingLabel.font.lineHeight + self.placeholderYPadding)))
            topInset = min(topInset, maxTopInset())

            rect = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(topInset, 0.0, 0.0, 0.0))
        }

        return rect.integral
    }

    override func clearButtonRect(forBounds bounds: CGRect ) -> CGRect {
        var rect: CGRect = super.clearButtonRect(forBounds: bounds)
        let text = self.text!
        
        if text.characters.count > 0 {

            var topInset: CGFloat = CGFloat(ceilf(Float(self.floatingLabel.font.lineHeight + self.placeholderYPadding)))
            topInset = min(topInset, maxTopInset())

            rect = CGRect(x: rect.origin.x, y: rect.origin.y + topInset / 2.0, width: rect.size.width, height: rect.size.height)
        }

        return rect.integral
    }

    func maxTopInset() -> CGFloat {
        let initialValue: CGFloat = 0.0

        return max(initialValue, CGFloat(floorf(Float(self.bounds.size.height - self.font!.lineHeight - 4.0))))
    }

    func setTextAlignment(textAlignment: NSTextAlignment) {
        super.textAlignment = textAlignment

        self.setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setLabelOriginForTextAlignment()
        self.floatingLabel.font = self.floatingLabelFont

        self.floatingLabel.sizeToFit()

        let firstResponder:Bool = self.isFirstResponder
        let text = self.text!

        if firstResponder && text.characters.count > 0 {
            self.floatingLabel.textColor = floatingLabelActiveTextColor
        } else {
            self.floatingLabel.textColor = self.floatingLabelTextColor
        }

        if text.characters.count == 0 {
            hideFloatingLabel( animated: firstResponder )
        } else {
            showFloatingLabel( animated: firstResponder )
        }
    }
}
