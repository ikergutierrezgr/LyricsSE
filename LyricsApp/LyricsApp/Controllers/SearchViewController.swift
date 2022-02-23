//
//  SearchViewController.swift
//  LyricsApp
//
//  Created by Iker Gutierrez on 18/2/22.
//

import UIKit

class SearchViewController: UIViewController {

    
    @IBOutlet var artistNameText: UITextField!
    @IBOutlet var songNameText: UITextField!
    @IBOutlet var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func searchLyricsTapped(_ sender: Any) {
        LyricsController.shared.artistName = artistNameText.text!.lowercased()
        LyricsController.shared.songTitle = songNameText.text!.lowercased()
    }
}
