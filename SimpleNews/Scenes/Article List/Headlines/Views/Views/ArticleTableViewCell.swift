//
//  ArticleTableViewCell.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 08/01/2022.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var headLineLabel: UILabel!
    @IBOutlet weak var newsPaperLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var saveLaterButton: UIButton!
    
    var saveLater: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI(){
        articleImageView.makeRoundedCornersWith(radius: 8.0)
    }
    
    func setData(article: Article){
        articleImageView.getAsync(article.urlToImage ?? "")
        headLineLabel.text = article.title ?? ""
        newsPaperLabel.text = article.source?.name ?? ""
        descriptionLabel.text = article.articleDescription ?? ""
        datePostedLabel.text = setData(date: article.date ?? Date())
        saveLaterButton.setImage((article.isSaved ?? false) ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"), for: .normal)
    }
    
    private func setData(date: Date)->String{
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "MMM d, h:mm a"
        return newDateFormatter.string(from: date)
    }
    
    @IBAction func saveLaterAction(_ sender: Any) {
        saveLater?()
    }
}
