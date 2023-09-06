//
//  ArticleDetailsViewController.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 31/07/2023.
//

import UIKit

class ArticleDetailsViewController: UIViewController {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var sourceImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    var viewModel = ArticleDetailsViewModel(article: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

//        viewModel?.delegate = self
        setupUI()
        setData()
    }
    
    private func setupUI() {
        sourceImageView.makeRoundedCorners()
    }
    
    private func setData() {
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "MMM d, h:mm a"
        
        titleLabel.text = viewModel.article?.title
        contentLabel.text = viewModel.article?.content
        categoryLabel.text = "#" + (viewModel.article?.category ?? "")
        authorLabel.text = viewModel.article?.author
        sourceLabel.text = viewModel.article?.source?.name
        dateLabel.text = newDateFormatter.string(from: viewModel.article?.date ?? Date())
        contentImageView.getAsync(viewModel.article?.urlToImage ?? "")
        sourceImageView.getAsync(viewModel.article?.urlToImage ?? "")
    }
    
    
    @IBAction func openArticleInWebView(_ sender: UIButton) {
        performSegue(withIdentifier: "showDetails", sender: viewModel.article?.url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? webViewController, let url = sender as? String else { return}
        vc.articleURL = url
    }
}

extension ArticleDetailsViewController: ViewModelDelegates {
    func autoUpdateView() {
        setData()
    }
    
    func failedWithError(_ err: String) {
    }
    
    func loaderIsHidden(_ isHidden: Bool) {
    }
    
    func insertNewRows(_ initialIndex: Int, _ endIndex: Int, _ section: Int) {
    }
}
