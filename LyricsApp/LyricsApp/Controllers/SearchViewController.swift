//
//  SearchViewController.swift
//  LyricsApp
//
//  Created by Iker Gutierrez.
//

import UIKit

class SearchViewController: UIViewController {

    
    @IBOutlet var artistNameText: UITextField!
    @IBOutlet var songNameText: UITextField!
    @IBOutlet var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButtonState()
    }

    @IBAction func searchLyricsTapped(_ sender: Any) {
        LyricsController.shared.artistName = artistNameText.text!.lowercased()
        LyricsController.shared.songTitle = songNameText.text!.lowercased()
    }
    
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    func updateSaveButtonState() {
        let shouldEnableSaveButton = ((artistNameText.text?.isEmpty == false) && (songNameText.text?.isEmpty == false))
        searchButton.isEnabled = shouldEnableSaveButton
    }
}
