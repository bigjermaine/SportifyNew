//
//  SettingsViewController.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    private var sections = [Section]()
    
    private let tableViews: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier:"cell")
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureModel()
        title = "Settings"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableViews)
        tableViews.delegate = self
        tableViews.dataSource = self
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViews.frame = view.bounds
        
        
    }
    private func  configureModel() {
        sections = [ Section(title: "Profile", options: [Option(title: "view Your profile", handler: {
            DispatchQueue.main.async { [weak self ] in
                self?.viewProfile()
            }
        })]),
        Section(title: "Account", options: [Option(title: "Sign Out", handler: {
                         DispatchQueue.main.async { [weak self ] in
                             self?.signOut()
                             
                         }})])
        
        
        ]
        
    }
    
    
    private func viewProfile() {
        let vc = ProfileViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Profile"
        navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    private func signOut() {
        let alert = UIAlertController(title: "SignOut", message: "Are you sure", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style:.cancel ))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .default,handler: { _ in
            AuthManager.shared.signOut { [weak self]    signout in
                if signout {
                  
                    let navC = UINavigationController(rootViewController: WelcomeViewController())
                    navC.navigationBar.prefersLargeTitles = true
                    navC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                    navC.modalPresentationStyle = .fullScreen
                    self?.present(  navC, animated: true , completion: {
                        self?.navigationController?.popToRootViewController(animated: true)
                    })
                }
            }
        }))
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].options.count
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model =   sections[indexPath.section].options[indexPath.row]
        let cell = tableViews.dequeueReusableCell(withIdentifier:"cell", for: indexPath)
       
        
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model =   sections[indexPath.section].options[indexPath.row]
        model.handler()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     let model = sections[section]
      return  model.title
    }
}
