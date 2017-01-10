//
//  ViewController.swift
//  GMSearchTextWithDropdown
//
//  Created by Gina Mullins on 1/9/17.
//  Copyright © 2017 Gina Mullins. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GMSearchTextDropdownDelegate {

    @IBOutlet weak var searchTextDropdown: GMSearchTextDropdown!

    override func viewDidLoad() {
        super.viewDidLoad()

        let data = ["Axel", "Raven", "Chuckie", "Ryusaki", "Mikasa", "Star Lord", "Goshiro", "Blackie", "Salem", "Balto", "Bell"]

        self.searchTextDropdown.configureWithSearch(data: data, title: "Search", placeholder: "Enter Search Here")

        searchTextDropdown.delegate = self
    }

    func textDidChange(searchText: String) {
        print("text did change")
    }

    func didSelectRow(searchText: String) {
        print("didSelectRow")
    }

    func searchTextCancelClicked(){
        print("searchTextSearchCancelClicked")
    }
    
}

