//  Created by TCode on 30/12/2020.

import Foundation
import UIKit

class ResultsViewController: UIViewController {

    private var summary = ""
    private var answers = [PresentableAnswer]()

    private let correctAnswerCellId = "correctAnswerCellId"
    private let wrongAnswerCellId = "wrongAnswerCellId"

    convenience init(summary: String, answers: [PresentableAnswer]) {
        self.init()

        self.summary = summary
        self.answers = answers

        view.backgroundColor = .white
        view.addSubview(headerLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    lazy var headerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = summary
        return label
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(CorrectAnswerCell.self)
        tableView.register(WrongAnswerCell.self)

        tableView.allowsSelection = false

        return tableView
    }()
}

extension ResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        answers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = answers[indexPath.row]
        return answer.wrongAnswer == nil
            ? correctAnswerCell(for: answer)
            : wrongAnswerCell(for: answer)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let answer = answers[indexPath.row]
        return answer.wrongAnswer == nil ? 80 : 100
    }

    private func correctAnswerCell(for answer: PresentableAnswer) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CorrectAnswerCell.self)!
        cell.question = answer.question
        cell.answer = answer.answer
        return cell
    }

    private func wrongAnswerCell(for answer: PresentableAnswer) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(WrongAnswerCell.self)!
        cell.question = answer.question
        cell.correctAnswer = answer.answer
        cell.wrongAnswer = answer.wrongAnswer
        return cell
    }
}
