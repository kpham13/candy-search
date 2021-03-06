//
//  CandyTableViewController.swift
//  CandySearch
//
//  Created by Kevin Pham on 8/29/14.
//  Copyright (c) 2014 Kevin Pham. All rights reserved.
//

import UIKit

class CandyTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    var candies = [Candy]()
    var filteredCandies = [Candy]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.candies = [Candy(category: "Chocolate", name: "Chocolate Bar"),
                        Candy(category: "Chocolate", name: "Chocolate Chip"),
                        Candy(category: "Chocolate", name: "Dark Chocolate"),
                        Candy(category: "Hard", name: "Lollipop"),
                        Candy(category: "Hard", name: "Candy Cane"),
                        Candy(category: "Hard", name: "Jaw Breaker"),
                        Candy(category: "Other", name: "Caramel"),
                        Candy(category: "Other", name: "Sour Chew"),
                        Candy(category: "Other", name: "Gummi Bear")
        ]

        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - TABLE VIEW DATA SOURCE

    /*
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    */

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredCandies.count
        } else {
            return self.candies.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        var candy : Candy
        if tableView == self.searchDisplayController!.searchResultsTableView {
            candy = self.filteredCandies[indexPath.row]
        } else {
            candy = self.candies[indexPath.row]
        }
        
        cell.textLabel.text = candy.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //self.performSegueWithIdentifier("candyDetail", sender: tableView)
    }
  
    // MARK: - SEARCH/SCOPE BAR
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        // Filter the array using the filter method
        self.filteredCandies = self.candies.filter({ (candy: Candy) -> Bool in
            let categoryMatch = (scope == "All") || (candy.category == scope)
            let stringMatch = candy.name.rangeOfString(searchText)
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        let scopes = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
        let selectedScope = scopes[self.searchDisplayController!.searchBar.selectedScopeButtonIndex] as String
        self.filterContentForSearchText(searchString, scope: selectedScope)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        let scope = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text, scope: scope[searchOption])
        return true
    }
    
    // MARK: - NAVIGATION
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "candyDetail" {
            let candyDetailViewController = segue.destinationViewController as UIViewController
            if (self.searchDisplayController?.active == true) {
            //if sender as UITableView == self.searchDisplayController!.searchResultsTableView {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                let destinationTitle = self.filteredCandies[indexPath.row].name
                candyDetailViewController.title = destinationTitle
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let destinationTitle = self.candies[indexPath.row].name
                candyDetailViewController.title = destinationTitle
            }
        }
    }

}
