//
//  SignUpVC.swift
//  NewsFeed
//
//  Created by Vedant Mahant on 26/06/18.
//  Copyright © 2018 Vedant Mahant. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var tblGender: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let btnToggleViewPassword = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
        btnToggleViewPassword.setBackgroundImage(#imageLiteral(resourceName: "view"), for: .normal)
        btnToggleViewPassword.addTarget(self, action: #selector(self.toggleViewPasswordAction), for: .touchUpInside)
        txtPassword.rightView = btnToggleViewPassword
        txtPassword.rightViewMode = .always
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnRegisterAction(_ sender: UIButton) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "NewsFeedsListingVC") as! NewsFeedsListingVC
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    @objc
    func toggleViewPasswordAction(_ sender: UIButton) {
        if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "view") {
            txtPassword.isSecureTextEntry = false
            sender.setBackgroundImage(#imageLiteral(resourceName: "hide"), for: .normal)
        } else {
            txtPassword.isSecureTextEntry = true
            sender.setBackgroundImage(#imageLiteral(resourceName: "view"), for: .normal)
        }
    }
    
}

extension SignUpVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genderCell", for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        if indexPath.row == 0 {
            cell.textLabel?.text = "Male"
        } else {
            cell.textLabel?.text = "Female"
        }
        return cell
    }
    
    
}
