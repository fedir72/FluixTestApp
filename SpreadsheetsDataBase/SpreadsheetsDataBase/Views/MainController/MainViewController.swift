//
//  ViewController.swift
//  SpreadsheetsDataBase
//
//  Created by Fedii Ihor on 18.06.2022.
//

import UIKit
import SnapKit

//MARK: - Constants
fileprivate struct Constant {
    static let stateKey = "isCollectionViewState"
    static let apiKey = "i8s3hscsk4ajd"
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
    
    var currentParentID = ""
    let userDefault = UserDefaults.standard
    lazy var tableviewHeight: CGFloat = view.bounds.height-85
    var tableview: UITableView!
    var collectionView: UICollectionView!
    
    var listState = true {
        didSet {
            userDefault.set(listState, forKey: Constant.stateKey)
            switchListHeight()
            tableview.snp.updateConstraints {
                $0.height.equalTo(listState ? tableviewHeight : 0)
            }
            collectionView.snp.updateConstraints {
                $0.height.equalTo(listState ? 0 : tableviewHeight)
            }
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }completion: { _ in
                self.tableview.reloadData()
                self.collectionView.reloadData()
            
            }
        }
    }
    var dataSourse: Sheet? {
        didSet {
            tableview?.reloadData()
            collectionView?.reloadData()
        }
    }
    
    //MARK: - @IBOutlets
    @IBOutlet private weak var switchStateButton: UIBarButtonItem!
    @IBOutlet private weak var bottomStack: UIStackView!
    @IBOutlet private weak var newFolderButton: UIButton!
    @IBOutlet private weak var newFileButton: UIButton!
    
    //MARK: - life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupCollectionView()
        setupConstraints()
        
        if dataSourse == nil {
            title = "Main folder"
            self.getDataForDataSourse()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listState = userDefault.bool(forKey: Constant.stateKey)
    }
    
    //MARK: - @IBActions
    //toggle the collectionview state
    @IBAction func switchCollectionViewState(_ sender: UIBarButtonItem) {
        listState.toggle()
    }
    

    
    @IBAction func createNewFile(_ sender: UIButton) {
        self.createNewSheetCell(parentId: self.currentParentID,
                                type: sender.tag == 0 ? .d : .f) { result in
            switch result {
            case .success(_):
                self.getDataForDataSourse()
            case .failure(let error):
                self.someWrongAlert(self, "atension", error.localizedDescription)
            }
          }
        }
}

//MARK: -  private funcs
private extension MainViewController {
    
    func switchListHeight() {
        switch listState {
        case true:
            switchStateButton.image = UIImage(systemName: "rectangle.grid.2x2")
        case false:
            switchStateButton.image = UIImage(systemName: "list.dash")
        }
    }
    
    //MARK: - didtap cellAction func
    func didTapCellAction(item: SheetItem,completion: @escaping () -> Void ) {
        let alert = UIAlertController(title: "Atension", message: "choise the action", preferredStyle: .alert)
        alert.addAction(.init(title: "delete the information", style: .destructive) { [self] _ in
            
            self.network.deleteCell(by: item.uuid) { result in
                DispatchQueue.main.async {
                    switch result {
                
                    case .success(let responce):
                        print("deleted",responce.deleted)
                        completion()
                    case .failure(let error):
                        
                        print("err",error.localizedDescription)
                    }
                }
            }
        })
        alert.addAction(.init(title: "cancel", style: .destructive))
        alert.addAction(.init(title: "open", style: .default) { _ in
            if item.type == .d {
                let title = String(item.content.split(separator: ".").first ?? "File")
                let newData = self.dataBace.getChildItems(by: item.uuid)
                self.coordinator?.goToMainVC(currentParentId: item.uuid,
                                        title: title,
                                        datasourse: newData,
                                        dataBase: self.dataBace)
            } else {
                self.coordinator?.goToDetail(item)
            }
        })
        present(alert, animated: true)
    }
  //MARK: - setupConstraints()
    func setupConstraints() {
        tableview.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalTo(tableviewHeight)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomStack.snp.top)
            make.height.equalTo(0)
            make.top.equalTo(tableview.snp.bottom)
        }
    }
    
 //MARK: - setupTableView()
    func setupTableView() {
        tableview = UITableView()
        tableview.alwaysBounceVertical = true
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(TableCell.nib(), forCellReuseIdentifier: TableCell.id)
        view.addSubview(tableview)
    }
    
    //MARK: - setupCollectionView()
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: Constant.minimumSpasing,
                                           bottom: Constant.minimumSpasing,
                                           right: Constant.minimumSpasing)
        layout.minimumInteritemSpacing = Constant.minimumSpasing
        layout.minimumLineSpacing = Constant.minimumSpasing
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.register(SquareCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: SquareCollectionViewCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(tableview.snp.bottom)
        }
        
        
    }
    
    //MARK: - createNewSheetCell
   func createNewSheetCell( parentId: String,
                            type: TypeOfCell ,
                            completion: @escaping (Result<Int,SheetError>) -> Void ) {
        
        let alert = UIAlertController(title: "Enter new name of item",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "enter content" }
        alert.addAction(.init(title: "cancel", style: .destructive, handler: nil))
        alert.addAction(.init(title: "save", style: .default, handler: { action in
            guard let content = alert.textFields?.first?.text,
                     !content.isEmpty else {
                self.someWrongAlert(self, "atension", "please enter the text")
                return
            }
            
           // let content = alert.textFields?.first!.text ?? "no value"
            let id = UUID().uuidString
            let item = SheetItem(uuid: id,
                                 parentId: self.currentParentID,
                                 type: type, content: content)
            
            self.network.postSheetItem(item:item) { result in
                completion(result)
            }
           
        }))
        present(alert, animated: true)
    }
    
    func getDataForDataSourse() {
        network.obtainSheet { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sheet):
                    self.dataBace = sheet
                    self.dataSourse = sheet.getFilteredSheet(by: self.currentParentID)
                case .failure(let error):
                    self.someWrongAlert(self, "Atension", error.localizedDescription)
                }
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return dataSourse?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSourse?[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.id,
                                                       for: indexPath) as? TableCell else {
            return UITableViewCell()
        }
        cell.setupCell(by: item!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
}

//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSourse?[indexPath.item] else { return }
        self.didTapCellAction(item: item) {
            self.tableview.deleteRows(at: [indexPath], with: .fade)
        }
    }
}


//MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return dataSourse?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataSourse?[indexPath.item]
            guard let squareCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SquareCollectionViewCell.id,
                for: indexPath) as? SquareCollectionViewCell else {
                return UICollectionViewCell()
            }
            squareCell.setupCell(by: item!)
            return squareCell
    }
}

//MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = dataSourse?[indexPath.item] else { return }
        collectionView.deselectItem(at: indexPath, animated: true)
        self.didTapCellAction(item: item) {
            collectionView.deleteItems(at: [indexPath])
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
      let sqWidth = view.bounds.width/Constant.numberOfitemInRow
      let sqHeight = sqWidth*Constant.cellProptional
      return CGSize(width:sqWidth - (Constant.minimumSpasing+1),
                    height: sqHeight )
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return Constant.minimumSpasing
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return Constant.minimumSpasing
//    }
//
}
