//
//  LibraryPlaylistViewController.swift
//  TIRED
//
//  Created by Apple on 17/05/2023.
//

import UIKit

class LibraryPlaylistViewController: UIViewController {
    public var selectionHandler:((Playlist) -> Void)?
    private let tableView:UITableView =  {
        let tableView = UITableView(frame: .zero, style: .grouped)
       
        tableView.isHidden = true
        return tableView
        
    }()
     var playlists = [Playlist]()
    private var noPlaylist = ActionLabelView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        view.addSubview(noPlaylist)
        view.addSubview(tableView)
        tableView.register(SearchResultTitleDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultTitleDefaultTableViewCell.identifier)
        
        tableView.register(SearchResultTitlesSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultTitlesSubtitleTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        noPlaylist.configure(with: ActionaLabelViewModel(text: "You dont have any playlists yet", actionTitle: "Create"))
        noPlaylist.delegate = self
        fetchData()
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,target:self,action:#selector( didTapClose))
        }
        
        }
    
    @objc func didTapClose() {
        dismiss(animated: true,completion: nil)
    }
   
    
    private func fetchData() {
        APICaller.shared.getCurrentUserPlaylist {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUi()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylist.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylist.center  = view.center
        tableView.frame = view.bounds
    }
    private func updateUi() {
        if  playlists.isEmpty {
            DispatchQueue.main.async {[weak self ] in 
                self?.noPlaylist.isHidden = false
                
            }
        }else {
            tableView.isHidden = false
            tableView.reloadData()
           
        }
    }
}

extension LibraryPlaylistViewController:ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        
        showCreatePlaylist()
    }
    
    func  showCreatePlaylist() {
        let alert = UIAlertController(title: "New Playlists", message: "Enter Playlist name", preferredStyle: .alert)
        
        
        alert.addTextField{ textfield in
            textfield.placeholder = "playlist....."
            
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default,handler: {_ in
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            APICaller.shared.createPlaylist(with: text) {[weak self ] sucess in
                DispatchQueue.main.async {
                    if sucess {
                        self?.fetchData()
                        
                    }else {
                        print("failed to create playlist")
                    }
                    
                }
            }
        }))
        
        present(alert, animated: true)
    }
}

extension LibraryPlaylistViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier:   SearchResultTitlesSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultTitlesSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let play = playlists[indexPath.row]
        
        let viewModel = SearchResultTitlesSubtitleViewModel(title: play.name, image: URL(string:  play.images.first?.url ?? ""), subTitle:  play.owner.display_name)
        cell.configure(with:  viewModel)
     return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let playslist = playlists[indexPath.row]
        guard selectionHandler == nil else {
            
            selectionHandler?(playslist)
            dismiss(animated: true)
            return
        }
        
        let vc = PlaylistViewController(playlist: playslist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
