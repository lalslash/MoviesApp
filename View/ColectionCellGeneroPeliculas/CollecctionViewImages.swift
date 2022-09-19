//
//  CollecctionViewImages.swift
//  peliculasAPI
//
//  Created by user223791 on 9/12/22.
//

import UIKit

class CollecctionViewImages: UICollectionViewCell {
    
    @IBOutlet weak var labelMinEdad: UILabel!
    @IBOutlet weak var labelNombrePelicula: UILabel!
    @IBOutlet weak var labelGeneroPelicula: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    static let nibName = "CollecctionViewImages"
    static let identificador = "cellPeliculas"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
