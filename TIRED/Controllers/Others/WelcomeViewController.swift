//
//  WelcomeViewController.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import UIKit


class WelcomeViewController: UIViewController {

    private let signInButton:UIButton = {
        let button =  UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In With Sportify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
     
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Spotify"
        let backgroundImage = UIImage(named: "jet")
             let backgroundImageView = UIImageView(image: backgroundImage)
             backgroundImageView.contentMode = .scaleAspectFill
             backgroundImageView.frame = view.bounds
             backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
              view.addSubview(backgroundImageView)
              view.sendSubviewToBack(backgroundImageView)
              view.addSubview(signInButton)
           signInButton.addTarget(self, action: #selector(didTapDSignin), for: .touchUpInside)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        signInButton.frame = CGRect(x: 20, y: view.height-50-view.safeAreaInsets.bottom, width: view.width-40, height: 50)
    }
    
    
    @objc func didTapDSignin() {
        let vc = AuthViewController()
        vc.completionHandler = {[weak self] sucess in
            self?.handleSignin(sucess:sucess)
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
   private func handleSignin(sucess:Bool){
       guard sucess else {
           let alert = UIAlertController(title: "oops", message: "something went wrong when signing in", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Dimiss", style: .cancel))
           present(alert, animated: true)
           return}
        let mainAppTabVC = TabbarController()
       mainAppTabVC.modalPresentationStyle = .fullScreen
       present(mainAppTabVC, animated: true)
    }
}
