//
//  GMSearchText.swift
//  GMSearchTextWithDropdown
//
//  Created by Gina Mullins on 1/5/17.
//  Copyright © 2017 Gina Mullins. All rights reserved.
//


import UIKit

protocol GMSearchTextDelegate: class {
    // all optional
    func searchTextCancelButtonClicked(searchText: GMSearchText)
    func searchTextSearchButtonClicked(searchText: GMSearchText)

    func searchTextTextFieldShouldBeginEditing(searchText: GMSearchText) -> Bool
    func searchTextTextFieldDidBeginEditing(searchText: GMSearchText)
    func searchTextTextFieldDidEndEditing(searchText: GMSearchText)
    func textDidChange(searchText: String)
}

class GMSearchText: UIView, UITextFieldDelegate, GMSearchTextDelegate {

    // public

    weak var delegate: GMSearchTextDelegate?
    var textField = FloatingLabelTextField()
    
    var title: String? {
        didSet {
            if let title = title {
                self.textField.setFloatingLabelText(text: title)
            }
        }
    }
    var text: String {
        get {
            return self.textField.text ?? ""
        }
        set(newValue) {
            if newValue != text {
                self.textField.text = newValue
            }
        }
    }
    var placeholder: String? {
        didSet {
            if let placeholder = placeholder {
                self.textField.placeholder = placeholder
            }
        }
    }
    var font: UIFont? {
        didSet {
            if let font = font {
                self.textField.font = font
            }
        }
    }
    var textColor: UIColor? {
        didSet {
            if let textColor = textColor {
                self.textField.textColor = textColor
            }
        }
    }

    // private

    private var innerDelegate: GMSearchTextDelegate {
        return delegate ?? self
    }

    private var cancelButton = UIButton()
    private var cancelButtonHidden: Bool = true {
        didSet {
            self.cancelButton.isHidden = cancelButtonHidden
        }
    }

    private let kXMargin = 10
    private let kYMargin = 5
    private let kIconSize = 16
    private let ksearchTextHeight = 50

    /// - Initializers

    private func commonInit() {
        self.backgroundColor = UIColor.clear

        let boundsWidth = self.bounds.size.width
        let textFieldWidth = boundsWidth - CGFloat(2*kXMargin + 2*kIconSize)
        let textFieldHeight = self.bounds.size.height - CGFloat(kYMargin)
        let textFieldFrame = CGRect(x: CGFloat(2*kXMargin), y: CGFloat(kYMargin), width: CGFloat(textFieldWidth), height: CGFloat(textFieldHeight))

        // TextField
        self.textField.frame = textFieldFrame
        self.textField.delegate = self;
        self.textField.returnKeyType = .search
        self.textField.autocapitalizationType = .none
        self.textField.autocorrectionType = .no
        self.textField.font = UIFont.systemFont(ofSize: 15.0)
        self.textField.textColor = UIColor.black

        self.addSubview(self.textField)

        // Cancel Button
        let cancelIcon = UIImage(named: "Cancel")
        let posX = Int(self.textField.frame.origin.x + self.textField.frame.size.width) - kIconSize - kXMargin
        let posY = Int(self.textField.frame.size.height) - kIconSize - kYMargin
        let buttonFrame = CGRect(x: CGFloat(posX), y: CGFloat(posY), width: CGFloat(kIconSize), height: CGFloat(kIconSize))

        self.cancelButton = UIButton(frame: buttonFrame)
        self.cancelButton.setImage(cancelIcon, for: .normal)
        self.cancelButton.contentMode = .scaleAspectFit
        self.cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        self.addSubview(self.cancelButton)
        cancelButtonHidden = true

        // Listen to text changes
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: .UITextFieldTextDidChange, object: self.textField)
    }

    @objc private func cancelPressed() {
        self.innerDelegate.searchTextCancelButtonClicked(searchText: self)
        self.text = "";
        cancelButtonHidden = true
    }

    @objc private func textChanged() {
        self.innerDelegate.textDidChange(searchText: self.text)
        cancelButtonHidden = (self.text.isEmpty) ? true : false
    }

    /// - TextField Delegates

    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return (self.innerDelegate.searchTextTextFieldShouldBeginEditing(searchText: self))
    }

    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        self.innerDelegate.searchTextTextFieldDidBeginEditing(searchText: self)
    }

    internal func textFieldDidEndEditing(_ textField: UITextField) {
        self.innerDelegate.searchTextTextFieldDidEndEditing(searchText: self)
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.innerDelegate.searchTextSearchButtonClicked(searchText: self)
        return true
    }

    override func draw(_ rect: CGRect) {
        let underlineColor = UIColor(red: 81/255.0, green: 160/255.0 , blue: 183/255.0, alpha: 1.0)
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: self.textField.frame.origin.x, y: self.textField.frame.size.height+1, width: self.textField.frame.size.width, height: 1.0)
        bottomBorder.backgroundColor = underlineColor.cgColor
        self.layer .addSublayer(bottomBorder)
    }

    /// Default initializer
    override init(frame: CGRect) {
        var newFrame = frame
        newFrame.size.height = CGFloat(ksearchTextHeight)

        super.init(frame: newFrame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

}

// for optional protocol methods
extension GMSearchTextDelegate {
    func searchTextCancelButtonClicked(searchText: GMSearchText) {}
    func searchTextSearchButtonClicked(searchText: GMSearchText) {}

    func searchTextTextFieldShouldBeginEditing(searchText: GMSearchText) -> Bool {return true}
    func searchTextTextFieldDidBeginEditing(searchText: GMSearchText) {}
    func searchTextTextFieldDidEndEditing(searchText: GMSearchText) {}
    func textDidChange(searchText: String) {}
}
