//
//  EmptyStateView.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 05/05/2026.
//

import UIKit

class EmptyStateView: UIView {
    
    private let messageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLabel()
    }
    
    private func setupView() {
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
        isHidden = true
    }
    
    private func setupLabel() {
        messageLabel.textAlignment = .center
        messageLabel.textColor = .secondaryLabel
        messageLabel.font = .systemFont(ofSize: 16, weight: .medium)
        messageLabel.numberOfLines = 0
    }
    
    func show(message: String = "No Data Available") {
        messageLabel.text = message
        isHidden = false
    }
    
    func hide() {
        isHidden = true
    }
}
