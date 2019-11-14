//
//  inputTableViewCell.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/14.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit

class inputTableViewCell: UITableViewCell {
  
  @IBOutlet weak var inputLabel: UILabel!
  @IBOutlet weak var inputTextField: UITextField!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
