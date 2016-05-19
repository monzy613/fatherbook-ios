//
//  FBLoginViewController.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 16/5/8.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit
import SnapKit
import MZPushModalView
import MBProgressHUD
import UIColor_Hex_Swift
import MZGoogleStyleButton
import FXBlurView

private let inputAreaEdgeOffset: CGFloat = 20.0
private let textFieldOffset: CGFloat = 10.0
private let inputAreaHeight: CGFloat = 80.0
private let accountPlaceholder = "account"
private let passwordPlaceholder = "password"
private let confirmPasswordPlaceholder = "confirm password"
private let loginButtonTitle = "login"
private let registerButtonTitle = "register for son of alien"
private let textFieldHeight: CGFloat = 40.0

class FBLoginViewController: UIViewController, UITextFieldDelegate {
    var logoView: UIImageView!
    var inputContainerView: UIView!
    var accountTextField: UITextField!
    var passwordTextField: UITextField!
    var loginIndicator: UIActivityIndicatorView!
    var loginButton: MZGoogleStyleButton!
    var registerButton: UIButton!
    var registerPushModalView: MZPushModalView!
    
    var registerView: UIView!
    var registering = false
    var rInputContainerView: UIView!
    var rAccountTextField: UITextField!
    var rPasswordTextField: UITextField!
    var rPasswordConfirmTextField: UITextField!
    var cancelButton: UIButton!
    var submitButton: MZGoogleStyleButton!

    // MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        initUI()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: preferredStatusBarStyle
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case accountTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            login(loginButton)
        case rAccountTextField:
            rPasswordTextField.becomeFirstResponder()
        case rPasswordTextField:
            rPasswordConfirmTextField.becomeFirstResponder()
        case rPasswordConfirmTextField:
            submitRegister(submitButton)
        default:
            print("textfirldShoudReturn error in default")
            break
        }
        return true
    }

    // MARK: private
    private func initObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textFieldDidChange), name: UITextFieldTextDidChangeNotification, object: nil)
    }

    private func initUI() {
        // init background
        view.backgroundColor = UIColor.fb_darkColor()
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

        accountTextField = FBViewGenerator.fbTextField(placeHolder: accountPlaceholder)
        accountTextField.delegate = self
        accountTextField.keyboardType = .ASCIICapable

        passwordTextField = FBViewGenerator.fbTextField(placeHolder: passwordPlaceholder, secureTextEntry: true)
        passwordTextField.delegate = self

        loginButton = MZGoogleStyleButton(type: .System)
        loginButton.titleLabel?.font = UIFont.fb_defaultFontOfSize(14)
        loginButton.addTarget(self, action: #selector(login), forControlEvents: .TouchUpInside)
        loginButton.layer.cornerRadius = 4.0
        loginButton.setTitle(loginButtonTitle, forState: .Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.backgroundColor = UIColor(rgba: "#B8B0B029")
        loginIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)

        registerButton = UIButton(type: .System)
        registerButton.titleLabel?.font = UIFont.fb_defaultFontOfSize(14)
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
            make.left.equalTo(inputContainerView).offset(textFieldOffset)
            make.right.equalTo(inputContainerView).offset(-textFieldOffset)
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
        registerView.backgroundColor = UIColor.fb_darkColor()
        registerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endRegisterEditing)))
        registerView.frame = CGRectMake(0, view.center.y, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds))

        //rAccountTextField & rPasswordTextField & rPasswordConfirmTextField
        rInputContainerView = UIView()
        rInputContainerView.backgroundColor = UIColor.whiteColor()
        rInputContainerView.layer.cornerRadius = 4.0
        let separateLine = UIBezierPath()
        separateLine.moveToPoint(CGPointMake(0, textFieldHeight))
        separateLine.addLineToPoint(CGPointMake(CGRectGetWidth(registerView.bounds) - 2 * inputAreaEdgeOffset, textFieldHeight))
        separateLine.moveToPoint(CGPointMake(0, textFieldHeight * 2))
        separateLine.addLineToPoint(CGPointMake(CGRectGetWidth(registerView.bounds) - 2 * inputAreaEdgeOffset, textFieldHeight * 2))
        let lineLayer = CAShapeLayer()
        lineLayer.path = separateLine.CGPath
        lineLayer.frame = CGRectMake(0, 0, CGRectGetWidth(registerView.bounds) - 2 * inputAreaEdgeOffset, textFieldHeight * 3)
        lineLayer.strokeColor = UIColor.grayColor().CGColor
        lineLayer.lineWidth = 0.3
        lineLayer.lineCap = kCALineCapRound
        rInputContainerView.layer.addSublayer(lineLayer)

        rAccountTextField = FBViewGenerator.fbTextField(placeHolder: accountPlaceholder)
        rAccountTextField.delegate = self
        rAccountTextField.keyboardType = .ASCIICapable
        rPasswordTextField = FBViewGenerator.fbTextField(placeHolder: passwordPlaceholder, secureTextEntry: true)
        rPasswordTextField.delegate = self
        rPasswordConfirmTextField = FBViewGenerator.fbTextField(placeHolder: confirmPasswordPlaceholder, secureTextEntry: true)
        rPasswordConfirmTextField.delegate = self

        rInputContainerView.addSubview(rAccountTextField)
        rInputContainerView.addSubview(rPasswordTextField)
        rInputContainerView.addSubview(rPasswordConfirmTextField)
        registerView.addSubview(rInputContainerView)

        //dismiss button
        cancelButton = UIButton(type: .System)
        cancelButton.setTitle("cancel", forState: .Normal)
        cancelButton.addTarget(self, action: #selector(cancelRegister), forControlEvents: .TouchUpInside)
        cancelButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        cancelButton.titleLabel?.font = UIFont.fb_defaultFontOfSize(14)
        registerView.addSubview(cancelButton)
        //submit button
        submitButton = MZGoogleStyleButton(type: .System)
        submitButton.addTarget(self, action: #selector(submitRegister), forControlEvents: .TouchUpInside)
        submitButton.setTitle("register", forState: .Normal)
        submitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        submitButton.titleLabel?.font = UIFont.fb_defaultFontOfSize(14)
        submitButton.layer.cornerRadius = 4.0
        submitButton.backgroundColor = UIColor(rgba: "#B8B0B029")
        registerView.addSubview(submitButton)


        //register view constraints
        rInputContainerView.snp_makeConstraints { (make) in
            make.left.equalTo(registerView).offset(inputAreaEdgeOffset)
            make.right.equalTo(registerView).offset(-inputAreaEdgeOffset)
            make.centerY.equalTo(registerView)
            make.height.equalTo(textFieldHeight * 3)
        }
        rAccountTextField.snp_makeConstraints { (make) in
            make.top.equalTo(rInputContainerView)
            make.height.equalTo(textFieldHeight)
            make.left.equalTo(rInputContainerView).offset(textFieldOffset)
            make.right.equalTo(rInputContainerView).offset(-textFieldOffset)
        }
        rPasswordTextField.snp_makeConstraints { (make) in
            make.top.equalTo(rAccountTextField.snp_bottom)
            make.left.right.height.equalTo(rAccountTextField)
        }
        rPasswordConfirmTextField.snp_makeConstraints { (make) in
            make.top.equalTo(rPasswordTextField.snp_bottom)
            make.left.right.height.equalTo(rAccountTextField)
        }

        cancelButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(registerView).offset(-10)
            make.centerX.equalTo(registerView)
        }
        submitButton.snp_makeConstraints { (make) in
            make.left.right.equalTo(rInputContainerView)
            make.height.equalTo(textFieldHeight)
            make.bottom.equalTo(cancelButton.snp_top).offset(-10)
        }
    }

    private func registerParameters() -> [String : AnyObject]? {
        if registerView == nil {
            return nil
        } else {
            return [
                kAccount: rAccountTextField.text!,
                kPassword: rPasswordTextField.text!
            ]
        }
    }

    private func loginParameters() -> [String: AnyObject]? {
        return [
            kAccount: accountTextField.text!,
            kPassword: passwordTextField.text!
        ]
    }

    private func checkLogin() -> Bool {
        if var account = accountTextField.text, var password = passwordTextField.text {
            account = account.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            password = password.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if account == "" || password == "" {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }

    // MARK: actions
    func textFieldDidChange(textField: UITextField) {
    }

    func endEditing() {
        view.endEditing(true)
    }

    func endRegisterEditing() {
        registerView.endEditing(true)
    }

    func login(sender: UIButton) {
        if !checkLogin() {
            MBProgressHUD.showErrorToView("Please enter account and password", rootView: view)
            return
        }
        endEditing()
        loginIndicator.startAnimating()
        sender.enabled = false
        FBApi.post(withURL: kFBApiLogin, parameters: loginParameters(), success: { (json) -> (Void) in
            print("login json: \(json)")
            self.loginIndicator.stopAnimating()
            sender.enabled = true
            if let status = json["status"].string {
                print(json["userInfo"])
                let outputInfo = FBApi.statusDescription(status).0
                let isSuccess = FBApi.statusDescription(status).1
                if isSuccess {
                    let userInfoJSON = json[kUserInfo]
                    let user = FBUserInfo(json: userInfoJSON)
                    FBPersist.set(value: userInfoJSON.object, forKey: .UserInfo)
                    FBUserManager.sharedManager().user = user
                    MBProgressHUD.showSuccessToView(outputInfo, rootView: self.view)
                    self.loginSuccess()
                } else {
                    MBProgressHUD.showErrorToView(outputInfo, rootView: self.view)
                }
            } else {
                MBProgressHUD.showErrorToView(FBApi.statusDescription("000").0, rootView: self.view)
            }
            }) { (error) -> (Void) in
                MBProgressHUD.showErrorToView(FBApi.statusDescription("000").0, rootView: self.view)
                print("login error: \(error)")
                sender.enabled = true
                self.loginIndicator.stopAnimating()
        }
    }

    func registerButtonPressed(sender: UIButton) {
        registering = true
        endEditing()
        initRegisterView()
        registerPushModalView = MZPushModalView.showModalView(registerView, rootView: nil)
    }

    func submitRegister(sender: UIButton) {
        let parameters = registerParameters()
        FBApi.post(withURL: kFBApiRegister, parameters: parameters, success: { (json) -> (Void) in
            print("register json: \(json)")
            if let status = json["status"].string {
                let outputInfo = FBApi.statusDescription(status).0
                let isSuccess = FBApi.statusDescription(status).1
                if isSuccess {
                    self.cancelRegister(self.cancelButton)
                    MBProgressHUD.showSuccessToView(outputInfo, rootView: self.view)
                    self.accountTextField.text = parameters![kAccount] as? String
                    self.passwordTextField.text = parameters![kPassword] as? String
                    self.login(self.loginButton)
                } else {
                    MBProgressHUD.showErrorToView(outputInfo, rootView: self.view)
                }
            }
            }) { (error) -> (Void) in
                print("register error: \(error)")
        }
    }

    func cancelRegister(sender: UIButton) {
        endRegisterEditing()
        registering = false
        registerPushModalView?.dismissModal()
    }

    // MARK: keyboard observers
    func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().height ?? 0.0
        if registering {
            UIView.animateWithDuration(0.25) {
                self.rInputContainerView.snp_remakeConstraints(closure: { (make) in
                    make.left.equalTo(self.registerView).offset(inputAreaEdgeOffset)
                    make.right.equalTo(self.registerView).offset(-inputAreaEdgeOffset)
                    make.centerY.equalTo(self.registerView).offset(-keyboardHeight / 2)
                    make.height.equalTo(textFieldHeight * 3)
                })
                self.cancelButton.snp_remakeConstraints { (make) in
                    make.bottom.equalTo(self.registerView).offset(-(10 + keyboardHeight))
                    make.centerX.equalTo(self.registerView)
                }
                self.registerView.layoutIfNeeded()
            }
        } else {
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
    }

    func keyboardWillHide(notification: NSNotification) {
        if registering {
            UIView.animateWithDuration(0.25) {
                self.rInputContainerView.snp_remakeConstraints(closure: { (make) in
                    make.left.equalTo(self.registerView).offset(inputAreaEdgeOffset)
                    make.right.equalTo(self.registerView).offset(-inputAreaEdgeOffset)
                    make.centerY.equalTo(self.registerView)
                    make.height.equalTo(textFieldHeight * 3)
                })
                self.cancelButton.snp_remakeConstraints { (make) in
                    make.bottom.equalTo(self.registerView).offset(-10)
                    make.centerX.equalTo(self.registerView)
                }
                self.registerView.layoutIfNeeded()
            }
        } else {
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

    func loginSuccess() {
        let navigationController = UINavigationController(rootViewController: FBRootViewController())
        presentViewController(navigationController, animated: true, completion: nil)
        FBApi.post(withURL: kFBRCToken, parameters: [kAccount: FBUserManager.sharedManager().user.account ?? ""], success: { (json) -> (Void) in
            if let token = json["rcToken"].string {
                FBRCChatManager.sharedManager().rcToken = token
                FBRCChatManager.initRC()
            }
            }) { (err) -> (Void) in
        }
    }
}
