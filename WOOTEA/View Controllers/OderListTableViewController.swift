//
//  OderListTableViewController.swift
//  WOOTEA
//
//  Created by 徐于茹 on 2023/9/12.
//

import UIKit

class OderListTableViewController: UITableViewController {
    var drinks = [Order]()
    var drinksApiData = [Record]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDrinks()
    }

    
    func fetchDrinks() {
        let urlString = "https://api.airtable.com/v0/appE7K437QBucbxsg/order"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer pat6aEQvRG1gPr3nI.15ffab2d4292ca7b9f3d676590f2289ef35be0e8292402762eeeb81e8fffa581", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decodedData = try JSONDecoder().decode(AirtableResponse.self, from: data)
                self.drinks = decodedData.records.map { $0.fields }
                self.drinksApiData = decodedData.records
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error decoding: \(error)")
            }
        }.resume()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(OderListTableViewCell.self)", for: indexPath) as! OderListTableViewCell
        
        let drink = drinks[indexPath.row]
        cell.BgView.backgroundColor = randomColor()
        cell.emojiLabel.text = randomEmoji()
        cell.UserLabel.text = drink.user
        cell.DrinkLabel.text = "\(drink.name)  \(drink.iceLevel) / \(drink.sugarLevel) \(drink.count)杯"
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete ||  editingStyle == .insert {
            let drinkIdToDelete = drinksApiData[indexPath.row]
            deleteDrinkFromAPI(removefield: drinkIdToDelete) { result in
                switch result {
                case .success(let content):
                    DispatchQueue.main.async {
                        tableView.beginUpdates()
                        self.drinks.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        tableView.endUpdates()
                    }
                    print(content)
                case .failure(let error):
                    print("Error deleting drink: \(error.localizedDescription)")
                }
            }
            
        }
        
    }
    
    func deleteDrinkFromAPI(removefield: Record, completion: @escaping (Result<Deleted, Error>) -> Void) {
        let urlString = "https://api.airtable.com/v0/appE7K437QBucbxsg/order"
        var urlComponent = URLComponents(string: urlString)
        let queryItem = URLQueryItem(name: "records[]", value: removefield.id)
        urlComponent?.queryItems = [queryItem]
        if let url = urlComponent?.url {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            urlRequest.setValue("Bearer pat6aEQvRG1gPr3nI.15ffab2d4292ca7b9f3d676590f2289ef35be0e8292402762eeeb81e8fffa581", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "APIError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                do {
                    let content = try JSONDecoder().decode(Deleted.self, from: data)
                    completion(.success(content))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        } else {
            completion(.failure(NSError(domain: "APIError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
        }
    }

    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
