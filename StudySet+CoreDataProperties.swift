//
//  StudySet+CoreDataProperties.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 12/1/20.
//
//

import Foundation
import CoreData


extension StudySet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudySet> {
        return NSFetchRequest<StudySet>(entityName: "StudySet")
    }

    @NSManaged public var name: String?
    @NSManaged public var newRelationship: NSSet?

}

// MARK: Generated accessors for newRelationship
extension StudySet {

    @objc(addNewRelationshipObject:)
    @NSManaged public func addToNewRelationship(_ value: Word)

    @objc(removeNewRelationshipObject:)
    @NSManaged public func removeFromNewRelationship(_ value: Word)

    @objc(addNewRelationship:)
    @NSManaged public func addToNewRelationship(_ values: NSSet)

    @objc(removeNewRelationship:)
    @NSManaged public func removeFromNewRelationship(_ values: NSSet)

}

extension StudySet : Identifiable {

}
