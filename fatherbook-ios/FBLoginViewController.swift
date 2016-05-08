//
//  FBLoginViewController.swift
//  fatherbook-ios
//
//  Created by 张逸 on 16/5/8.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit
import SnapKit
import MZPushModalView
import MBProgressHUD
import UIColor_Hex_Swift

private let inputAreaEdgeOffset: CGFloat = 20.0
private let inputAreaHeight: CGFloat = 80.0
private let accountPlaceholder = "account"
private let passwordPlaceholder = "password"
private let loginButtonTitle = "login"
private let registerButtonTitle = "register for son of alien"

class FBLoginViewController: UIViewController {
    var logoView: UIImageView!
    var inputContainerView: UIView!
    var accountTextField: UITextField!
    var passwordTextField: UITextField!
    var loginIndicator: UIActivityIndicatorView!
    var loginButton: UIButton!
    var registerButton: UIButton!
    var registerPushModalView: MZPushModalView!

    
    var registerView: UIView!
    var rAccountTextField: UITextField!
    var rPasswordTextField: UITextField!
    var cancelButton: UIButton!
    var submitButton: UIButton!

    // MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        initUI()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    // MARK: private
    private func initObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }

    private func initUI() {
        // init gradient background
        let backgroundLayer = CAGradientLayer()
        backgroundLayer.colors = [UIColor(rgba: "#BBC1CC").CGColor, UIColor(rgba: "#010B21").CGColor]
        backgroundLayer.frame = view.bounds
        view.layer.addSublayer(backgroundLayer)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        // init subviews
        logoView = UIImageView(image: UIImage(named: "white-logo")!)

        inputContainerView = UIView()
        inputContainerView.backgroundColor = UIColor.whiteColor()
        inputContainerView.layer.cornerRadius = 4.0
        let separateLine = UIBezierPath()
        separateLine.moveToPoint(CGPointMake(0, inputAreaHeight / 2))
        separateLine.addLineToPoint(CGPointMake(CGRectGetWidth(view.bounds) - 2 * inputAreaEdgeOffset, inputAreaHeight / 2))
        let lineLayer = CAShapeLayer()
        lineLayer.path = separateLine.CGPath
        lineLayer.frame = CGRectMake(0, 0, CGRectGetWidth(view.bounds) - 2 * inputAreaEdgeOffset, inputAreaHeight)
        lineLayer.strokeColor = UIColor.grayColor().CGColor
        lineLayer.lineWidth = 0.3
        lineLayer.lineCap = kCALineCapRound
        inputContainerView.layer.addSublayer(lineLayer)

        accountTextField = UITextField()
        accountTextField.keyboardType = .ASCIICapable
        accountTextField.font = UIFont.systemFontOfSize(14)
        accountTextField.placeholder = accountPlaceholder

        passwordTextField = UITextField()
        passwordTextField.secureTextEntry = true
        passwordTextField.font = UIFont.systemFontOfSize(14)
        passwordTextField.placeholder = passwordPlaceholder

        loginButton = UIButton(type: .System)
        loginButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        loginButton.addTarget(self, action: #selector(login), forControlEvents: .TouchUpInside)
        loginButton.layer.cornerRadius = 4.0
        loginButton.setTitle(loginButtonTitle, forState: .Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.backgroundColor = UIColor(rgba: "#B8B0B029")
        loginIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)

        registerButton = UIButton(type: .System)
        registerButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        registerButton.addTarget(self, action: #selector(registerButtonPressed), forControlEvents: .TouchUpInside)
        registerButton.setTitle(registerButtonTitle, forState: .Normal)
        registerButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)


        view.addSubview(inputContainerView)
        view.addSubview(loginIndicator)
        inputContainerView.addSubview(accountTextField)
        inputContainerView.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        setupConstraints()
    }

    private func setupConstraints() {
        let logoContainer = UIView()
        view.addSubview(logoContainer)
        logoContainer.addSubview(logoView)
        logoContainer.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.bottom.equalTo(inputContainerView.snp_top)
        }

        logoView.snp_makeConstraints { (make) in
            make.center.equalTo(logoContainer)
            make.width.equalTo(view).multipliedBy(0.128)
            make.height.equalTo(logoView.snp_width)
        }

        inputContainerView.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(inputAreaEdgeOffset)
            make.right.equalTo(view).offset(-inputAreaEdgeOffset)
            make.centerY.equalTo(view)
            make.height.equalTo(inputAreaHeight)
        }

        accountTextField.snp_makeConstraints { (make) in
            make.left.equalTo(inputContainerView).offset(5.0)
            make.right.equalTo(inputContainerView).offset(-5.0)
            make.top.equalTo(inputContainerView)
            make.height.equalTo(inputContainerView).multipliedBy(0.5)
        }

        passwordTextField.snp_makeConstraints { (make) in
            make.left.right.height.equalTo(accountTextField)
            make.bottom.equalTo(inputContainerView.snp_bottom)
        }

        loginButton.snp_makeConstraints { (make) in
            make.left.right.equalTo(inputContainerView)
            make.top.equalTo(inputContainerView.snp_bottom).offset(5.0)
            make.height.equalTo(inputAreaHeight / 2)
        }

        loginIndicator.snp_makeConstraints { (make) in
            make.centerY.height.equalTo(loginButton)
            make.right.equalTo(loginButton).offset(-10)
            make.width.equalTo(loginIndicator.snp_height)
        }

        registerButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-10)
            make.centerX.equalTo(view)
        }
    }

    private func initRegisterView() {
        if registerView != nil {
            return
        }
        registerView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds) / 2))
        let backgroundLayer = CAGradientLayer()
        backgroundLayer.colors = [UIColor(rgba: "#BBC1CC").CGColor, UIColor(rgba: "#010B21").CGColor]
        backgroundLayer.frame = view.bounds
        registerView.layer.addSublayer(backgroundLayer)
        registerView.frame = CGRectMake(0, view.center.y, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds))


        let buttonWidth = CGRectGetWidth(view.bounds) / 7
        //dismiss button
        let crossPath = UIBezierPath()
        crossPath.moveToPoint(CGPointZero)
        crossPath.addLineToPoint(CGPointMake(buttonWidth, buttonWidth))
        crossPath.moveToPoint(CGPointMake(0, buttonWidth))
        crossPath.addLineToPoint(CGPointMake(buttonWidth, 0))
        let crossLayer = CAShapeLayer()
        crossLayer.opacity = 0.5
        crossLayer.frame = CGRectMake(0, 0, buttonWidth, buttonWidth)
        crossLayer.path = crossPath.CGPath
        crossLayer.lineCap = kCALineCapRound
        crossLayer.strokeColor = UIColor.redColor().CGColor
        crossLayer.fillColor = nil
        crossLayer.lineWidth = buttonWidth / 3
        cancelButton = UIButton(type: .System)
        cancelButton.layer.addSublayer(crossLayer)
        cancelButton.addTarget(self, action: #selector(cancelRegister), forControlEvents: .TouchUpInside)
        registerView.addSubview(cancelButton)
        cancelButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(registerView).offset(-buttonWidth / 2)
            make.centerX.equalTo(registerView).offset(-buttonWidth * 1.5)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(cancelButton.snp_width)
        }
        //submit button
        let tickPath = UIBezierPath()
        tickPath.moveToPoint(CGPointMake(0, buttonWidth / 2))
        tickPath.addLineToPoint(CGPointMake(buttonWidth / 3, buttonWidth))
        tickPath.moveToPoint(CGPointMake(buttonWidth / 3, buttonWidth))
        tickPath.addLineToPoint(CGPointMake(buttonWidth * 1.3, 0))
        let tickLayer = CAShapeLayer()
        tickLayer.opacity = 0.5
        tickLayer.frame = CGRectMake(0, 0, buttonWidth, buttonWidth)
        tickLayer.path = tickPath.CGPath
        tickLayer.lineCap = kCALineCapRound
        tickLayer.strokeColor = UIColor.whiteColor().CGColor
        tickLayer.fillColor = nil
        tickLayer.lineWidth = buttonWidth / 3
        submitButton = UIButton(type: .System)
        submitButton.layer.addSublayer(tickLayer)
        submitButton.addTarget(self, action: #selector(submitRegister), forControlEvents: .TouchUpInside)
        registerView.addSubview(submitButton)
        submitButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(registerView).offset(-buttonWidth / 2)
            make.centerX.equalTo(registerView).offset(buttonWidth * 1.5)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(cancelButton.snp_width)
        }
    }

    private func registerParameters() -> [String : AnyObject]? {
        if registerView == nil {
            return nil
        } else {
            return [
                kAccount: "monzy",
                kPassword: "123456"
            ]
        }
    }

    private func loginParameters() -> [String: AnyObject]? {
        return [
            kAccount: accountTextField.text!,
            kPassword: passwordTextField.text!
        ]
    }

    // MARK: actions
    func endEditing() {
        view.endEditing(true)
    }

    func login(sender: UIButton) {
        loginIndicator.startAnimating()
        endEditing()
        sender.enabled = false
        FBApi.post(withURL: kFBApiLogin, parameters: loginParameters(), success: { (json) -> (Void) in
            print("login json: \(json)")
            self.loginIndicator.stopAnimating()
            sender.enabled = true
            }) { (error) -> (Void) in
                print("login error: \(error)")
                sender.enabled = true
                self.loginIndicator.stopAnimating()
        }
    }

    func registerButtonPressed(sender: UIButton) {
        endEditing()
        initRegisterView()
        registerPushModalView = MZPushModalView.showModalView(registerView, rootView: nil)
    }

    func submitRegister(sender: UIButton) {
        FBApi.post(withURL: kFBApiRegister, parameters: registerParameters(), success: { (json) -> (Void) in
            print("register json: \(json)")
            }) { (error) -> (Void) in
                print("register error: \(error)")
        }
    }

    func cancelRegister(sender: UIButton) {
        registerPushModalView?.dismissModal()
    }

    // MARK: keyboard observers
    func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().height ?? 0.0
        UIView.animateWithDuration(0.25) {
            self.inputContainerView.snp_remakeConstraints(closure: { (make) in
                make.left.equalTo(self.view).offset(inputAreaEdgeOffset)
                make.right.equalTo(self.view).offset(-inputAreaEdgeOffset)
                make.centerY.equalTo(self.view).offset(-keyboardHeight / 2)
                make.height.equalTo(inputAreaHeight)
            })
            self.registerButton.snp_remakeConstraints(closure: { (make) in
                make.bottom.equalTo(self.view).offset(-(10 + keyboardHeight))
                make.centerX.equalTo(self.view)
            })
            self.view.layoutIfNeeded()
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.25) {
            self.inputContainerView.snp_remakeConstraints(closure: { (make) in
                make.left.equalTo(self.view).offset(inputAreaEdgeOffset)
                make.right.equalTo(self.view).offset(-inputAreaEdgeOffset)
                make.centerY.equalTo(self.view)
                make.height.equalTo(inputAreaHeight)
            })
            self.registerButton.snp_remakeConstraints(closure: { (make) in
                make.bottom.equalTo(self.view).offset(-10)
                make.centerX.equalTo(self.view)
            })
            self.view.layoutIfNeeded()
        }
    }
}
