//
//  ViewController.swift
//  AnimationKit
//
//  Created by Ferdinand on 20/12/21.
//

import UIKit

// MARK: - MainMenuElement
struct MainMenuElement: Codable {
    let title: String
    let type: String
}

typealias MainMenu = [MainMenuElement]

class MainVC: UICollectionViewController {

    var data = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(cellWithClass: MenuCell.self)
        populateMenu()
    }
    
    private func populateMenu() {
        guard let path = Bundle.main.path(forResource: "main_menu", ofType: "json") else { return }
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
            if let mainMenu = try? JSONDecoder().decode(MainMenu.self, from: jsonData){
                data.append(contentsOf: mainMenu)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let verticalCell = data[indexPath.item] as? MainMenuElement, verticalCell.type == "vertical" {
            let cell = collectionView.dequeueReusableCell(withClass: MenuCell.self, for: indexPath)
            cell.titleLabel.text = verticalCell.title
            cell.layoutIfNeeded()
            cell.backgroundCardView.dropShadowCell()
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let verticalCell = data[indexPath.item] as? MainMenuElement, verticalCell.type == "vertical" {
            guard let cell = collectionView.cellForItem(at: indexPath) as? MenuCell else { return }
            cell.backgroundCardView.isUserInteractionEnabled = true
            cell.backgroundCardView.showAnimation {
                if verticalCell.title == "To Do" {
                    self.navigationController?.pushViewController(ToDoVC(), animated: true)
                } else if verticalCell.title == "Hacker News" {
                    self.navigationController?.pushViewController(HackerNewsVC(), animated: true)
                } else {
                    self.navigationController?.pushViewController(AnimatedTableVC(), animated: true)
                }
            }
        }
    }
}

extension MainVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
