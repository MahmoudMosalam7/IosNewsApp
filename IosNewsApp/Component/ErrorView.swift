//
//  ErrorView.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 05/05/2026.
//

import UIKit

class ErrorView: UIView {
    
    private let errorLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    private let stack = UIStackView()
    
    var onRetry: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupErrorLabel()
        setupRetry()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupErrorLabel()
        setupRetry()
    }
    
    private func setupView() {
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.addArrangedSubview(errorLabel)
        stack.addArrangedSubview(retryButton)
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        isHidden = true
    }
    
    private func setupErrorLabel(){
        errorLabel.textAlignment = .center
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
    }
    
    private func setupRetry(){
        retryButton.setTitle("Retry", for: .normal)
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
    }
    
    @objc private func didTapRetry() {
        onRetry?()
    }
    
    func show(message: String) {
        errorLabel.text = message
        isHidden = false
    }
    
    func hide() {
        isHidden = true
    }
}
