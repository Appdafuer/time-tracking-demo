//
//  PersistratingUserContent.swift
//  TimeTracker
//
//  Created by Frederic Forster on 14/03/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation

class PersistratingUserContent {
    
    let defaults = UserDefaults.standard    
    
    //MARK: Save
    func save(data: [Project?]) {
        let userData = NSKeyedArchiver.archivedData(withRootObject: [Project?]())
        defaults.set(userData, forKey: "Selected Projects")
        defaults.synchronize()
    }
    
    //MARK: Load
    func load() -> [Project?]{
        guard defaults.array(forKey: "Selected Projects") != nil else {return [nil, nil, nil, nil]}
        let loadedData = defaults.data(forKey: "SelectedProjects")
        let projects = NSKeyedUnarchiver.unarchiveObject(with: loadedData!) as! [Project?]
        print(projects[0]?.description ?? "Failed")
        return projects
    }
    
}
