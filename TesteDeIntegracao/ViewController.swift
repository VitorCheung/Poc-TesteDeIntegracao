//
//  ViewController.swift
//  TesteDeIntegracao
//
//  Created by Vitor Cheung on 23/08/22.
//

import UIKit
import CoreData
import CloudKit

class ViewController: UIViewController {
    
    var share:CKShare?

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var text: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func shared(_ sender: Any) {
        let coreStack = CoreDataStack.shared
        let prof = Professor()
        prof.nome = text.text
        let aula = Aula()
        aula.nome = "matematica"
        prof.aulas = [aula]
        
        Task.init {
            share = try? await coreStack.createShare(prof)
            guard let share = share else { return  }
            present(controllerShare(share: share), animated: true)
        }
        
    }
    
    @IBAction func save(_ sender: Any) {
        guard let texto = text.text else { return }
        let aula = Aula()
        aula.nome = "matematica"
        let aula1 = Aula()
        aula1.nome = "portugues"
        if Professor.saveProf(name: texto, aula:[aula,aula1] ){
            refreshView()
        }
    }
    
    func controllerShare(share:CKShare) -> UICloudSharingController{
        let coreStack = CoreDataStack.shared
        let sharingController = UICloudSharingController(
            share: share,
            container: coreStack.ckContainer
        )
        sharingController.availablePermissions = [.allowReadOnly, .allowPrivate]
        sharingController.modalPresentationStyle = .formSheet
        return sharingController
    }
    
    func shareData(){
        let container = AppDelegate.persistentContainer
        let cloudSharingController = UICloudSharingController { (controller, completion: @escaping (CKShare?, CKContainer?, Error?) -> Void) in
            container.share([], to: nil) { objId, share, container, erro in
                completion(share, container, erro)
            }
        }
        present(cloudSharingController, animated: true)
    }
    
    func refreshView(){
        let prof = Professor.fetchAll() as? [Professor]
        guard let aulas = prof?.last?.aulas?.allObjects as? Array<Aula> else { return }
        label.text = aulas[0].nome
    }
    
    func lastProfessor() {
        let prof = Professor.fetchAll() as? [Professor]
        guard let aulas = prof?.last?.aulas?.allObjects as? Array<Aula> else { return }
    }
    
}

