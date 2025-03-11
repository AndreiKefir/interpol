//
//  CountrySelectTableViewController.swift
//  interpol3
//
//  Created by Andy Kefir on 11/03/2025.
//

import UIKit

protocol CountrySelectDelegate: AnyObject {
    func didSelectCountry(country: String)
}

class CountrySelectTableViewController: UITableViewController {
    weak var delegate: CountrySelectDelegate?
    let countries = Countries()
    var countryList = [String]()
    var filteredCounries: [String] = []
    var selectedCountry: String?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryList = countries.countriesList.map { $0.0 }
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Country"
        searchController.automaticallyShowsCancelButton = true
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        filteredCounries = countryList
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCounries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        cell.textLabel?.text = filteredCounries[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedCell = tableView.cellForRow(at: indexPath)
//        if selectedCountry == countryList[indexPath.row] {
//            selectedCell?.accessoryType = .none
//        } else {
//            selectedCountry = countryList[indexPath.row]
//            selectedCell?.accessoryType = .checkmark
//        }
        
        delegate?.didSelectCountry(country: filteredCounries[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
}

extension CountrySelectTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText.isEmpty {
            filteredCounries = countryList
        } else {
            filteredCounries = countryList.filter { $0.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
}
