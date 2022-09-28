//
//  HomeTableViewCell.swift
//  HeroMap
//
//  Created by Nicolas on 27/09/22.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var contentCell: UIView!
    @IBOutlet weak var photo: UIImageView!
    static var cellIdentifier: String {
        String(describing: HomeTableViewCell.self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentCell.layer.cornerRadius = 4.0
        contentCell.layer.shadowColor = UIColor.gray.cgColor
        contentCell.layer.shadowOffset = .zero
        contentCell.layer.shadowOpacity = 0.7
        contentCell.layer.shadowRadius = 4.0
        photo.layer.cornerRadius = (photo.bounds.height)/2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.text = nil
        photo.image = nil
    }
    
    func updateViews(data: Hero) {
        update(name: data.name)
        update(image: data.photo)
    }
    
    private func update(name: String){
        self.name.text = name
    }
    
    private func update(image: URL){
        photo.setImage(url: image)
    }
}
