//
//  ViewController.swift
//  TalkingWith
//
//  Created by 정연희 on 2021/06/27.
//

import UIKit
import SnapKit
import Firebase

class ViewController: UIViewController {
    
    var box = UIImageView()
    var remoteConfig: RemoteConfig!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // RemoteConfig 초기화
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        //서버와 연결이 안될 경우 이 디폴드 값 사용
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activate()
            } else {
                print("Config not fetched")
                print("Error \(error!.localizedDescription)")
            }
            self.displayWelcome()
        }

        //이미지 업로드
        self.view.addSubview(box)
        box.snp.makeConstraints{ (make) in
            make.center.equalTo(self.view)
        }
    
        box.contentMode = .scaleAspectFit
        box.image = #imageLiteral(resourceName: "loading_icon")
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func displayWelcome() {
        let color = remoteConfig["splash_background"].stringValue
        let caps = remoteConfig["splash_message_caps"].boolValue
        let message = remoteConfig["splash_message"].stringValue
        
        if caps { //경고창 띄워주기
            let alert = UIAlertController(title: "공지사항", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in exit(0)
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            guard let loginViewController = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController else {
                print("no LoginViewController")
                return
            }
            
            self.present(loginViewController, animated: false, completion: nil)
        }
        self.view.backgroundColor = UIColor(hex: color!)
    }
}

//hex color (입력 용이)
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
