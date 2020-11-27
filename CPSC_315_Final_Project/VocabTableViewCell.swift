//
//  VocabTableViewCell.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 11/27/20.
//

import UIKit

class VocabTableViewCell: UITableViewCell {

    @IBOutlet var foriegnLabel: UILabel!
    @IBOutlet var englishLabel: UILabel!
    @IBOutlet var mneumonicLabel: UILabel!
    @IBOutlet var statisticsLabel: UILabel!
    @IBOutlet var markedReviewButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
