//
//  HomeTableViewCell.swift
//  ArticleFlix
//
//  Created by Shaher Kassam on 28/02/16.
//  Copyright © 2016 Shaher Kassam. All rights reserved.
//

import UIKit

class AFHomeCatalogTVCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titel: UILabel!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func setCollectionViewDataSourceDelegate
//        <D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>
//        (dataSourceDelegate: D, forRow row: Int) {
//            
//            collectionView.delegate = dataSourceDelegate
//            collectionView.dataSource = dataSourceDelegate
//            collectionView.tag = row
//            collectionView.reloadData()
//    }
    

}
