//
//  ViewController.swift
//  SpreadsheetsDataBase
//
//  Created by Fedii Ihor on 18.06.2022.
//

import UIKit

//MARK: - Constants
fileprivate struct Constant {
    static let stateKey = "isCollectionViewState"
    static let apiKey = "zcofu8bnd3ldl"
    static let numberOfSection: Int = 2
    static let widecellHeight: CGFloat = 60
    static let numberOfitemInRow: CGFloat = 3
    static let minimumSpasing: CGFloat = 2
    static let cellProptional: CGFloat = 1.3
}

class MainViewController: UIViewController, Storybordable {
    
    //MARK: - properties
    weak var coordinator: AppCoordinator?
    let network = DataBase(api: Constant.apiKey)
    //all data of google spreadsheet
    var dataBace: Sheet = []
    let userDefault = UserDefaults.standard
    var collectionView: UICollectionView!
    var isCollectionViewState = false {
        didSet {
            userDefault.set(isCollectionViewState, forKey: Constant.stateKey)
            collectionView?.reloadData()
            
        }
    }
    var dataSourse: Sheet? {
        didSet { collectionView?.reloadData() }
    }
    
    //MARK: - @IBOutlets
    @IBOutlet weak var switchStateButton: UIBarButtonItem!
    
    
    //MARK: - life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        if dataSourse == nil {
            title = "Main folder"
            network.obtainSheet { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let sheet):
                        self.dataBace = sheet
                        self.dataSourse = sheet.getMainLayerOfSheet()
                    case .failure(let error):
                        self.someWrongAlert(self, "Atension", error.localizedDescription)
                    }
                }
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isCollectionViewState = userDefault.bool(forKey: Constant.stateKey)
    }
    
    //MARK: - @IBActions
    @IBAction func switchCollectionViewState(_ sender: UIBarButtonItem) {
        isCollectionViewState.toggle()
    }
 
}

//MARK: -  private funcs
private extension MainViewController {
//MARK: - setupCollectionView()
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: Constant.minimumSpasing,
                                           bottom: Constant.minimumSpasing,
                                           right: Constant.minimumSpasing)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.register(SquareCollectionViewCell.nib(),
                                 forCellWithReuseIdentifier: SquareCollectionViewCell.id)
        collectionView.register(WideCollectionViewCell.nib(),
                                 forCellWithReuseIdentifier: WideCollectionViewCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
    }
}

//MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constant.numberOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch isCollectionViewState {
        case false:
            switchStateButton.image = UIImage(systemName: "rectangle.grid.2x2")
            if section == 0 {
                return 0
            }else{
                return dataSourse?.count ?? 0
            }
        case true:
            switchStateButton.image = UIImage(systemName: "list.dash")
            if section == 0 {
                return dataSourse?.count ?? 0
            }else{
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = dataSourse?[indexPath.item]
        switch indexPath.section {
        case 0 :
            guard let wideCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WideCollectionViewCell.id,
                for: indexPath) as? WideCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            wideCell.setupCell(by: item!)
            return wideCell
        default:
            guard let squareCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SquareCollectionViewCell.id,
                for: indexPath) as? SquareCollectionViewCell else {
                return UICollectionViewCell()
            }
            squareCell.setupCell(by: item!)
            return squareCell
        }
    }
}

//MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = dataSourse?[indexPath.item] else { return }
        collectionView.deselectItem(at: indexPath, animated: true)
        if item.type == .d {
            let title = String(item.content.split(separator: ".").first ?? "File")
            let newData = dataBace.getChildItems(by: item.uuid)
            coordinator?.goToMainVC(title: title,
                                    datasourse: newData,
                                    dataBase: dataBace)
        } else {
            coordinator?.goToDetail(item)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sqWidth = view.bounds.width/Constant.numberOfitemInRow
        let sqHeight = sqWidth*Constant.cellProptional
        
        switch indexPath.section {
        case 0:  return CGSize(width: view.bounds.size.width - Constant.minimumSpasing,
                               height: Constant.widecellHeight)
        default: return CGSize(width:sqWidth - (Constant.minimumSpasing+1),
                               height: sqHeight )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.minimumSpasing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.minimumSpasing
    }
    
}
