//  Created by TCode on 30/12/2020.

import Foundation
import UIKit

class CorrectAnswerCell: UITableViewCell {

    var question: String = "" {
        didSet {
            questionLabel.text = question
        }
    }

    var answer: String = "" {
        didSet {
            answerLabel.text = answer
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        answerLabel.textColor = .green

        let stackView = UIStackView(arrangedSubviews: [questionLabel, answerLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var questionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    lazy var answerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
}
