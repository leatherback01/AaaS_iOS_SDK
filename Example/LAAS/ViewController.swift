//
//  ViewController.swift
//  LAAS
//
//  Created by Promise Ochornma on 03/03/2023.
//  Copyright (c) 2023 Promise Ochornma. All rights reserved.
//

import UIKit
import LAAS


class ViewController: UIViewController, LeatherBackDelegate {
    func onLeatherBackError(error: LeatherBackErrorResponse) {
        print("error \(error.localizedDescription)")
    }
    
    func onLeatherBackSuccess(response: LeatherBackResponse) {
        print("success \(response.reference)")
    }
    
    func onLeatherBackDimissal() {
        print("dismissed")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let payButton = UIButton()
        payButton.translatesAutoresizingMaskIntoConstraints = false
        payButton.setTitle("Pay (personal info flag false)", for: .normal)
        payButton.backgroundColor =  UIColor(red: 0/255, green: 62/255, blue: 255/255, alpha: 1)
        view.addSubview(payButton)
        payButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        payButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        payButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        payButton.widthAnchor.constraint(equalToConstant: (view.bounds.width - 20)).isActive = true
        payButton.addTarget(self, action: #selector(onPayTapped), for: .touchUpInside)
        
        let payButton2 = UIButton()
        payButton2.translatesAutoresizingMaskIntoConstraints = false
        payButton2.setTitle("Pay (personal info flag true)", for: .normal)
        payButton2.backgroundColor =  UIColor(red: 0/255, green: 62/255, blue: 255/255, alpha: 1)
        view.addSubview(payButton2)
        payButton2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        payButton2.topAnchor.constraint(equalTo: payButton.bottomAnchor, constant: 20).isActive = true
        payButton2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        payButton2.widthAnchor.constraint(equalToConstant: (view.bounds.width - 20)).isActive = true
        payButton2.addTarget(self, action: #selector(onPayTappedWithInfoNotSupplied), for: .touchUpInside)
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func onPayTapped(){
        //input your public key
        //pk_test_c654aa13bgh6g7649gb380140fb86gc70a3a2fe
        let reference = String(Int((Date().timeIntervalSince1970 * 1000.0).rounded()))
        let param = LeatherBackTransactionParam(amount: 1.50, currencyCode: .GBP, channels: [.Card, .Account], showPersonalInformation: false, reference: reference, customerEmail: "johndoe@leatherback.co", customerName: "John Doe", key: "input your public key", isProducEnv: false)
        
        let paymentVC = LeatherBackViewController(delegate: self, param: param)
        //self.navigationController?.pushViewController(paymentVC, animated: true)
        self.present(paymentVC, animated: false, completion: nil)
    }

    
    @objc func onPayTappedWithInfoNotSupplied(){
        //input your public key
       
        let reference = String(Int((Date().timeIntervalSince1970 * 1000.0).rounded()))
        let param = LeatherBackTransactionParam(amount: 30.00, currencyCode: .NGN, channels: [.Card, .Account], showPersonalInformation: true, reference: reference, key: "input your public key", isProducEnv: false)
        
        let paymentVC = LeatherBackViewController(delegate: self, param: param)
       // self.navigationController?.pushViewController(paymentVC, animated: true)
        self.present(paymentVC, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

