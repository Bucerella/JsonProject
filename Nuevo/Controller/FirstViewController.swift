//
//  ViewController.swift
//  Nuevo
//
//  Created by Buse ERKUŞ on 5.02.2019.
//  Copyright © 2019 Buse ERKUŞ. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.firstJson.count
        }
        else{
            return self.jsons.count
        }
       
    }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    //Eğer seçilen item 0. index ise onu FirstItemCell'e ata değilse JsonCell'e
        if indexPath.section == 0{
            let model = firstJson[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstItemCell") as! FirstItemCell
            cell.setData(model: model)
            cell.selectionStyle = .none
            return cell
        }
            else{
            let model = jsons[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "JsonCell") as! JsonCell
            cell.setData(model: model)
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        //tableview'in otomatik boyutunu belirttik.
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     //0. indexteki itemin seçildiğinde
        if indexPath.section == 0 {
            let model = firstJson[indexPath.row]
            jsId = model.id
            jsTitle = model.title
            jsImage = model.image
            self.performSegue(withIdentifier: "goToDetail", sender: nil)
            
        }else{
            let model = jsons[indexPath.row]
            
            jsId = model.id
            jsTitle = model.title
            jsImage = model.image
            self.performSegue(withIdentifier: "goToDetail", sender: nil)
            //Modelden gelen id,title ve image değişkenlere atandı.

        }
    }
    var jsId = Int()
    var jsTitle = String()
    var jsImage = String()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Geri"
        self.navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "goToDetail" {
            
           let vc = segue.destination as! SecondViewController
           vc.getjsonID = self.jsId
           vc.getjsonImage = self.jsImage
           vc.getJsonTitle = self.jsTitle
        //Seçilen index'teki title ve image'ı SecondViewControllera segue oluşturuldu.
        }
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bottomFloatView.isHidden = false
        
        deleteButton.addTapGestureRecognizer {
            
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // Navigation Bar Gizle
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        // Navigation Bar göster
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    let apikey = "https://jsonplaceholder.typicode.com/photos"
    var jsons : [JsonModel] = []
    var firstJson : [FirstItemModel] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "nuevo_logo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        self.navigationItem.titleView = imageView
        
        setupUI()
        getJsons()
    }
    
      //Json verilerini alma
    func getJsons() {
        let urlJson = URL(string: "https://jsonplaceholder.typicode.com/photos")
        var req = URLRequest(url: urlJson!)
        req.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: req) {
            data, response, error in
            
            if error != nil {
                print("error = \(String(describing:error?.localizedDescription))")
            }
            guard let data = data else {
                
                return
            }
            do{
                let rootJSONArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                if rootJSONArray.count != 0{
                    self.jsons.removeAll()
                }
              
                var i:Int = 0
                
                
                for d in rootJSONArray{
                    
                    let jsonObj = d as! [String:Any]

                    let _id = jsonObj["id"] as! Int
                    let _title = jsonObj["title"] as! String
                    let _image = jsonObj["url"] as! String
                    
                    //Basılan eleman eğer ilk yani 0. index ise bunu FirstItemModel'e at.
                    if i==0{
                        self.firstJson.append(FirstItemModel(id: _id,title: _title, image: _image))
                    }else{
                     self.jsons.append(JsonModel(id: _id,title: _title, image: _image))
                    }
                    i += 1
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch{
                
            }
        }
       dataTask.resume()
    }
    
    //Constraint'in içerdiği alanlar
    let mainView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let bottomFloatView: UIView = {
        let fv = UIView()
        fv.translatesAutoresizingMaskIntoConstraints = false
       
        return fv
    }()
    
    let stackView: UIStackView = {
       
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.spacing = 6.0
        sv.distribution = .fillProportionally
        // iyice unutm
        return sv

    }()
    let whenButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setImage(UIImage(named: "event"), for: UIControl.State.normal)
        btn.tintColor = UIColor(rgb: 0xffffff) // değşebilir
        btn.setTitle("When", for: UIControl.State.normal);
        let spacing = 3.0; // the amount of spacing to appear between image and title
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CGFloat(spacing));
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(spacing), bottom: 0, right: 0);        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let moveButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("Move", for: UIControl.State.normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let deleteButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setImage(UIImage(named: "delete"), for: UIControl.State.normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let moreButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setImage(UIImage(named: "more"), for: UIControl.State.normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // gone view
        bottomFloatView.isHidden = true
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        // gone view
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // visible view
         bottomFloatView.isHidden = false    }
    
//Constraint düzenlemeleri.
    func setupUI() {
        self.view.addSubview(mainView)
        mainView.addSubview(tableView)
        mainView.addSubview(bottomFloatView)
        bottomFloatView.addSubview(stackView)
        stackView.addArrangedSubview(whenButton)
        stackView.addArrangedSubview(moveButton)
        stackView.addArrangedSubview(deleteButton)
        stackView.addArrangedSubview(moreButton)
    
        
        bottomFloatView.layer.cornerRadius = 16.0 // Yuvarlak kenarlık.
        bottomFloatView.backgroundColor = UIColor(rgb: 0x304ffe)
        
        bottomFloatView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.height.equalTo(40)
        }
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(bottomFloatView.snp.top)
            make.bottom.equalTo(bottomFloatView.snp.bottom)
            make.right.equalTo(bottomFloatView.snp.right).offset(-12)
            make.left.equalTo(bottomFloatView.snp.left).offset(12)
        }
        mainView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 16, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(JsonCell.self, forCellReuseIdentifier: "JsonCell")
        tableView.register(FirstItemCell.self, forCellReuseIdentifier: "FirstItemCell")
    }

}

