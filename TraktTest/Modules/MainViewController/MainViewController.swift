//
//  MainViewController.swift
//  TraktTest
//
//  Created by Peter Su on 21/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import UIKit

public class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    var dataController = TrendingMovieDataController()
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Trakt", comment: "Trending Movies - Title")
        
        setupTableView()
        
        registerForPreviewing(with: self, sourceView: tableView)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if dataController.trendingMovies.count == 0 {
            refreshData()
        }
    }
    
    func refreshData(completion: (() -> ())? = nil) {
        
        dataController.fetchDataFromBeginning(completion: completion)
    }
    
    func setupTableView() {
        
        let movieCellNib = UINib(nibName: TrendingMovieTableViewCell.cellName(), bundle: nil)
        
        tableView.register(movieCellNib, forCellReuseIdentifier: TrendingMovieTableViewCell.cellName())
        tableView.separatorStyle = .none
        
        tableView.delegate = dataController
        tableView.dataSource = dataController
        
        dataController.delegate = self
        
        refreshControl.backgroundColor = .black
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func openDetailsFor(_ movie: Movie) {
    
        let detailsViewController = MovieDetailViewController(movie: movie)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension MainViewController: UIViewControllerPreviewingDelegate {
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        if let indexPath = tableView.indexPathForRow(at: location) {
            
            let trendingMovie = dataController.trendingMovies[indexPath.row]
            if let movie = trendingMovie.movie {
                return MovieDetailViewController(movie: movie)
            }
        }
        
        return nil
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}

extension MainViewController: TrendingMovieDataControllerDelegate {
    
    func trendingMovieDataControllerDataDidChange(_ dataController: TrendingMovieDataController) {
        
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        
        tableView.reloadData()
    }
    
    func trendingMovieDataController(_ dataController: TrendingMovieDataController, didSelectMovie movie: Movie) {
        
        openDetailsFor(movie)
    }
}
