//
//  UITableViewHelper.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/16/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import UIKit

extension UITableView {

    func cell(at row: Int) -> UITableViewCell? {
        return dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0))
    }

    func select(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        // Test minique multiple selection
        selectRow(at: indexPath, animated: false, scrollPosition: .none)
        delegate?.tableView?(self, didSelectRowAt: indexPath)
    }

}
