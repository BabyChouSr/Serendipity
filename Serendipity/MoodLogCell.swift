//
//  MoodLogCell.swift
//  firebaseTestApp
//
//  Created by Akshay Kumar on 1/30/21.
//

import UIKit

class MoodLogCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var activityLabel: UILabel!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var transcriptView: UITextView!
    
    @IBOutlet var userEmoji: UILabel!
    @IBOutlet var algoEmoji: UILabel!

    @IBOutlet var boboy: UIView!
    
    @IBOutlet var contentBackground: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        boboy.layer.cornerRadius = 25
        contentBackground.layer.cornerRadius = 20
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
