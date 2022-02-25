//
//  LyricsViewController.swift
//  LyricsApp
//
//  Created by Iker Gutierrez.
//

import UIKit

class LyricsViewController: UIViewController {

    
    @IBOutlet var lyricsLabel: UILabel!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    var songLoaded: Bool = false
    var song: Song?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButtonState(newState: false)
        checkSongSavedStatus()
        if let song = song {
            print("Song loaded")
            print(song.artist)
            updateUI(with: song.lyrics)
        } else {
            print("no song loaded")
            Task.init {
                do {
                    LyricsController.shared.lyricsString = try await LyricsController.shared.fetchLyrics()
                    updateUI(with: cleanLyricsText(lyricsText:  LyricsController.shared.lyricsString))
                    checkSongSavedStatus()
                } catch {
                    displayError(error, title: "Failed to get the lyrics for the requested song.")
                }
        }
            
        
        
//        if(!songLoaded){
//
//            Task.init {
//                do {
//                    LyricsController.shared.lyricsString = try await LyricsController.shared.fetchLyrics()
//                    updateUI(with: cleanLyricsText(lyricsText:  LyricsController.shared.lyricsString))
//                    checkSongSavedStatus()
//                } catch {
//                    displayError(error, title: "Failed to get the lyrics for the requested song.")
//                }
//            }
//        } else {
//            print("Song loaded")
//            updateUI(with: cleanLyricsText(lyricsText: song!.lyrics))
//        }
        }
        
    }
    

    func updateUI(with lyrics : String){
        lyricsLabel.text = lyrics
    }
    
    func checkSongSavedStatus(){
        
        updateSaveButtonState(newState: true)
        if song == nil{
            print("Song es nil")
            songLoaded = false
            saveButton.title = "Save"
            return
        }
        print("Song no es nil")
        songLoaded = true
        saveButton.title = "Unsave"
        
    }
    
    func updateSaveButtonState (newState state : Bool){
        saveButton.isEnabled = state
    }
    
    func displayUIError(){
        updateUI(with: "Lyrics not found")
    }

    func displayError(_ error: Error, title: String){
        guard let _ = viewIfLoaded?.window else { return }
                
        let alert = UIAlertController(title: title, message: "\(LyricsController.shared.songTitle) from \(LyricsController.shared.artistName) not found.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {(alert: UIAlertAction!) in
            DispatchQueue.main.async( execute: {
                self.popThisView()
            })
        }))
        self.present(alert, animated: true, completion: nil)
        displayUIError()
        
    }
                        
    func popThisView() {
        self.dismiss(animated: false, completion: nil)
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    func cleanLyricsText(lyricsText lyrics : String) -> String{
        var cleandedlyrics: String = ""
        let removeCharacters: String = "Paroles de la chanson \(LyricsController.shared.songTitle.lowercased().capitalizingFirstLetter()) par \(LyricsController.shared.artistName.lowercased().capitalizingFirstLetter())"
        
        cleandedlyrics = lyrics.replacingOccurrences(of: removeCharacters, with: "")
        
        // Debug use
//        print(lyrics)
        
//        var charactersToDelete: Int = 22
//
//        charactersToDelete = charactersToDelete + LyricsController.shared.songTitle.count + LyricsController.shared.artistName.count + 5
        
        return cleandedlyrics
    }
    
    

    @IBAction func saveSongButtonPressed(_ sender: UIBarButtonItem) {
        print ("Song lyric saved")
    }


    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        popThisView()
    }
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    
    
}
