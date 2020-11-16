//
//  FeedCell.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import UIKit

@IBDesignable
class FeedCell: UITableViewCell {
    
    //MARK: - Properties
    @IBOutlet weak var authorLabel              : UILabel!
    @IBOutlet weak var createdAtLabel           : UILabel!
    @IBOutlet weak var thumbnailImageView       : UIImageView!
    @IBOutlet weak var titleLabel               : UILabel!
    @IBOutlet weak var commentsLabel            : UILabel!
    @IBOutlet weak var scoreLabel               : UILabel!
    @IBOutlet weak var thumbHeightConstraint    : NSLayoutConstraint!
    
    //MARK: - Public Methods
    func setup(hotNewsViewModel: HotNewsViewModel) {
        authorLabel.text            = hotNewsViewModel.author
        createdAtLabel.text         = hotNewsViewModel.createdAt
        thumbnailImageView.image    = hotNewsViewModel.image
        titleLabel.text             = hotNewsViewModel.title
        commentsLabel.text          = hotNewsViewModel.comments
        scoreLabel.text             = hotNewsViewModel.score
        
        self.setupUI()
    }
    
    func setup(viewModel: TypeProtocol) {
        guard let hotNewsViewModel = viewModel as? HotNewsViewModel else { return }
        authorLabel.text            = hotNewsViewModel.author
        createdAtLabel.text         = hotNewsViewModel.createdAt
        thumbnailImageView.image    = hotNewsViewModel.image
        titleLabel.text             = hotNewsViewModel.title
        commentsLabel.text          = hotNewsViewModel.comments
        scoreLabel.text             = hotNewsViewModel.score
        
        self.setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        self.thumbnailImageView.layer.borderWidth   = 1.0
        self.thumbnailImageView.layer.borderColor   = UIColor.lightGray.cgColor
        self.thumbnailImageView.layer.cornerRadius  = 8
        
        self.thumbnailImageView.image == nil ? (self.thumbHeightConstraint.constant = 0) : (self.thumbHeightConstraint.constant = 114)
    }
}
