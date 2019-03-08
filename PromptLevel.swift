//
//  PromptLevel.swift
//  Pods-prompt_Example
//
//  Created by BENSALA on 08/03/2019.
//

import Foundation
import UIKit

protocol PromptLevelProtocol {
    var color: UIColor { get }
    var textColor: UIColor { get }
    var statusBarStyle: UIStatusBarStyle { get }
}

public enum PromptLevel: Int, PromptLevelProtocol {
    case success
    case info
    case warning
    case error
}

extension PromptLevel {
    public var color: UIColor {
        switch self {
        case .success:
            return .green
        case .info:
            return .blue
        case .error:
            return .red
        case .warning:
            return .orange
        }
    }
    
    public var textColor: UIColor {
        switch self {
        default:
            return .white
        }
    }
    
    public var statusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
