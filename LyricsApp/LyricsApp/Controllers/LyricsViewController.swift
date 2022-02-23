//
//  LyricsViewController.swift
//  LyricsApp
//
//  Created by Iker Gutierrez on 19/2/22.
//

import UIKit

class LyricsViewController: UIViewController {

    
    @IBOutlet var lyricsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task.init {
            do {
                let lyrics = try await LyricsController.shared.fetchLyrics()
                updateUI(with: cleanLyricsText(lyrycsText: lyrics))
            } catch {
                displayError(error, title: "Failed to get the lyrics for the requested song.")
            }
        }
        
    }
    

    func updateUI(with lyrics : String){
        lyricsLabel.text = lyrics
    }
    
    func displayUIError(){
        updateUI(with: "Lyrics not found")
    }

    func displayError(_ error: Error, title: String){
        guard let _ = viewIfLoaded?.window else { return }
                
        let alert = UIAlertController(title: title, message: "\(LyricsController.shared.songTitle.capitalizingFirstLetter()) from \(LyricsController.shared.artistName.capitalized) not found.", preferredStyle: .alert)
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
    
    func cleanLyricsText(lyrycsText lyrics : String) -> String{
        var cleandedlyrics: String = ""
        let removeCharacters: String = "Paroles de la chanson \(LyricsController.shared.songTitle.capitalizingFirstLetter()) par \(LyricsController.shared.artistName.capitalizingFirstLetter())"
        
        cleandedlyrics = lyrics.replacingOccurrences(of: removeCharacters, with: "")
        
        print(cleandedlyrics)
        
        
        var charactersToDelete: Int = 22
        
        charactersToDelete = charactersToDelete + LyricsController.shared.songTitle.count + LyricsController.shared.artistName.count + 5
        
        print(charactersToDelete)
        
        
        return cleandedlyrics
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
