//
//  ImageTableViewCell.swift
//  ImageSearch
//
//  Created by Сергей Бабий on 17.05.2021.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var titleLanelCell: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.imageViewCell.image = UIImage(data: data)
            }
        }
    }
  
    
}
