//
//  ViewController.swift
//  ImageLoadingAndCachingApp
//
//  Created by Devesh Pandey on 21/04/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myCollectionView: UICollectionView!
    var imageUrl:String?
    
    var data : APIResponse = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollection()
        ApiCall()
        
    }
    
    func Alert(_ error:ErrorCases){
        
        let alert = UIAlertController(title: "The request couldn't be completed with error \(error.rawValue),Please check your internet connection", message: "", preferredStyle: .alert)
        
         
            let retryButton = UIAlertAction(title: "Retry", style: .default) { (action) in
                self.ApiCall()
            }
            
            let noButton = UIAlertAction(title: "Cancel", style: .default) { (action) in
                let label = UILabel(frame: CGRect(x: 10, y: 10, width: self.myCollectionView.frame.width, height: self.myCollectionView.frame.height ))
                label.numberOfLines = 0
                label.text = "Sorry for the incovenience,please check your internet connection, if the problem persist contact through email at \"pdevesh669@gmail.com\""
                self.myCollectionView.addSubview(label)
            }
            alert.addAction(retryButton)
            alert.addAction(noButton)
            
        self.present(alert, animated: true, completion: nil)
    }

    
    func ApiCall(){
        
        let group = DispatchGroup()
        
        group.enter()
        APICaller.getData { [weak self] result in
            switch result{
            case .success(let response):
                do{
                    self?.data = response
                    
                }
            case .failure(let error):
                do{
                    DispatchQueue.main.async {
                        self?.Alert(error)
                    }
                    //self?.Alert(error)
                }
            }

            group.leave()
        }
        group.notify(queue: .main) {
            self.reloadCollection()
            
        }
    }

}
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func setupCollection(){
        self.view.addSubview(myCollectionView)
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        let nib = UINib(nibName: "MyCollectionViewCell", bundle: nil)
        myCollectionView.register(nib, forCellWithReuseIdentifier: "myCollection")
    }
    
    func reloadCollection(){
        self.myCollectionView.reloadData()
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.myCollectionView.frame.width / 5, height: self.myCollectionView.frame.width / 5)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "myCollection", for: indexPath) as! MyCollectionViewCell
        //= domain + "/" + basePath + "/0/" + key
        let imageUrlString = data[indexPath.row].thumbnail.domain + "/" + data[indexPath.row].thumbnail.basePath + "/0/" +  data[indexPath.row].thumbnail.key.rawValue
        //debugPrint("imageUrlString is \(imageUrlString)")
      //  cell.myCollectionImage.loadImage(fromURL: URL(string: data[indexPath.row].thumbnail.domain + "/" + data[indexPath.row].thumbnail.basePath + "/0/" +  data[indexPath.row].thumbnail.key.rawValue) ?? URL(fileURLWithPath: ""), placeholderImage: "placeholderImage")
        cell.myCollectionImage.loadImage2(fromURL: imageUrlString, placeholderImage: "placeholderImage")
        
        return cell
    }
    
    
  
}

