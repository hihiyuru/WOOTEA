//
//  MenuViewController.swift
//  WOOTEA
//
//  Created by 徐于茹 on 2023/8/29.
//

import UIKit
import Kingfisher

class MenuViewController: UIViewController {
    
    var apiMenuData = [Menu]()
    var autoScrollTimer: Timer?
    var isShowMore = false
    
    @IBOutlet weak var MenuTableView: UITableView!
    @IBOutlet weak var BannerScrollView: UIScrollView!
    @IBOutlet weak var MoreButton: UIButton!
    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    @IBOutlet var CatgoriesButtons: [UIButton]!
    
    @IBOutlet weak var CategoriesView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuTableView.dataSource = self
        CategoryCollectionView.dataSource = self
        CategoryCollectionView.delegate = self
        showCategories()
        fetchMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        autoScrollTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(autoScrollToNextPage), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        autoScrollTimer?.invalidate()
    }
    
    func showCategories() {
        CategoriesView.isHidden = !isShowMore
            let imageName = isShowMore ? "chevron.up" : "chevron.down"
            MoreButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc func autoScrollToNextPage() {
        let width = BannerScrollView.frame.size.width
        let currentPage = Int(BannerScrollView.contentOffset.x / width)
        let totalPages = Int(BannerScrollView.contentSize.width / width)
        
        if currentPage + 1 == totalPages {
            // 如果當前頁面是最後一頁，則回到第一頁
            BannerScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else {
            // 否則，滾動到下一頁
            BannerScrollView.setContentOffset(CGPoint(x: width * CGFloat(currentPage + 1), y: 0), animated: true)
        }
    }
    
    func fetchMenu() {
        let stringUrl = "https://raw.githubusercontent.com/hihiyuru/drinkApi/main/menu.json"
        guard let url = URL(string: stringUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    self.apiMenuData = try decoder.decode([Menu].self, from: data)
                    DispatchQueue.main.async {
                        self.MenuTableView.reloadData()
                        self.CategoryCollectionView.reloadData()
                        self.CatgoriesButtons.enumerated().forEach { (index, button) in
                            button.setTitle(self.apiMenuData[index].categoryName, for: .normal)
                            button.tag = index
                        }
                    }
                } catch {
                    print("drinkApi出錯了")
                }
            }
        }.resume()
    }
    
    @IBSegueAction func goDetailPage(_ coder: NSCoder) -> DetailViewController? {
        let controller = DetailViewController(coder: coder)
        if let indexPath = MenuTableView.indexPathForSelectedRow {
            let selectedSectionIndex = indexPath.section
            let rowIndex = indexPath.row
            controller?.currentDrink = apiMenuData[ selectedSectionIndex ].items[rowIndex]
        }
        return controller
    }
    @IBAction func showMoreCategories(_ sender: UIButton) {
        isShowMore = !isShowMore
        showCategories()
    }
    @IBAction func selectedCategory(_ sender: UIButton) {
        print("點擊", sender.tag)
        let menuTableViewIndexPath = IndexPath(row: 0, section: sender.tag)
        MenuTableView.scrollToRow(at: menuTableViewIndexPath, at: .top, animated: true)
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return apiMenuData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return apiMenuData[section].items.count

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
            let headerView = UIView()
            headerView.backgroundColor = .white
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 18) // Set your desired font and size here
            label.textColor = UIColor(cgColor: CGColor(red: 239/255, green: 143/255, blue: 48/255, alpha: 1))
            label.text = apiMenuData[section].categoryName
            
            headerView.addSubview(label)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
                label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
                label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
            
            return headerView
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(DrinkTableViewCell.self)", for: indexPath) as? DrinkTableViewCell else { fatalError("something wrong") }
            cell.PicImageView.kf.setImage(with: apiMenuData[indexPath.section].items[indexPath.row].imageUrl)
            cell.PicImageView.backgroundColor = .white
            cell.NameLabel.text = apiMenuData[indexPath.section].items[indexPath.row].name
            if apiMenuData[indexPath.section].items[indexPath.row].isHasHot {
                cell.HotPriceLabel.text = String(apiMenuData[indexPath.section].items[indexPath.row].price)
                cell.HotImageView.isHidden = false
            } else {
                cell.HotPriceLabel.text = .none
                cell.HotImageView.isHidden = true
            }
            cell.ColdPriceLabel.text = String(apiMenuData[indexPath.section].items[indexPath.row].price)
            
            return cell
    }
    
    
}

extension MenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("點擊我了")
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apiMenuData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CategoryCollectionViewCell.self)", for: indexPath) as! CategoryCollectionViewCell
        cell.CategoryButtton.setTitle(apiMenuData[indexPath.row].categoryName, for: .normal)
        cell.CategoryButtton.tag = indexPath.row
        return cell
    }
    
    
}
