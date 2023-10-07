//
//  BookmarksViewController.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 09/01/2022.
//

import UIKit

class BookmarksViewController: UIViewController {

    @IBOutlet weak var bookmarksTableView: UITableView!
    
    var viewModel = BookmarksViewModel(bookmarksRepo: FetchBookmarksData())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI(){
        bookmarksTableView.register(UINib(nibName: String(describing: ArticleTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ArticleTableViewCell.self))
    }
    
    @IBAction func deleteArticles(_ sender: Any) {
        viewModel.unmarkAllArticles()
        bookmarksTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ArticleDetailsViewController, let article = sender as? Article else { return}
        vc.viewModel = ArticleDetailsViewModel(article: article)
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension BookmarksViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bookmarksData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleTableViewCell.self), for: indexPath) as! ArticleTableViewCell
        cell.setData(article: viewModel.bookmarksData.value[indexPath.row])
        
        cell.saveLater = { [weak self] in
            guard let self = self else { return}
            viewModel.unmarkArticle(at: indexPath.row)
            tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: viewModel.bookmarksData.value[indexPath.row])
    }
}
