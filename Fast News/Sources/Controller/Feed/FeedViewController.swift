//
//  FeedViewController.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import Foundation
import UIKit

class FeedViewController: UIViewController {
    
    //MARK: - Constants
    let kToDetails: String = "toDetails"
    var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties    
    var hotNews: [HotNews] = [HotNews]() {
        didSet {
            var viewModels: [HotNewsViewModel] = [HotNewsViewModel]()
            _ = hotNews.map { (news) in
                viewModels.append(HotNewsViewModel(hotNews: news))
            }
            
            self.mainView.setup(with: viewModels, and: self)
        }
    }
    
    var mainView: FeedView {
        guard let view = self.view as? FeedView else {
            fatalError("View is not of type FeedView!")
        }
        return view
    }
    
    private func loadNews() {
        HotNewsProvider.shared.hotNews { (completion) in
            do {
                let hotNews = try completion()
                self.hotNews = hotNews
                self.readyState()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Fast News"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.setupActivityIndicator()
        self.loadingState()
        self.loadNews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let hotNewsViewModel = sender as? HotNewsViewModel else { return }
        guard let detailViewController = segue.destination as? FeedDetailsViewController else { return }
        
        detailViewController.hotNewsViewModel = hotNewsViewModel
    }
    
    // MARK: - Private Methods
    private func setupActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView(style: .gray)
        self.activityIndicator.hidesWhenStopped = true
         
        let barButton = UIBarButtonItem(customView: activityIndicator)
        
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    private func loadingState() {
        self.activityIndicator.startAnimating()
    }
    
    private func readyState() {
        self.activityIndicator.stopAnimating()
    }
}

extension FeedViewController: FeedViewDelegate {
    func didTouch(cell: FeedCell, indexPath: IndexPath) {
        self.performSegue(withIdentifier: kToDetails, sender: self.mainView.viewModels[indexPath.row])
    }
    
    func willLoadMore() {
        if HotNewsProvider.shared.hasNexPage {
            self.loadingState()
            self.loadNews()
        }
    }
}
