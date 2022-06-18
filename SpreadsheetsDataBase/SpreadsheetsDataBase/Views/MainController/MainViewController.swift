//
//  ViewController.swift
//  SpreadsheetsDataBase
//
//  Created by Fedii Ihor on 18.06.2022.
//

import UIKit

fileprivate struct Constant {
    static let title: String = "main folder"
    static let numberOfSection: Int = 2
    static let widecellHeight: CGFloat = 60
    static let numberOfitemInRow: CGFloat = 3
    static let minimumSpasing: CGFloat = 2
    static let cellProptional: CGFloat = 1.3
}

class MainViewController: UIViewController {
    
    var collectionView: UICollectionView?
    let network = DataBase(api: "zcofu8bnd3ldl")
    
    var isCollectionViewState = false {
        didSet {
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseIn) {
                self.collectionView?.reloadData()
            }
 self.collectionView?.reloadData()
        }
    }
    
    var dataSourse: Sheet = [] {
        didSet {
            //print(dataSourse)
            collectionView?.reloadData()
        }
    }
    
    @IBOutlet weak var switchStateButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constant.title
        
        network.obtainSheet { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sheet):
                    self.dataSourse = sheet.getMainLayerOfSheet()
                case .failure(let error):
                    self.someWrongAlert(self, "Atension", error.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCollectionView()
    }
    
    @IBAction func switchCollectionViewState(_ sender: UIBarButtonItem) {
        isCollectionViewState.toggle()
    }
    
    

}

private extension MainViewController {
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 0,
                                    left: Constant.minimumSpasing,
                                    bottom: Constant.minimumSpasing,
                                    right:Constant.minimumSpasing)
        layout.minimumLineSpacing = Constant.minimumSpasing
        
        collectionView = UICollectionView(frame: view.bounds,
                                               collectionViewLayout: layout)
        
        collectionView?.backgroundColor = .systemBackground
        view.addSubview(collectionView!)
        collectionView?.register(SquareCollectionViewCell.nib(),
                                 forCellWithReuseIdentifier: SquareCollectionViewCell.id)
        collectionView?.register(WideCollectionViewCell.nib(),
                                 forCellWithReuseIdentifier: WideCollectionViewCell.id)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
    }
    
    
}

extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constant.numberOfSection
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // return dataSourse.count
        
        switch isCollectionViewState {
        case false:
            switchStateButton.image = UIImage(systemName: "rectangle.grid.2x2")
            if section == 0 {
                return 0
            }else{
                return dataSourse.count
            }
          
        case true:
            switchStateButton.image = UIImage(systemName: "list.dash")
            if section == 0 {
                return dataSourse.count
            }else{
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = dataSourse[indexPath.item]
        switch indexPath.section {
        case 0 :
         guard let wideCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WideCollectionViewCell.id,
            for: indexPath) as? WideCollectionViewCell else {
             return UICollectionViewCell()
         }
            
            wideCell.setupCell(by: item)
            return wideCell
        default:
            guard let squareCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SquareCollectionViewCell.id,
                for: indexPath) as? SquareCollectionViewCell else {
                return UICollectionViewCell()
            }
            squareCell.setupCell(by: item)
            return squareCell
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print(indexPath.item)
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sqWidth = view.bounds.width/Constant.numberOfitemInRow
        let sqHeight = sqWidth*Constant.cellProptional
        
        switch indexPath.section {
        case 0: return CGSize(width: view.bounds.size.width - Constant.minimumSpasing,
                              height: Constant.widecellHeight)
        default: return CGSize(width:sqWidth - (Constant.minimumSpasing+1),
                               height: sqHeight )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.minimumSpasing
    }
}
