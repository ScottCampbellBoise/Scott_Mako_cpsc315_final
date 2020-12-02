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

    @NSManaged public var englishWord: String
    @NSManaged public var foriegnWord: String
    @NSManaged public var markedForReview: Bool
    @NSManaged public var mnemonic: String?
    @NSManaged public var timesCorrect: Int16
    @NSManaged public var timesMissed: Int16
    @NSManaged public var studysets: NSSet?

}

// MARK: Generated accessors for studysets
extension Word {

    @objc(addStudysetsObject:)
    @NSManaged public func addToStudysets(_ value: StudySet)

    @objc(removeStudysetsObject:)
    @NSManaged public func removeFromStudysets(_ value: StudySet)

    @objc(addStudysets:)
    @NSManaged public func addToStudysets(_ values: NSSet)

    @objc(removeStudysets:)
    @NSManaged public func removeFromStudysets(_ values: NSSet)

}

extension Word : Identifiable {
    
    func addWordToStudySet(studyset: StudySet) {
        let set = self.mutableSetValue(forKey: "studysets")
        set.add(studyset)
        studysets = set
    }
    
}
