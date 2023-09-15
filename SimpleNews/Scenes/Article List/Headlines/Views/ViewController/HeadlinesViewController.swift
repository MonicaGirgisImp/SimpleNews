//
//  HeadlinesViewController.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 08/01/2022.
//

import UIKit

class HeadlinesViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var articlesTableView: UITableView!
    
    private var refreshControl = UIRefreshControl()
    private var isFirstRefresh: Bool = true
    
    var viewModel: HeadlinesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel = HeadlinesViewModel(headlineRepo: HeadlineDataRepo(), headlineOfflineRepo: HeadlineOfflineDataRepo())
        viewModel.delegate = self
        viewModel.handleRepo()
    }
    
    private func setupUI(){
        navigationItem.titleView = searchBar
        articlesTableView.register(UINib(nibName: String(describing: ArticleTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ArticleTableViewCell.self))
        
        articlesTableView.refreshControl = refreshControl
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(handleRefresher), for: .valueChanged)
    }
    
    @objc
    private func handleRefresher(){
        viewModel.resetResults()
    }
    
    private func handleRefreshControl(_ isRefreshing:Bool) {
        if isRefreshing {
            if isFirstRefresh{
                isFirstRefresh = !isFirstRefresh
                articlesTableView.contentOffset = CGPoint(x:0, y:-self.refreshControl.frame.size.height)
            }
            refreshControl.beginRefreshing()
        } else {
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
        }
    }
    
    @IBAction func showBookmarks(_ sender: Any) {
        performSegue(withIdentifier: "showBookmarks", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ArticleDetailsViewController, let article = sender as? Article else { return}
        vc.viewModel = ArticleDetailsViewModel(article: article)
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension HeadlinesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articlesData.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleTableViewCell.self), for: indexPath) as! ArticleTableViewCell
        cell.setData(article: viewModel.articlesData.articles[indexPath.row])
        
        cell.saveLater = { [weak self] in
            guard let self = self else { return}
            viewModel.addArticleToBookmarks(at: indexPath.row)
            articlesTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == viewModel.articlesData.articles.count - 10 else { return }
        viewModel.getNextPage()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: viewModel.articlesData.articles[indexPath.row])
    }
}

//MARK:- UISearchBarDelegate
extension HeadlinesViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        searchBar.endEditing(true)
        viewModel.searchArticles(with: text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            viewModel.resetResults()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        viewModel.resetResults()
    }
}

extension HeadlinesViewController: ViewModelDelegates {
    func autoUpdateView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return}
            articlesTableView.reloadData()
        }
    }
    
    func failedWithError(_ err: String) {
        showAlert(message: err)
    }
    
    func loaderIsHidden(_ isHidden: Bool) {
        handleRefreshControl(!isHidden)
        if isHidden {
            Spinner.hideSpinner()
        }else{
            Spinner.showSpinner()
        }
    }
    
    func insertNewRows(_ initialIndex: Int, _ endIndex: Int, _ section: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return}
            let indicies = (initialIndex..<endIndex).map({ IndexPath(row: $0, section: 0) })
            articlesTableView.beginUpdates()
            articlesTableView.insertRows(at: indicies, with: .automatic)
            articlesTableView.endUpdates()
        }
    }
}
