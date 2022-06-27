//
//  FeedImageCell.swift
//  Stories
//
//  Created by Nadheer on 27/06/2022.
//

import Foundation

import UIKit

class FeedImageCell: UICollectionViewCell {
    static let identifier = "FeedImageCell"
    
    private let feedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "suit.heart.fill")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bubble.right.fill")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let sendImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "paperplane.fill")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(topImageView)
        contentView.addSubview(titleImageView)
        contentView.addSubview(feedImageView)
        contentView.addSubview(heartImageView)
        contentView.addSubview(bubbleImageView)
        contentView.addSubview(sendImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topImageView.frame = CGRect(x: 10,
                                    y: 0,
                                    width: 20,
                                    height: 20)
        
        titleImageView.frame = CGRect(x: topImageView.right+10,
                                      y: 0,
                                      width: 100,
                                      height: 20)
        
        feedImageView.frame = CGRect(x: 0,
                                     y: topImageView.bottom+20,
                                     width: contentView.width,
                                     height: 300)
        
        heartImageView.frame = CGRect(x: 10,
                                     y: feedImageView.bottom+20,
                                     width: 20,
                                     height: 20)
        
        bubbleImageView.frame = CGRect(x: heartImageView.right+10,
                                     y: feedImageView.bottom+20,
                                     width: 20,
                                     height: 20)
        
        sendImageView.frame = CGRect(x: bubbleImageView.right+10,
                                     y: feedImageView.bottom+20,
                                     width: 20,
                                     height: 20)
                        
    }
}
