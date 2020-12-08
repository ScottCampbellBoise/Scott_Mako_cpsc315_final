//
//  DatabaseManager.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 12/7/20.
//

// This class handles all the code for requesting and saving the different data types for this project

import Foundation
import CoreData
import UIKit

class DatabaseManager {
    
    // We need a reference to the context
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: Save to Database
    
    static func saveWords() {
        do {
            try context.save()
        } catch {
            print("Error saving the Words: \(error)")
        }
    }
    
    static func saveStudySets() {
        // We need to save the context
        do {
            try DatabaseManager.context.save()
        } catch {
            print("Error saving the Study Sets: \(error)")
        }
    }
    
    // MARK: Load from Database
    
    static func loadWords(withPredicate predicate: NSPredicate? = nil) -> [Word]? {

        let request: NSFetchRequest<Word> = Word.fetchRequest()
        let englishSortDescriptor = NSSortDescriptor(keyPath: \Word.englishWord, ascending: true)
        let foriegnSortDescriptor = NSSortDescriptor(keyPath: \Word.foriegnWord, ascending: true)
        request.sortDescriptors = [foriegnSortDescriptor, englishSortDescriptor]
        if let pred = predicate { request.predicate = pred }
        
        var words: [Word]? = nil
        do {
            words = try context.fetch(request)
        }
        catch {
            print("Error loading words \(error)")
        }
        
        return words
    }
    
    static func loadStudySets(withPredicate predicate: NSPredicate? = nil) -> [StudySet]? {
        let request: NSFetchRequest<StudySet> = StudySet.fetchRequest()
        if let pred = predicate { request.predicate = pred }
        
        var studysets: [StudySet]? = nil
        do {
            studysets = try DatabaseManager.context.fetch(request)
        }
        catch {
            print("Error loading studysets \(error)")
        }
        return studysets
    }
    
    
    // MARK: Miscellaneous
    
    static func testCoreDataRelations() {
        print("Testing Core Data Relations")
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        let studysetPredicate = NSPredicate(format: "ANY studysets.name =[cd] %@", "Master")
        request.predicate = studysetPredicate
        
        do {
            let results: [Word] = try context.fetch(request)
            print("Found \(results.count) Results!")
            for word in results {
                print("    \(word.foriegnWord) - \(word.englishWord)")
            }
        }
        catch {
            print("Relational Test Failed! \(error)")
           
        }
    }
    
    static func getMasterStudySet() -> StudySet? {
        let request: NSFetchRequest<StudySet> = StudySet.fetchRequest()
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", "Master")
        request.predicate = predicate
        
        do {
            let masterSets: [StudySet] = try DatabaseManager.context.fetch(request)
            return masterSets[0]
        }
        catch {
            print("Error loading words \(error)")
            return nil
        }
    }
    
}
