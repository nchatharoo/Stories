//
//  FeedItem.swift
//  Stories
//
//  Created by Nadheer on 27/06/2022.
//

import Foundation
import UIKit

struct FeedItem: Hashable {
    let image: UIImage
}

extension FeedItem {
    static var demoFeed: [FeedItem] {
        return [FeedItem(image: UIImage.make(withColor: .gray)), FeedItem(image: UIImage.make(withColor: .gray))]
    }
}
