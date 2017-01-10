GMSearchTextWithDropdown

Nifty subclass utilizing the awesome FloatingLabel for inputting text used to search through an array of Strings. 
Results are displayed in an autoresizing table.

Getting Started

let data = ["Axel", "Raven", "Chuckie", "Ryusaki", "Mikasa", "Star Lord", "Goshiro", "Blackie", "Salem", "Balto", "Bell"]
self.searchTextDropdown.configureWithSearch(data: data, title: "Search", placeholder: "Enter Search Here")
searchTextDropdown.delegate = self

Installing

copy files to your project:
GMSearchText.swift
GMSearchTextDropdown.swift

License

This project is licensed under the MIT License - see the LICENSE.md file for details

Acknowledgments

https://github.com/infolock/SwiftFloatingLabelTextField

https://github.com/simongislen/SSSearchBar
