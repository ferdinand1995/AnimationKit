//
//  AlamofireVC.swift
//  AnimationKit
//
//  Created by Ferdinand on 20/01/22.
//

import UIKit
import Alamofire

// MARK: - CatFact
struct CatFact: Codable {
    var status: Status?
    var id, user, text: String?
    var v: Int?
    var source, updatedAt, type, createdAt: String?
    var deleted, used: Bool?

    enum CodingKeys: String, CodingKey {
        case status
        case id = "_id"
        case user, text
        case v = "__v"
        case source, updatedAt, type, createdAt, deleted, used
    }
}

// MARK: - Status
struct Status: Codable {
    var verified: Bool?
    var feedback: String?
    var sentCount: Int?
}

typealias CatFacts = [CatFact]


class AlamofireVC: UIViewController {

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        getVaccineMenus()
    }

    //MARK: VACCINE FORM
    func getVaccineMenus() {
        let endpoint = "https://cat-fact.herokuapp.com/facts"

        Alamofire.request(endpoint, method: .get).responseJSON { (response) in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let loginRequest = try decoder.decode(CatFacts.self, from: data)
                debugPrint("Result: \(loginRequest)")
            } catch let error {
                print(error)
            }
        }
    }

}
