//
//  CalendarTableViewCell.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/20.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
  
  @IBOutlet weak var categoryImage: UIImageView!
  @IBOutlet weak var daysLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var paymentLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var introduceLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
    
}
