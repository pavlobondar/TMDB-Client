//
//  SearchViewController.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import UIKit

protocol SearchViewControllerProtocol: AnyObject {
    func reloadData()
    
    func setSearchQuery(_ query: String)
    
    func removeRow(indexPath: IndexPath)
    func updateBackground(style: BackgroundStyle)
}

final class SearchViewController: UITableViewController {
    
    private var searchController = UISearchController(searchResultsController: nil)
    private var backgroundView = BackgroundView()
    
    var presenter: SearchPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupTableView()
        registerCells()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.dataSource.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = presenter?.getViewModel(indexPath: indexPath)
        let dataType = presenter?.dataSource.type
        switch dataType {
        case .recentSearches:
            let cell = tableView.dequeue(RecentSearchTableViewCell.self, forIndexPath: indexPath)
            cell.viewModel = viewModel
            return cell
        case .movies:
            let cell = tableView.dequeue(MovieTableViewCell.self, forIndexPath: indexPath)
            cell.viewModel = viewModel
            return cell
        case .none:
            return .init()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let searchText = searchController.searchBar.text else { return }
        presenter?.fetchMoviesIfNeeded(query: searchText, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.handleCellAction(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actions = getContextualActions(indexPath: indexPath)
        let swipeConfiguration = UISwipeActionsConfiguration(actions: actions)
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
    
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        searchController.searchBar.returnKeyType = .search
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupTableView() {
        tableView.contentInset = .init(top: 21.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundView = backgroundView
    }
    
    private func registerCells() {
        tableView.register(RecentSearchTableViewCell.self)
        tableView.registerFromNib(MovieTableViewCell.self)
    }
    
    private func getContextualActions(indexPath: IndexPath) -> [UIContextualAction] {
        let dataType = presenter?.dataSource.type
        switch dataType {
        case .recentSearches:
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _,_,_ in
                self?.presenter?.removeItem(indexPath: indexPath)
            }
            deleteAction.image = UIImage(systemName: "trash")
            return [deleteAction]
        case .movies:
            let addToFavoritesAction = UIContextualAction(style: .normal, title: nil) { [weak self] _,_,_ in
                self?.presenter?.addToFavorites(indexPath: indexPath)
                self?.tableView?.setEditing(false, animated: true)
            }
            addToFavoritesAction.image = UIImage(systemName: "bookmark")
            addToFavoritesAction.backgroundColor = .systemPurple
            return [addToFavoritesAction]
        case .none:
            return []
        }
    }
}

// MARK: - UISearchControllerDelegate
extension SearchViewController: UISearchControllerDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.cancelSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text else { return }
        presenter?.searchMovies(query: searchText)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchTextDidChange(text: searchText)
    }
}

// MARK: - SearchViewControllerProtocol
extension SearchViewController: SearchViewControllerProtocol {
    func reloadData() {
        tableView.reloadData()
    }
    
    func setSearchQuery(_ query: String) {
        searchController.isActive = true
        searchController.searchBar.searchTextField.text = query
    }
    
    func removeRow(indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
    func updateBackground(style: BackgroundStyle) {
        backgroundView.updateStyle(style: style)
    }
}
