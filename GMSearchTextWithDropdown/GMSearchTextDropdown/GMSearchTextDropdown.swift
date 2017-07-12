//
//  GMSearchTextDropdown.swift
//  GMSearchTextWithDropdown
//
//  Created by Gina Mullins on 1/5/17.
//  Copyright © 2017 Gina Mullins. All rights reserved.
//
// MIT License

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

enum DropDownDirection {
    case DropDownDirectionDown
    case DropDownDirectionUp
}

protocol GMSearchTextDropdownDelegate: class {
    func textDidChange(searchText: String)
    func didSelectRow(searchText: String)
    func searchTextCancelClicked()
}

class GMSearchTextDropdown: UIView, UITableViewDelegate, UITableViewDataSource, GMSearchTextDelegate {

    // public
    var searchText: GMSearchText!
    var data = [String]() {
        didSet {
            self.searchData = data;
            filterTableViewWith(searchText: self.searchText.text)
        }
    }
    var hidesOnSelection: Bool = true
    var shouldHandleFilter: Bool = true
    var direction: DropDownDirection!

    weak var delegate: GMSearchTextDropdownDelegate?

    // private
    let kDropdownCell = "SearchCell"
    let kXMargin = 8
    let kYMargin = 5
    let ksearchTextHeight = 50

    var tableView = UITableView()
    var searchData = [String]()

    func configureWithSearch(data: [String], title: String, placeholder: String) {
        self.searchText.title = title;
        self.searchText.placeholder = placeholder;
        self.data = data;
        hideSearchTable(hide: true)
    }

    /// - Initializers

    private func commonInit() {

        self.backgroundColor = UIColor.clear

        let boundsWidth = self.bounds.size.width - CGFloat(2*kXMargin)

        // searchText
        let searchTextFrame = CGRect(x: CGFloat(kXMargin), y: CGFloat(kYMargin), width: boundsWidth, height: CGFloat(ksearchTextHeight))
        searchText = GMSearchText(frame: searchTextFrame)
        searchText.delegate = self;
        searchText.becomeFirstResponder()

        self.addSubview(searchText)

        // tableview
        let textFieldFrame = self.searchText.textField.frame
        let posX = textFieldFrame.origin.x + CGFloat(kXMargin)
        let posY = textFieldFrame.origin.y + textFieldFrame.size.height + CGFloat(2*kYMargin);
        let tableWidth = textFieldFrame.size.width
        let tableViewFrame = CGRect(x: posX, y: posY, width: tableWidth, height: 0.0)

        self.tableView = UITableView(frame: tableViewFrame, style: .plain)
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: kDropdownCell)
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        self.tableView.isHidden = true;

        self.addSubview(self.tableView)

        // add a subtle border to table
        let borderColor = UIColor.lightGray
        self.tableView.layer.borderWidth = 1;
        self.tableView.layer.borderColor = borderColor.cgColor;
        self.tableView.clipsToBounds = true;
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        var frame = self.tableView.frame
        frame.size = self.tableView.contentSize
        if frame.size.height > self.frame.size.height - CGFloat(2*kYMargin) {
            frame.size.height = self.frame.size.height - CGFloat(2*kYMargin)
        }

        self.tableView.frame = frame
    }

    func hideSearchTable(hide: Bool) {
        self.tableView.isHidden = hide
    }

    func filterTableViewWith(searchText: String) {
        self.tableView.isHidden = (searchText.characters.count > 0) ? false : true;
        if (self.shouldHandleFilter) {
            if searchText.isEmpty {
                self.searchData = self.data
            } else {
                self.searchData = self.data.filter { item in
                    return item.lowercased().contains(searchText.lowercased())
                }
            }
        }
        
        self.tableView.reloadData()
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

    /// - Cleanup

    deinit {
        self.tableView.removeObserver(self, forKeyPath: "contentSize", context: nil)
    }

    /// tableview

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kDropdownCell, for: indexPath)
        cell.textLabel?.text = self.searchData[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchText.text = self.searchData[indexPath.row]
        self.delegate?.didSelectRow(searchText: self.searchText.text)
        self.tableView.isHidden = true
    }

    /// searchText delegate

    func searchTextCancelButtonClicked(searchText: GMSearchText) {
        self.searchText.text = ""
        self.filterTableViewWith(searchText: self.searchText.text)
        self.delegate?.searchTextCancelClicked()
    }

    func searchTextSearchButtonClicked(searchText: GMSearchText) {
        self.tableView.isHidden = (searchText.text.isEmpty) ? true : false
        self.searchText.textField.resignFirstResponder()
    }

    func textDidChange(searchText: String) {
        self.filterTableViewWith(searchText: self.searchText.text)
        self.delegate?.textDidChange(searchText: self.searchText.text)
    }

}
