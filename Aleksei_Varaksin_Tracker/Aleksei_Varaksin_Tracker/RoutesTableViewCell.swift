//
//  RoutesTableViewCell.swift
//  Aleksei_Varaksin_Tracker
//
//  Created by Aleksei Niskarav on 12.09.2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

import UIKit

class RoutesTableViewCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel!

    public func configure(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.string(from: date)
        dateLabel.text = date
    }

}
