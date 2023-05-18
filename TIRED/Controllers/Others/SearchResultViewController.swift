//
//  SearchResultViewController.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import UIKit

struct SearchSection {
    let title:String
    let results:[SearchResult]
}

protocol SearchResultViewControllerDelegate :AnyObject{
    func didTapResult(_result:SearchResult)
}
class SearchResultViewController: UIViewController {

    weak var delegate:SearchResultViewControllerDelegate?
    
    private var sections: [SearchSection] = []
    
    
    private let tableView:UITableView =  {
        let tableView = UITableView(frame: .zero, style: .grouped)
       
        tableView.isHidden = true
        return tableView
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.register(SearchResultTitleDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultTitleDefaultTableViewCell.identifier)
        
        tableView.register(SearchResultTitlesSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultTitlesSubtitleTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    func update(with results:[SearchResult]) {
        let artists = results.filter ({
            switch $0 {
            case  .artist:return true
            default:return false
             }
            
        })
      
        let tracks = results.filter ({
            switch $0 {
            case  .track:return true
            default:return false
             }
            
        })
       let albums = results.filter ({
            switch $0 {
            case  .album:return true
            default:return false
             }
            
        })
              let  playlist = results.filter ({
            switch $0 {
            case  .playlist:return true
            default:return false
             }
            
        })
        self.sections = [
            SearchSection(title: "playlist", results:  playlist ),
            SearchSection(title: "Albums", results: albums ),
            SearchSection(title: "Tracks", results: tracks),
            SearchSection(title: "Artists", results: artists)
        ]
        tableView.reloadData()
        if !results.isEmpty {
            tableView.isHidden = false
        }
    }
}


extension SearchResultViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        
        switch result {
            
        case .artist(model: let model):
            guard let cell =  tableView.dequeueReusableCell(withIdentifier:     SearchResultTitleDefaultTableViewCell.identifier, for: indexPath) as? SearchResultTitleDefaultTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultViewModel(title: model.name,image: URL(string: model.images?.first?.url ?? ""))
            cell.configure(with:  viewModel)
         return cell
            
         case .album(model: let model):
            guard let cell =  tableView.dequeueReusableCell(withIdentifier:   SearchResultTitlesSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultTitlesSubtitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultTitlesSubtitleViewModel(title: model.name, image: URL(string: model.images.first?.url ?? ""), subTitle: model.artists.first?.name ?? "")
            cell.configure(with:  viewModel)
            return cell
        case .track(model: let model):
            guard let cell =  tableView.dequeueReusableCell(withIdentifier:   SearchResultTitlesSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultTitlesSubtitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultTitlesSubtitleViewModel(title: model.name, image: URL(string: model.album?.images.first?.url ?? ""), subTitle: model.artists.first?.name ?? "")
            cell.configure(with:  viewModel)
            return cell
        case .playlist(model: let model):
            guard let cell =  tableView.dequeueReusableCell(withIdentifier:   SearchResultTitlesSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultTitlesSubtitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultTitlesSubtitleViewModel(title: model.name, image: URL(string: model.images.first?.url ?? ""), subTitle: model.owner.display_name)
            cell.configure(with:  viewModel)
            return cell
        }
     
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let result =  sections[section].title
        return result
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticManager.shared.vibrate(for: .success)
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResult(_result: result)
      
     
    
    }
    
}
