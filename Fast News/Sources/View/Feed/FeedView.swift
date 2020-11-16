//
//  FeedView.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import UIKit

protocol FeedViewDelegate {
    func didTouch(cell: FeedCell, indexPath: IndexPath)
    func willLoadMore()
}

class FeedView: UIView {    
    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    var viewModels: [HotNewsViewModel] = [HotNewsViewModel]() {
        didSet {
            self.tableView.reloadSections([0], with: .fade)
        }
    }
    var delegate: FeedViewDelegate?
    
    //MARK: - Public Methods
    
    func setup(with viewModels: [HotNewsViewModel], and delegate: FeedViewDelegate) {
        tableView.register(UINib(nibName: "FeedCell", bundle: Bundle.main), forCellReuseIdentifier: "FeedCell")
        
        self.delegate = delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        self.viewModels.append(contentsOf: viewModels)
    }
}

extension FeedView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell else { fatalError("Cell is not of type FeedCell!") }
        
        cell.setup(hotNewsViewModel: viewModels[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FeedCell else { fatalError("Cell is not of type FeedCell!") }
        
        delegate?.didTouch(cell: cell, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = cell.transform.translatedBy(x: -80, y: 0)
        let delay = 0.2 * (Double(indexPath.row) * 0.1)
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.3,
                       delay: delay,
                       options: [.curveEaseOut],
                       animations: {
                        cell.transform = .identity
                        cell.alpha = 1.0
                        },
                       completion: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height - 70) {
            self.delegate?.willLoadMore()
        }
    }
    
}
