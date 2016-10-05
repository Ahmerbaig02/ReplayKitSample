//
//  BookCell.swift
//  ReplayKitSample
//
//  Created by Prianka Liz Kariat on 9/28/16.
//  Copyright © 2016 Prianka Liz Kariat. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {

  @IBOutlet weak var authorNameLabel: UILabel!
  @IBOutlet weak var bookNameLabel: UILabel!
  @IBOutlet weak var authorImageView: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor =  UIColor(red: 201.0/255.0, green: 201.0/255.0, blue: 201.0/255.0, alpha: 0.5)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
