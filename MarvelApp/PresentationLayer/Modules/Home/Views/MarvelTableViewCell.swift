//
//  MarvelTableViewCell.swift
//  Test
//
//  Created by Omayma Marouf on 06/02/2024.
//

import UIKit
import SDWebImage
class MarvelTableViewCell: UITableViewCell {

    @IBOutlet weak var marvelName: UILabel!
    @IBOutlet weak var marvelImage: UIImageView!
    
    var character: MarvelCharacters?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        marvelName.translatesAutoresizingMaskIntoConstraints = false

        // Initialization code
    }
    
    func configure(with character: MarvelCharacters){
        marvelName.text = character.name
        let imgURl = URL(string: character.imageURl)
        marvelImage.sd_setImage(with:imgURl , placeholderImage: UIImage(named: "icn-nav-marvel"))
        self.character = character
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
