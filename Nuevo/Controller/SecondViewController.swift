//
//  SecondViewController.swift
//  Nuevo
//
//  Created by Buse ERKUŞ on 5.02.2019.
//  Copyright © 2019 Buse ERKUŞ. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class SecondViewController: UIViewController {
   
    let mainView: UIView = {
       
        let mv = UIView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        return mv
    }()
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        
        return iv
    }()
    let titleLabel: UILabel = {
       let title = UILabel()
       title.translatesAutoresizingMaskIntoConstraints = false
       title.numberOfLines = 0
       title.font = UIFont.monospacedDigitSystemFont(ofSize: 20.0, weight: UIFont.Weight.bold)
       title.textAlignment = .center
       return title
    }()
    let bodyLabel: UILabel = {
       let title = UILabel()
       title.translatesAutoresizingMaskIntoConstraints = false
       title.numberOfLines = 0
       title.font = UIFont.monospacedDigitSystemFont(ofSize: 20.0, weight: UIFont.Weight.bold)
       title.textAlignment = .center
       return title
    }()
    let bottomView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
        view.alpha = 0.7
        return view
    }()
    
    func setupUI() {
        self.view.addSubview(mainView)
        mainView.addSubview(imageView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(bottomView)
        mainView.addSubview(bodyLabel)
        
        mainView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(mainView.snp.top).offset(55)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        self.imageView.clipsToBounds = true
        
//        let aspectRatioConstraintX = NSLayoutConstraint(item: self.imageView,attribute: .height,relatedBy: .equal,toItem: self.imageView,attribute: .width,multiplier: (4.0 / 9.0), constant: 0)
//        self.imageView.addConstraint(aspectRatioConstraintX)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
        }
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.width.equalToSuperview()
            make.height.equalTo(1)
            
        }
        bodyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    var getjsonID = Int()
    var getjsonImage = String()
    var getJsonTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getJsonDetail()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getJsonDetail(){
        let url = URL(string: "https://jsonplaceholder.typicode.com/comments/\(self.getjsonID)")!
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: req) { (data, response, error) in
            
            if error != nil {
                print("Error")
            }
            guard let data = data else{
                return
            }
            
            do{
                let rootJSONArray = try JSONSerialization.jsonObject(with: data
                    , options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,AnyObject>
               
                let _body = rootJSONArray["body"] as! String

                DispatchQueue.main.async {
                    self.bodyLabel.text = _body
                    let imageURL = URL(string: self.getjsonImage)!
                    self.imageView.kf.setImage(with: imageURL)
                    self.titleLabel.text = self.getJsonTitle
                }
            }catch{
            
            }
        }
    dataTask.resume()
    }
}

