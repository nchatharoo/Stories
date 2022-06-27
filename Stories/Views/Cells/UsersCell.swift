//
//  MyStoryCell.swift
//  Stories
//
//  Created by Nadheer on 27/06/2022.
//

import UIKit

class UsersCell: UICollectionViewCell {
    static let identifier = "UsersCell"
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2.0
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            userImageView.alpha = isHighlighted ? 0.75 : 1
        }
    }

    override var isSelected: Bool {
        didSet {
            userImageView.alpha = isSelected ? 0.75 : 1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with video: Video) {
        self.userImageView.downloadImageFrom(link: URL(string: video.image)!)
        self.userNameLabel.text = video.user.name
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userNameLabel.sizeToFit()
                
        userImageView.frame = CGRect(x: contentView.center.x - 25,
                                     y: 0,
                                     width: 50,
                                     height: 50)
        
        userNameLabel.frame = CGRect(x: 0,
                                     y: userImageView.bottom+10,
                                     width: contentView.width,
                                     height: 20)
    }
}
