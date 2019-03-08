//
//  StatusBarView.swift
//  FBSnapshotTestCase
//
//  Created by BENSALA on 06/03/2019.
//

import UIKit

public final class StatusBarView: UIView {
    
    public var message: String {
        didSet {
            self.messageLabel.text = message
        }
    }
    public var messageColor: UIColor = .black {
        didSet {
            self.messageLabel.textColor = messageColor
        }
    }
    
    private let messageLabel = UILabel(frame: .zero)
    private let font = UIFont.systemFont(ofSize: 13.0)
    
    public init(_ message: String) {
        self.message = message
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = self.message
        messageLabel.textColor = messageColor
        messageLabel.backgroundColor = .clear
        messageLabel.textAlignment = .center
        messageLabel.font = font
        
        self.addSubview(messageLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        self.configureView()
    }
    
    private func configureView() {
        messageLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
    }
}
