//
//  RealmManager.swift
//  GoolKeeperTracker
//
//  Created by Bruno Antoninho on 30/10/2022.
//

import Foundation
import RealmSwift
import SwiftyBeaver

class RealmManager {
    
    private(set) var realm: Realm!
    var notificationToken: NotificationToken?

    private static var sharedRealmManager: RealmManager = {
        let manager = RealmManager()
        return manager
    }()

    class func shared() -> RealmManager {
        return sharedRealmManager
    }

    init() {
        do {
            realm = try Realm()
            print("Realm fileURL: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        } catch let error {
            log.error("Error creating database.")
            fatalError(error.localizedDescription)
        }
    }

    func object<Element: Object>(ofType type: Element.Type, forPrimaryKey primaryKey: Any) -> Element? {
        return realm.object(ofType: type, forPrimaryKey: primaryKey)
    }

    func objects<Element: Object>(type: Element.Type) -> Results<Element>? {
        return realm.objects(type)
    }

    func save(_ model: Object) {
        DispatchQueue.main.async {
            do {
                try self.realm.write {
                    self.realm.add(model, update: .modified)
                }
            } catch let error as NSError {
                log.error("Error saving \(model.self). Database Error: \(error.debugDescription)")
            }
        }
    }

    func save(_ models: [Object]) {
        DispatchQueue.main.async {
            do {
                try self.realm.write {
                    self.realm.add(models, update: .modified)
                }
            } catch let error as NSError {
                log.error("Error saving \(models.self). Database Error: \(error.debugDescription)")
            }
        }
    }

    func delete(_ model: Object) {
        DispatchQueue.main.async {
            do {
                try self.realm.write {
                    self.realm.delete(model)
                }
            } catch let error as NSError {
                log.error("Error saving \(model.self). Database Error: \(error.debugDescription)")
            }
        }
    }

    func delete(_ models: [Object]) {
        DispatchQueue.main.async {
            do {
                try self.realm.write {
                    self.realm.delete(models)
                }
            } catch let error as NSError {
                log.error("Error saving \(models.self). Database Error: \(error.debugDescription)")
            }
        }
    }

    func deleteAll() {
        DispatchQueue.main.async {
            do {
                try self.realm.write {
                    self.realm.deleteAll()
                }
            } catch let error as NSError {
                log.error("Error deleting all database records. Database Error: \(error.debugDescription)")
            }
        }
    }

    func safeWrite(_ block: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            do {
                try self.realm.write {
                    block()
                }
            } catch let error as NSError {
                log.error("Error writing in database. Database Error: \(error.debugDescription)")
            }
        }
    }
    
}
