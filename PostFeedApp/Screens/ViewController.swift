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
    var expandedCells: IndexSet = []
    var longCells: IndexSet = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadNetworkData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let filterVC = storyboard.instantiateViewController(withIdentifier: "FilterController") as? FilterController else {
            return
        }
        
        filterVC.sortType = { [unowned self] sort in
            switch sort {
            case 0:
                postData.sort { $0.timeshamp > $1.timeshamp }
                tableView.reloadData()
            case 1:
                postData.sort { $0.likesCount > $1.likesCount }
                tableView.reloadData()
            default:
                return
            }
        }
        
        present(filterVC, animated: true)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        
        detailVC.postId = postData[indexPath.row].postId
        navigationController?.pushViewController(detailVC, animated: true)
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
        
        cell.postNameLabel.text = postData[indexPath.row].title
        cell.postPreviewTextLabel.text = postData[indexPath.row].previewText
        cell.postLikesCountLabel.text = String(postData[indexPath.row].likesCount)
        cell.postDateLabel.text = date.timeAgoDisplay()
        
        if cell.postPreviewTextLabel.maxNumberOfLines <= 2 && !longCells.contains(indexPath.row) {
            cell.button.isHidden = true
        } else {
            cell.button.isHidden = false
            longCells.insert(indexPath.row)
            
            if expandedCells.contains(indexPath.row) {
                cell.postPreviewTextLabel.numberOfLines = 0
                cell.button.setTitle("See Less", for: .normal)
            } else {
                cell.postPreviewTextLabel.numberOfLines = 2
                cell.button.setTitle("See More", for: .normal)
            }
        }
        
        cell.buttonClicked = { [unowned self] in
            if expandedCells.contains(indexPath.row) {
                expandedCells.remove(indexPath.row)
            } else {
                expandedCells.insert(indexPath.row)
            }
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
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

extension UILabel {
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font as Any], context: nil).height
        let lineHeight = font.lineHeight
        
        return Int(ceil(textHeight / lineHeight)) - 1
    }
}
