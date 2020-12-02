//
//  Word+CoreDataProperties.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 12/1/20.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var englishWord: String?
    @NSManaged public var foriegnWord: String?
    @NSManaged public var markedForReview: Bool
    @NSManaged public var mnemonic: String?
    @NSManaged public var timesCorrect: Int16
    @NSManaged public var timesMissed: Int16
    @NSManaged public var newRelationship: NSSet?

}

// MARK: Generated accessors for newRelationship
extension Word {

    @objc(addNewRelationshipObject:)
    @NSManaged public func addToNewRelationship(_ value: StudySet)

    @objc(removeNewRelationshipObject:)
    @NSManaged public func removeFromNewRelationship(_ value: StudySet)

    @objc(addNewRelationship:)
    @NSManaged public func addToNewRelationship(_ values: NSSet)

    @objc(removeNewRelationship:)
    @NSManaged public func removeFromNewRelationship(_ values: NSSet)

}

extension Word : Identifiable {

}
