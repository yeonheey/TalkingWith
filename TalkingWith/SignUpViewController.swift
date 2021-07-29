//
//  SignUpViewController.swift
//  TalkingWith
//
//  Created by 정연희 on 2021/06/28.
//

import UIKit
import TextFieldEffects
import Firebase

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Properties
    let remoteConfig = RemoteConfig.remoteConfig()
    var color: String?

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()

        let statusBar = UIView()
        self.view.addSubview(statusBar)

        statusBar.snp.makeConstraints { (make) in
            make.right.top.left.equalTo(self.view)
            make.height.equalTo(20)
        }
        
        color = remoteConfig["splash_background"].stringValue
        
        statusBar.backgroundColor = UIColor(hex: color!)
        
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
        
        cancelButton.backgroundColor = UIColor(hex: color!)
        signUpButton.backgroundColor = UIColor(hex: color!)
        
        signUpButton.addTarget(self, action: #selector(signUpEvent), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: -Custom Method
    @objc func imagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func signUpEvent() {
        guard let email = emailTextField.text else{ return }
        guard let password = passwordTextField.text else{ return }
        
        //회원가입 인증 -> 유저 생성
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                print("No authResult")
                print(error!.localizedDescription)
                return
            }
            
            // 이미지 등록
            let image = self.imageView.image?.jpegData(compressionQuality: 0.1)
            // 이미지를 저장할 경로
            let imageReference = Storage.storage().reference().child("userImages").child("\(user.uid).jpg")
            
            imageReference.putData(image!, metadata: nil, completion: { (storageMetaData, error) in
                
                imageReference.downloadURL(completion: { (url, error) in
                    
                    var userModel = UserModel()
                    userModel.userName = self.nameTextField.text
                    userModel.profileImageUrl = url?.absoluteString
                    userModel.uid = Auth.auth().currentUser?.uid
                    
                    // database에 사용자 정보 입력
                    Database.database().reference().child("users").child(user.uid).setValue(userModel.toJSON) { err, reference in
                        if err == nil {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    
                })
            })
            
            let values = ["name": self.nameTextField.text!]
            Database.database().reference().child("users").child(user.uid).setValue(values) { error, reference in
                if error == nil {
                    self.cancelEvent()
                }
            }
            print("\(user.email!) created")
        }
    }
    
    @objc func cancelEvent() {
        self.dismiss(animated: true, completion: nil)
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
