//
//  Professor.swift
//  TesteDeIntegracao
//
//  Created by Vitor Cheung on 23/08/22.
//

import Foundation
import CoreData
import UIKit

class Professor: NSManagedObject {
    
    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [NSManagedObject] {
        let request : NSFetchRequest<Professor> = Professor.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "idNum", ascending: true)]
    guard let prof = try? viewContext.fetch(request) else {
    return []
    }
    return prof
    }
    
    static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        Professor.fetchAll(viewContext: viewContext).forEach({ viewContext.delete($0) })
    try? viewContext.save()
    }
    
    static func saveProf(name: String, aula: [Aula]) -> Bool{
        guard let entity = NSEntityDescription.entity(forEntityName: "Professor", in: AppDelegate.viewContext) else { return false }
        let prof = NSManagedObject(entity: entity, insertInto: AppDelegate.viewContext)
        prof.setValue(name, forKey: "nome")
        prof.setValue(aula, forKey: "aulas")
        prof.setValue(Int64(fetchAll().count), forKey: "idNum")
        do{
            try AppDelegate.viewContext.save()
            return true
        } catch{
            return false
        }
    
    }
}
