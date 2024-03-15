    //
//  ListViewController.swift
//  TMDB
//
//  Created by Pavlo on 27.01.2024.
//

import UIKit

protocol ListViewControllerProtocol: AnyObject {
    func reloadData()
}

final class ListViewController: UITableViewController {

    var presenter: ListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = presenter?.dataSource.genre?.title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.dataSource.page.movies.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = presenter?.getViewModel(indexPath: indexPath)
        let cell = tableView.dequeue(MovieTableViewCell.self, forIndexPath: indexPath)
        cell.viewModel = viewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.fetchMoviesIfNeeded(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showDetails(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addToFavoritesAction = UIContextualAction(style: .normal, title: nil) { [weak self] _,_,_ in
            self?.presenter?.addToFavorites(indexPath: indexPath)
            self?.tableView?.setEditing(false, animated: true)
        }
        addToFavoritesAction.image = UIImage(systemName: "bookmark")
        addToFavoritesAction.backgroundColor = .systemPurple
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [addToFavoritesAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
    
    private func registerCells() {
        tableView.registerFromNib(MovieTableViewCell.self)
    }
}

// MARK: - ListViewControllerProtocol
extension ListViewController: ListViewControllerProtocol {
    func reloadData() {
        tableView.reloadData()
    }
}
