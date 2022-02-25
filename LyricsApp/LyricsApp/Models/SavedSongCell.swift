//
//  SavedSongCell.swift
//  LyricsApp
//
//  Created by Iker Gutierrez on.
//

import UIKit

class SavedSongCell: UITableViewCell {

    
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var songLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
