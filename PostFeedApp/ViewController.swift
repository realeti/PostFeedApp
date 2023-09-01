//
//  ViewController.swift
//  PostFeedApp
//
//  Created by Apple M1 on 31.08.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let networkController = NetworkController()
    var postData: [PostData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadNetworkData()
    }
    
    private func setupUI() {
        title = "Posts"
        
        let customCellTypeNib = UINib(nibName: "CustomCell", bundle: nil)
        tableView.register(customCellTypeNib, forCellReuseIdentifier: "CustomCell")
    }
    
    private func loadNetworkData() {
        networkController.fetchPosts { result in
            do {
                let data = try result.get()
                self.postData = data
            } catch {
                self.postData = []
                print(error)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? CustomCell else {
            return UITableViewCell()
        }
        
        let date = Date(timeIntervalSince1970: Double(postData[indexPath.row].timeshamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        let localDate = date.timeAgoDisplay()
        
        cell.postNameLabel.text = postData[indexPath.row].title
        cell.postPreviewTextLabel.text = postData[indexPath.row].previewText
        cell.postLikesCountLabel.text = String(postData[indexPath.row].likesCount)
        cell.postDateLabel.text = localDate
        
        return cell
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
