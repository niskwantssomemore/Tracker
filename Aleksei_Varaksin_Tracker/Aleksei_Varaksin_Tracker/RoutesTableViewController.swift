//
//  RoutesTableViewController.swift
//  Aleksei_Varaksin_Tracker
//
//  Created by Aleksei Niskarav on 12.09.2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

import UIKit
import GoogleMaps

class RoutesTableViewController: UITableViewController {
    
    var routes: [Date: GMSMutablePath] = [:]
    var dates: [Date] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        routes = RealmService.instance.loadRoutes()
        for element in routes {
            dates.append(element.key)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RoutesTableViewCell", for: indexPath) as? RoutesTableViewCell else { preconditionFailure("RoutesTableViewCell cannot be dequeued") }
        let date = dates[indexPath.row]
        cell.configure(date: date)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapViewControllerSegue",
            let selectedRouteIndexPath = tableView.indexPathForSelectedRow?.row,
            let mapVC = segue.destination as? MapViewController {
            mapVC.routePath = routes[dates[selectedRouteIndexPath]]
        }
    }

}
