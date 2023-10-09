//
//  HeadlinesViewController.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 08/01/2022.
//

import UIKit
import Combine

class HeadlinesViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var articlesTableView: UITableView!
    
    private var refreshControl = UIRefreshControl()
    private var isFirstRefresh: Bool = true
    private var cancelable = Set<AnyCancellable>()
    
    var viewModel: HeadlinesViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel = HeadlinesViewModel(headlineRepo: HeadlineDataRepo())
        bindShowLoader()
        bindAutoUpdateView()
        bindFailureWithError()
        viewModel.fetchData()
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
        return viewModel.articles.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleTableViewCell.self), for: indexPath) as! ArticleTableViewCell
        cell.setData(article: viewModel.articles.value[indexPath.row])
        
        cell.saveLater = { [weak self] in
            guard let self = self else { return}
            viewModel.addArticleToBookmarks(at: indexPath.row)
            articlesTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == viewModel.articles.value.count - 5 else { return }
        viewModel.getNextPage()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: viewModel.articles.value[indexPath.row])
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

extension HeadlinesViewController {
    private func bindShowLoader() {
        viewModel.showLoader
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isShowen in
                guard let self = self else { return }
                if isShowen {
                    Spinner.showSpinner()
                }else{
                    Spinner.hideSpinner()
                }
            }.store(in: &cancelable)
    }
    
    private func bindFailureWithError() {
        viewModel.failedWithError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
            guard let self = self else { return }
            showAlert(message: error)
            }.store(in: &cancelable)
    }
    
    private func bindAutoUpdateView() {
        viewModel.autoUpdateView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                articlesTableView.reloadData()
            }.store(in: &cancelable)
    }
}
