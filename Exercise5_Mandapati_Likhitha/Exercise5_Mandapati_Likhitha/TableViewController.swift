//
//  TableViewController.swift
//  Exercise5_Mandapati_Likhitha
//
//  Created by student on 10/8/22.
//

import UIKit

struct Zone : Codable {
    
    init() {
        name = ""
        free = 0
        logo = URL(string: "http://www.google.com")!
        map = URL(string: "http://www.google.com")!
        lots = ""
        info = URL(string: "http://www.google.com")!
        about = ""
    }
    
    let name: String
    let free: Int
    let logo: URL
    let map: URL
    let lots: String
    let info: URL
    let about: String
}


class TableViewController: UITableViewController {

    var zones = [Zone]()
    var selectedZone = Zone()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://cpl.uh.edu/courses/ubicomp/fall2022/webservice/parking/parkinglots.json")
        if url != nil {
            getData(url: url!)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return zones.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let logo = cell.viewWithTag(1) as! UIImageView
        let free = cell.viewWithTag(2) as! UILabel
        
        // Configure the cell...
        free.text = "Free: \(zones[indexPath.row].free)"
        let url = zones[indexPath.row].logo
        
        //if errors in url
        URLSession.shared.dataTask(with: url, completionHandler:{
            (data, response, error) in
                if error != nil {
                    print(error!)
                    return
            }
            //if no errors //to avoid deadlocks
            DispatchQueue.main.async {
                logo.image = UIImage(data: data!)
            }
        }
        ).resume()

        
        return cell
    }
    
    
    //row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedZone = zones[indexPath.row]
        self.performSegue(withIdentifier: "seg_details", sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seg_details" {
            let detailed_view = segue.destination as! ViewController
            detailed_view.zones = selectedZone
        }
    }
    
    func getData(url: URL) {
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let zone = try
                    jsonDecoder.decode(Array<Zone>.self, from: data)
                    self.zones = zone
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }  catch {
                    print("error in JSON decoding!")
                }
                }  else if let error = error {
                    print(error.localizedDescription)
                }
            }
        task.resume()
        }
    
    
    

}