//Diğer item'ler için TableCell
class JsonCell : UITableViewCell {
    
    let mainView : UIView =  {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false //Otomatik Constraint kullanmayacak.
        return view
    }()
    
    let jsonImage : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let title : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10.0, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0  //Satır sayısını kısıtlamamasını sağlamış olduk.
        return label
    }()
    
    func setupUI() {
        addSubview(mainView)
        mainView.addSubview(jsonImage)
        mainView.addSubview(title)
        
        mainView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
        }
        jsonImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.width.equalTo(100)
            make.size.height.equalTo(100)
        }
        let aspectRatioConstraintX = NSLayoutConstraint(item: self.jsonImage,attribute: .height,relatedBy: .equal,toItem: self.jsonImage,attribute: .width,multiplier: (1.0 / 1.0), constant: 0)
        self.jsonImage.addConstraint(aspectRatioConstraintX)
        jsonImage.clipsToBounds = true
        
        title.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(jsonImage.snp.right).offset(5)
        }
     
    }
    func setData(model : JsonModel){
        
        title.text = model.title
        
        if model.image == "not" {
            jsonImage.image = UIImage(named: "notfound")
        }else{
            let imageURL = URL(string: model.image)!
            jsonImage.kf.setImage(with: imageURL)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//İlk item için TableCell
class FirstItemCell : UITableViewCell{
    let mainView : UIView =  {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false //Otomatik Constraint kullanmayacak.
        return view
    }()
   
    let jsonImage : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let title : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        //Satır sayısını kısıtlamamasını sağlamış olduk.
        return label
    }()
    
    func setupUI() {
        addSubview(mainView)
        mainView.addSubview(jsonImage)
        mainView.addSubview(title)
        
        mainView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        jsonImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(jsonImage.snp.width).multipliedBy(0.4)
         
        }
        /***
        let aspectRatioConstraintX = NSLayoutConstraint(item: self.jsonImage,attribute: .height,relatedBy: .equal,toItem: self.jsonImage,attribute: .width,multiplier: (1.0 / 5.0), constant: 0)
        self.jsonImage.addConstraint(aspectRatioConstraintX) ***/
        
        jsonImage.clipsToBounds = true
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(jsonImage.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        
        }
        
    }
    func setData(model : FirstItemModel){
     
        title.text = model.title
        
        if model.image == "not" {
            jsonImage.image = UIImage(named: "notfound")
        }else{
            let imageURL = URL(string: model.image)!
            jsonImage.kf.setImage(with: imageURL)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
