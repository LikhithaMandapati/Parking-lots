//
//  ViewController.swift
//  Exercise5_Mandapati_Likhitha
//
//  Created by student on 10/8/22.
//

import UIKit

class ViewController: UIViewController {

    var zones = Zone()
    
    @IBOutlet weak var mapImage: UIImageView!
    
    @IBOutlet weak var zoneNameImage: UIImageView!
    
    @IBOutlet weak var lotsLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        URLSession.shared.dataTask(with: zones.map, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.mapImage.image = UIImage(data: data!)
            }
        }).resume()
            
        URLSession.shared.dataTask(with: zones.logo, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.zoneNameImage.image = UIImage(data: data!)
            }
        }).resume()
        
        self.lotsLabel.text = "Lots: \(self.zones.lots)"
        self.descriptionLabel.text = self.zones.about

}


}
