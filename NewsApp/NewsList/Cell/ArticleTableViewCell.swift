//
//  ArticleCell.swift
//  NewsApp
//
//  Created by Stella Patricia (ID) on 09/06/20.
//  Copyright © 2020 Stella. All rights reserved.
//

import Foundation
import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgArticle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()

    }
}
