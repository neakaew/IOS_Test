//
//  RegistersViewController.swift
//  Test_ios
//
//  Created udom on 20/6/2562 BE.
//  Copyright © 2562 udom Neakaew. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import SwiftyJSON
import Alamofire

class RegistersViewController: UIViewController, RegistersViewProtocol, UITextFieldDelegate {

	var presenter: RegistersPresenterProtocol?
    
    @IBOutlet var emailTextFiled: UITextField!
    @IBOutlet var checkBox: UIButton!
    @IBOutlet var viewEmail: UIView!
    @IBOutlet var viewCheckBox: UIView!
    @IBOutlet var confirmButton: UIButton!
    
    var selectDataTnc: Bool = false

	override func viewDidLoad() {
        super.viewDidLoad()
        setDismissKeyboard()
        setupTextfield()
        setUpView()
    }
    
    func setupTextfield() {
        emailTextFiled.delegate = self
        emailTextFiled.placeholder = "Please enter e-mail."
    }
    
    func setUpView() {
        setUpButton()
        viewEmail.setLayerView()
        viewCheckBox.setLayerView()
    }
    
    func setUpButton() {
//        confirmButton.isEnabled = true
        confirmButton.backgroundColor = .gray
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.titleLabel?.font = UIFont(name:"Courier New", size:15)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.layer.cornerRadius = 8
        confirmButton.layer.shadowRadius = 8
    }
    
    func setDismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func register(email: String, uuid: String, data: String, tnc: Bool) {
        if let  Url = URL(string: "https://staging.hellogold.com/api/v3/users/register.json") {
            Alamofire.request(Url,
                              method: .post,
                              parameters: [
                                "email": email,
                                "uuid": uuid,
                                "data": data,
                                "tnc": tnc
                ]).responseJSON { (response) in
                    switch response.result {
                    case .success(let value): // Success is clearText and Show Alert
                        print(value)
                        self.checkBox.isSelected = false
                        self.nextPage()
                        self.clearText()
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    func nextPage() {
        let myViewController = DashboardViewController(nibName: "DashboardViewController", bundle: nil)
        myViewController.textEmail = emailTextFiled.text ?? ""
        self.present(myViewController, animated: true, completion: nil)
    }
    
    @IBAction func clickCheckBox(_ sender: UIButton) {
        if sender.isSelected {
            selectDataTnc = false
            sender.isSelected = false
        } else {
            selectDataTnc = true
            sender.isSelected = true
        }
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        if emailTextFiled.text?.count == 0 {
            clearText()
            return alertData(title: "Empty", message: "Please enter e-mail.")
        }
        
        if selectDataTnc == false {
            return alertData(title: "CheckBox", message: "Please enter checkBox.")
        }
        
        if isValidEmail(testStr: emailTextFiled.text ?? "") == true {
            print("succress")
        } else {
            clearText()
            alertData(title: "E-mail incorrect", message: "Check format e-mail.")
            return
        }
        
        let selectData = randomData(length: 15)
        let selectUUID = NSUUID().uuidString
        register(email: emailTextFiled.text ?? "", uuid: selectUUID, data: selectData, tnc: selectDataTnc)
        
    }
    
    func alertData(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func clearText() {
        emailTextFiled.text = ""
    }
    
    func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func randomData(length: Int) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}

extension UIView {
    func setLayerView() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 6
    }
}
