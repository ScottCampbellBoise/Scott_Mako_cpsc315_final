//
//  Word+CoreDataProperties.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 11/28/20.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var englishWord: String
    @NSManaged public var foriegnWord: String
    @NSManaged public var markedForReview: Bool
    @NSManaged public var mnemonic: String?
    @NSManaged public var timesMissed: Int16
    @NSManaged public var timesCorrect: Int16

}

extension Word : Identifiable {

}
