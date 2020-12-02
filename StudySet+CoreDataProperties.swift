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

    @NSManaged public var name: String
    @NSManaged public var words: NSSet?

}

// MARK: Generated accessors for words
extension StudySet {

    @objc(addWordsObject:)
    @NSManaged public func addToWords(_ value: Word)

    @objc(removeWordsObject:)
    @NSManaged public func removeFromWords(_ value: Word)

    @objc(addWords:)
    @NSManaged public func addToWords(_ values: NSSet)

    @objc(removeWords:)
    @NSManaged public func removeFromWords(_ values: NSSet)

}

extension StudySet : Identifiable {

}
