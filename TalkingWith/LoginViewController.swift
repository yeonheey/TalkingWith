//
//  LoginViewController.swift
//  TalkingWith
//
//  Created by 정연희 on 2021/06/28.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    //https://github.com/raulriera/TextFieldEffects 사용
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    
    let remoteConfig = RemoteConfig.remoteConfig()
    var color: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let statusBar = UIView()
        self.view.addSubview(statusBar)

        statusBar.snp.makeConstraints { (make) in
            make.right.top.left.equalTo(self.view)
            make.height.equalTo(20)
        }
        
        color = remoteConfig["splash_background"].stringValue
        
        statusBar.backgroundColor = UIColor(hex: color)
        loginButton.backgroundColor = UIColor(hex: color)
        SignUpButton.backgroundColor = UIColor(hex: color)
        
        SignUpButton.addTarget(self, action: #selector(presentSignUp), for: .touchUpInside)
    }
    
    @objc func presentSignUp() {
        let view = self.storyboard?.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        
        self.present(view, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
