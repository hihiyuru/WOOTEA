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
    
    @IBOutlet weak var MenuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuTableView.dataSource = self
        fetchMenu()
        // Do any additional setup after loading the view.
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
            controller?.currentDrink = apiMenuData[ selectedSectionIndex - 1  ].items[rowIndex]
        }
        return controller
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + apiMenuData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            let index = section - 1
            return apiMenuData[index].items.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        } else {
            let headerView = UIView()
            headerView.backgroundColor = .white
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 18) // Set your desired font and size here
            label.textColor = UIColor(cgColor: CGColor(red: 239/255, green: 143/255, blue: 48/255, alpha: 1))
            label.text = apiMenuData[section - 1].categoryName
            
            headerView.addSubview(label)
            
            // Add constraints for label
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
                label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
                label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
            
            return headerView
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(SearchTableViewCell.self)", for: indexPath)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(DrinkTableViewCell.self)", for: indexPath) as? DrinkTableViewCell else { fatalError("something wrong") }
            cell.PicImageView.kf.setImage(with: apiMenuData[indexPath.section - 1].items[indexPath.row].imageUrl)
            cell.PicImageView.backgroundColor = .white
            cell.NameLabel.text = apiMenuData[indexPath.section - 1].items[indexPath.row].name
            if apiMenuData[indexPath.section - 1].items[indexPath.row].isHasHot {
                cell.HotPriceLabel.text = String(apiMenuData[indexPath.section - 1].items[indexPath.row].price)
                cell.HotImageView.isHidden = false
            } else {
                cell.HotPriceLabel.text = .none
                cell.HotImageView.isHidden = true
            }
            cell.ColdPriceLabel.text = String(apiMenuData[indexPath.section - 1].items[indexPath.row].price)
            
            return cell
        }
    }
    
    
}

