//
//  ViewController.swift
//  ImageSearch
//
//  Created by Сергей Бабий on 13.05.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let imageTable = ImageTableViewCell()
    let networkDataFatcher = NetworkDataFetcher()
    let networkService = NetworkService()
    var searchResponse: SearchResponse? = nil
    private var timer: Timer?
    var urlImages: [String] = []


    @IBOutlet weak var table: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        table.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: idCell)
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setupTableView() {
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: idCell)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.data.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as! ImageTableViewCell
        if (self.urlImages.capacity > 0) {
            cell.titleLanelCell.text = self.searchResponse?.data[indexPath.row].title
            cell.imageViewCell.downloaded(from: urlImages[indexPath.row])
        }
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let urlString = "https://api.giphy.com/v1/gifs/search?api_key=\(API_KEY)=\(searchText)&limit=\(LIMIT)&offset=0&rating=g&lang=en"
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.networkDataFatcher.fatchData(urlString: urlString) { (searchSesponse) in
                guard let searchSesponse = searchSesponse else { return }
                self.searchResponse = searchSesponse
                if self.searchResponse != nil{
                    if (self.urlImages.count > 0) {
                        self.urlImages.removeAll()
                    }
                    for item in self.searchResponse!.data{
                        self.urlImages.append(item.images.original.url)
                    }
                }
                self.table.reloadData()
                
            }
        })
    }
}
// MARK: - Image upload
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


