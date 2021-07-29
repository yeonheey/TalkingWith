//
//  PeopleViewController.swift
//  TalkingWith
//
//  Created by 정연희 on 2021/07/11.
//

import UIKit
import SDWebImage
import SnapKit
import Firebase

class PeopleViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    var array: [UserModel] = []
    var myUid: String?
    
    //MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myUid = Auth.auth().currentUser?.uid
        loadPeopleView()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20)
            make.bottom.left.right.equalTo(view)
        }
        
    }
    
    // MARK: - Custom Methods
    func loadPeopleView() {
        Database.database().reference().child("users").observe(DataEventType.value) { (snapshot) in
            
            self.array.removeAll() // 중복제거
            
            let myUid = Auth.auth().currentUser?.uid
            
            for child in snapshot.children {
                let fchild = child as! DataSnapshot
                let dic = fchild.value as! [String: Any]
                let userModel = UserModel(JSON: dic)
                
                if userModel?.uid == myUid {
                    continue
                }
                self.array.append(userModel!)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - Extension

extension PeopleViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        let item = self.array[indexPath.row]
        
        let imageView = UIImageView()
        
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(cell)
            make.left.equalTo(cell)
            make.height.width.equalTo(50)
        }
        
        if item.profileImageUrl != nil {
            imageView.sd_setImage(with: URL(string: item.profileImageUrl!), completed: nil)
        }
        
        let label = UILabel()
        cell.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(cell)
            make.left.equalTo(imageView.snp.right).offset(30)
        }
        label.text = item.userName
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
