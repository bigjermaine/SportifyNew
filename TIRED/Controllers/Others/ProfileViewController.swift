//
//  ProfileViewController.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import UIKit


import UIKit
import SDWebImage
class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  

    private var models = [String]()
    
    private let tableViews: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier:"cell")
        return table
    }()
    
 
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        view.backgroundColor = .brown
        super.viewDidLoad()
        view.addSubview(tableViews)
        tableViews.dataSource = self
        tableViews.delegate = self
         title = "Profile"
        APICaller.shared.getCurrentUserProfile {[weak self]Result in
            switch Result {
            case.success(let model):
                print(model)
                self?.update(with:model)
            case.failure(let error):
                self?.failedToGetProfile()
                print(error.localizedDescription)
            }
        }
      
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViews.frame = view.frame
       
    }

    
    
    private func update(with model:UserProfile) {
        DispatchQueue.main.async {
            self.tableViews.isHidden = false
        }
        models.append("Full Name:\(model.display_name)")
        models.append("Email Address:\(model.email)")
        models.append("User ID:\(model.id)")
        models.append("Plan:\(model.product)")
        DispatchQueue.main.async {
            self.tableViews.reloadData()
        }
        
    }
    
    private func failedToGetProfile() {
       
        let label = UILabel(frame:.zero)
        label.text = "Failed to Load Profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
        tableViews.reloadData()
        
    }
    
    private func createTableHeader(with string: String?) {
        guard let urlString = string, let url = URL(string: urlString) else {return}
        let headerview = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/15))
        let imageSize:CGFloat = headerview.height/2
        let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerview.addSubview(imageView)
        imageView.center = headerview.center
        imageView.sd_setImage(with: url)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableViews.dequeueReusableCell(withIdentifier:"cell", for: indexPath)
       
        
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
}
