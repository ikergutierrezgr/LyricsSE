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
    
    var song: Song?
    
    var songsLocallyStored = [Song] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSavedSongs()
        updateSaveButtonState(newState: false)
        if let song = song {
            print("Song loaded")
            print(song.artist)
            updateUI(with: song.lyrics)
            checkSongSavedStatus()
        } else {
            print("no song loaded")
            var tempSong = Song(artist: LyricsController.shared.artistName, title: LyricsController.shared.songTitle, lyrics: LyricsController.shared.lyricsString)
            if (checkSongSaveStatus(songToCheck: tempSong)) {
                print("But song is saved in system")
                var firstIndex = songsLocallyStored.firstIndex(of: tempSong)
                tempSong.lyrics = songsLocallyStored[firstIndex!].lyrics
                song = tempSong
                updateUI(with: song!.lyrics)
                checkSongSavedStatus()
                
            } else {
                print("Song is not saved")
                Task.init {
                    do {
                        LyricsController.shared.lyricsString = try await LyricsController.shared.fetchLyrics()
                        updateUI(with: cleanLyricsText(lyricsText:  LyricsController.shared.lyricsString))
                        checkSongSavedStatus()
                    } catch {
                        displayError(error, title: "Failed to get the lyrics for the requested song.")
                    }
            }
            

        }
        }
        
    }
    

    func updateUI(with lyrics : String){
        lyricsLabel.text = lyrics
    }
    
    func checkSongSavedStatus(){
        
        updateSaveButtonState(newState: true)
        if song == nil{
            print("Song es nil")
            saveButton.title = "Save"
            return
        } else {
            print("Song no es nil")
            if checkSongSaveStatus(songToCheck: song!){
                saveButton.title = "Unsave"
            } else {
                saveButton.title = "Save"
            }
        }
        
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
        
        if (song != nil){
            print ("Song already saved")
            if checkSongSaveStatus(songToCheck: song!){
                //True
                //Delete song
                if let firstIndex = songsLocallyStored.firstIndex(of: song!){
                    songsLocallyStored.remove(at: firstIndex)
                    Song.saveSongs(songsLocallyStored)
                }
                print("Deleting")
                
            } else {
                //False
                //Save song
                print("Saving")
                songsLocallyStored.append(song!)
                Song.saveSongs(songsLocallyStored)
            }
        } else {
            print("song still not saved")
            // Save song
            song = Song(artist: LyricsController.shared.artistName, title: LyricsController.shared.songTitle, lyrics: LyricsController.shared.lyricsString )
            songsLocallyStored.append(song!)
            Song.saveSongs(songsLocallyStored)
        }
        checkSongSavedStatus()
        
    }
    
    func checkSongSaveStatus(songToCheck song : Song ) -> Bool {
        return songsLocallyStored.contains(song)
        
    }
    
    
    func loadSavedSongs(){
        if let savedSongs = Song.loadSongs() {
            songsLocallyStored = savedSongs
        }
//        else {
//            songsLocallyStored = Song.loadSampleSongs()
//        }
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

extension Array {
 func contains<T>(obj: T) -> Bool where T: Equatable {
     return !self.filter({$0 as? T == obj}).isEmpty
 }
}
