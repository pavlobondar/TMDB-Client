//
//  FavoritesViewController.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import UIKit

protocol FavoritesViewControllerProtocol: AnyObject {
    func reloadData()
    func removeRow(indexPath: IndexPath)
    func updateBackground(style: BackgroundStyle)
    func hideRefreshIndicator()
}

final class FavoritesViewController: UITableViewController {
    
    private var refreshIndicator = UIRefreshControl()
    private var backgroundView = BackgroundView()
    
    var presenter: FavoritesPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshIndicator()
        setupTableView()
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.fetchFavorites()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.dataSource.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = presenter?.getViewModel(indexPath: indexPath)
        let cell = tableView.dequeue(MovieTableViewCell.self, forIndexPath: indexPath)
        cell.viewModel = viewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.handleCellAction(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _,_,_ in
            self?.presenter?.removeItem(indexPath: indexPath)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.fetchFavoritesIfNeeded(indexPath: indexPath)
    }
    
    private func setupRefreshIndicator() {
        refreshIndicator.addTarget(self, action: #selector(refreshIndicatorAction), for: .valueChanged)
    }
    
    private func setupTableView() {
        tableView.refreshControl = refreshIndicator
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func registerCells() {
        tableView.registerFromNib(MovieTableViewCell.self)
    }
    
    @objc
    private func refreshIndicatorAction() {
        presenter?.fetchFavorites()
    }
}

// MARK: - FavoritesViewControllerProtocol
extension FavoritesViewController: FavoritesViewControllerProtocol {
    func reloadData() {
        tableView.reloadData()
    }
    
    func removeRow(indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
    func updateBackground(style: BackgroundStyle) {
        backgroundView.updateStyle(style: style)
    }
    
    func hideRefreshIndicator() {
        refreshIndicator.endRefreshing()
    }
}
