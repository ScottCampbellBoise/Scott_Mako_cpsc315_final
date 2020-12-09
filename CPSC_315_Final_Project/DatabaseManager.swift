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
    
    static func saveContext() {
        do {
            try DatabaseManager.context.save()
        } catch {
            print("Error saving the Context: \(error)")
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
    
    // MARK: Load words from Studysets
    
    static func fetchWords(fromStudysets sets: [StudySet]) -> [Word]? {
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        // Generate a string predicate to get all words in those sets
        var pred = ""
        var argumentArray = [String]()
        for set in sets {
            pred.append("ANY studysets.name =[cd] %@ OR ")
            argumentArray.append(set.name)
        }
        // Remove the last OR from the predicate
        pred = String(pred.dropLast(4))
        // Create a predicate for the search
        let studysetsPredicate = NSPredicate(format: pred, argumentArray: argumentArray)
        // Attach the predicate to the request
        request.predicate = studysetsPredicate
        // Attempt the search
        do {
            let results: [Word] = try context.fetch(request)
            return results
        }
        catch {
            print("Failed to find all words for the specified studysets! \(error)")
            return nil
        }
    }
    
    
    // MARK: Miscellaneous
    
    static func getMasterStudySet() -> StudySet? {
        let request: NSFetchRequest<StudySet> = StudySet.fetchRequest()
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", "Master")
        request.predicate = predicate
        
        do {
            let masterSets: [StudySet] = try DatabaseManager.context.fetch(request)
            print("Successfully found the master study set!")
            return masterSets[0]
        }
        catch {
            print("Error loading words \(error)")
            return nil
        }
    }
    
}
