/**
 Level for Prompt
 Success: to show success prompt
 Info: to show info or other prompt
 Warning: to show a warning prompt
 Error: to Show an error prompt
 */
import Foundation
import UIKit

private struct PromptSetting {
    static var kPromptDefaultTimeout = 5.0
    static var kPromptNoTimeout = 0.0
    static var currentPrompt: ContainerView?
    static var currentStatusBarStyle: UIStatusBarStyle = UIApplication.shared.statusBarStyle
}

protocol ViewLayout: class {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: ViewLayout {}
extension UILayoutGuide: ViewLayout { }

extension UIViewController {
    
    private var rootViewController: UIViewController? {
        return UIApplication.shared.windows.last?.rootViewController
    }
    
    private var childRootViewController: UIViewController? {
        return self.rootViewController?.childViewControllers.last
    }
    
    /**
     Display Prompt with timer
     
     - parameters: message String Message for prompt
     - parameters: level PromptLevel Level for prompt (Refert on PromptLevel Doc)
     - parameters: timeout NSTimeInterval Time to show prompt
     - parameters: action Completion to do action when user click on button information
     - parameters: ViewController to see prompt
     If action is empty the button will not show
     */
    public func displayPrompt(view: UIView, style: PromptStyle, timeout: TimeInterval, _ action:(() -> Void)? = nil) {
        
        if PromptSetting.currentPrompt != nil {
            hidePrompt(nil)
        }
        
        var widthBar: CGFloat = 0.0
        var heightBar: CGFloat = UIApplication.shared.statusBarFrame.height + 10.0
        
        let promptView: ContainerView = ContainerView()
        promptView.translatesAutoresizingMaskIntoConstraints = false
        promptView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        promptView.clipsToBounds = true
        
        let topView = UILayoutGuide()
        topView.heightAnchor.constraint(equalToConstant: heightBar).isActive = true
        
        addSubviews(in: promptView, subviews: [topView,view])
        
        promptView.backgroundColor = view.backgroundColor
        
        widthBar = self.view.frame.width
        heightBar += view.frame.height
        if widthBar == 0.0 { return }
        
        if style == .statusBar {
            promptView.heightAnchor.constraint(equalToConstant: heightBar).isActive = true
            promptView.widthAnchor.constraint(equalToConstant: widthBar).isActive = true
        }
        
        _ = {[unowned self] () -> Void in
            self.hidePrompt(nil)
            if action != nil {
                action?()
            }
        }
        
        promptView.frame.origin.y -= promptView.frame.size.height

        PromptSetting.currentPrompt = promptView
        
        self.view.insertSubview(promptView, aboveSubview: self.view)
        
        UIView.animate(withDuration: 0.3, animations: {
            //            ((UIApplication.shared.delegate?.window)!)?.windowLevel = (style == .statusBar) ? UIWindowLevelStatusBar+1 : UIWindowLevelNormal
            promptView.frame.origin.y += promptView.frame.size.height
        })
        
        if (timeout != PromptSetting.kPromptNoTimeout) {
            // Cancels perform requests previously registered with the performSelector:withObject:afterDelay: instance method.
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            perform(#selector(UIViewController.hidePrompt(_:)), with: nil, afterDelay: timeout)
        }
    }
    
    public func displayPrompt(_ message: String, level: PromptLevel, style: PromptStyle, timeout: TimeInterval, _ action:(() -> Void)?) {
        let statusView = StatusBarView(message)
        statusView.backgroundColor = level.color
        statusView.messageColor = level.textColor
        displayPrompt(view: statusView, style: style, timeout: timeout, action)
    }

    
    /**
     Hide prompt with gesture
     - Is configured on InterfaceBuilder
     */
    @IBAction
    public func hidePrompt(_ sender: AnyObject?) {
        
        let promptView = PromptSetting.currentPrompt
        PromptSetting.currentPrompt = nil
        
        if let promptView = promptView {
            UIView.animate(withDuration: 0.25, animations: {
                promptView.frame.origin.y = -promptView.frame.height
                //((UIApplication.shared.delegate?.window)!)?.windowLevel = UIWindowLevelNormal
            }, completion: { (_: Bool) in
                promptView.removeFromSuperview()
            })
        }
    }
    
    /**
     Test if prompt is displayed or not
     */
    public func isPromptShow() -> Bool {
        return PromptSetting.currentPrompt != nil
    }
    
    private func addSubviews(in view: UIView, subviews: [ViewLayout]) {
        
        for i in 0..<subviews.count {
            if let subview = subviews[i] as? UILayoutGuide {
                view.addLayoutGuide(subview)
            } else if let subview = subviews[i] as? UIView {
                view.addSubview(subview)
            } else {
                continue
            }
            
            if i == 0 {
                subviews[i].topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            } else {
                subviews[i].topAnchor.constraint(equalTo: subviews[i-1].bottomAnchor).isActive = true
            }
            
            subviews[i].leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            subviews[i].trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
            if i == (subviews.count - 1) {
                subviews[i].bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            } else if i != 0 {
                subviews[i].bottomAnchor.constraint(equalTo: subviews[i-1].bottomAnchor).isActive = true
            }
        }
    }
}
