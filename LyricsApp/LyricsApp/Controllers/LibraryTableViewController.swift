//
//  LibraryTableViewController.swift
//  LyricsApp
//
//  Created by Iker Gutierrez on 17/2/22.
//

import UIKit

class LibraryTableViewController: UITableViewController {
    
    var songsStored = [Song] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedSongs = Song.loadSongs() {
            songsStored = savedSongs
        } else {
            songsStored = Song.loadSampleSongs()
        }
        navigationItem.leftBarButtonItem = editButtonItem

    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songsStored.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedSongCellIdentifier", for: indexPath) as! SavedSongCell
        let song = songsStored[indexPath.row]
        cell.artistLabel.text = song.artist.capitalized
        cell.songLabel.text = song.title.capitalizingFirstLetter()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            songsStored.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            Song.saveSongs(songsStored)
        }
    }
    
    
    @IBSegueAction func showSongLyrics(_ coder: NSCoder, sender: Any?) -> LyricsViewController? {
        print("MODIFICADO")
        let lyricsController = LyricsViewController(coder: coder)
        
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return lyricsController
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        lyricsController?.song = songsStored[indexPath.row]
        
        
        return lyricsController
    }
    @IBSegueAction func showSongLyrics2(_ coder: NSCoder, sender: Any?) -> LyricsViewController? {
        print("MODIFICADO")
        let lyricsController = LyricsViewController(coder: coder)
        
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return lyricsController
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        lyricsController?.song = songsStored[indexPath.row]
        
        
        return lyricsController
    }
    
    
}
