//  Created by TCode on 30/12/2020.

import Foundation
import UIKit

class QuestionViewController: UIViewController {

    private(set) var question = ""
    private(set) var options = [String]()
    private var selection: (([String]) -> Void)? = nil

    private var cellId = "CellID"

    convenience init(question: String, options: [String], selection: @escaping ([String]) -> Void) {
        self.init()
        self.question = question
        self.options = options
        self.selection = selection

        view.backgroundColor = .white
        view.addSubview(headerLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    lazy var headerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = question
        return label
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
}

extension QuestionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueCell(in: tableView)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection?(selectedOptions(in: tableView))
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.allowsMultipleSelection {
            selection?(selectedOptions(in: tableView))
        }
    }

    private func selectedOptions(in tableView: UITableView) -> [String] {
        return tableView.indexPathsForSelectedRows?.map {
            self.options[$0.row]
        } ?? []
    }

    private func dequeueCell(in tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) {
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: cellId)
        }
    }
}
