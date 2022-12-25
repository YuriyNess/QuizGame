//
//  TableViewHelpers.swift
//  QuizAppTests
//
//  Created by YuriyFpc on 28.11.2022.
//

import UIKit

extension UITableView {
    func cell(at row: Int) -> UITableViewCell? {
        dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0))
    }

    func title(at row: Int) -> String? {
        cell(at: row)?.textLabel?.text
    }

    func select(row: Int) {
        selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: .none)
        delegate?.tableView?(self, didSelectRowAt: IndexPath(row: row, section: 0))
    }

    func deselect(row: Int) {
        deselectRow(at: IndexPath(row: row, section: 0), animated: false)
        delegate?.tableView?(self, didDeselectRowAt: IndexPath(row: row, section: 0))
    }
}
