//
//  LyricsViewController.swift
//  LyricsApp
//
//  Created by Iker Gutierrez on 19/2/22.
//

import UIKit

class LyricsViewController: UIViewController {

    
    @IBOutlet var lyricsLabel: UILabel!
    
    let url = URL(string: "https://api.lyrics.ovh/v1/eminem/venom")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("heloo")
//        Task.init {
//            do {
//                print("doind")
//                let lyrics = try await LyricsController.shared.fetchLyrics()
//                print("done")
//                updateUI(with: lyrics)
//                print(lyrics)
//            }
//        }
        Task {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let string = String(data: data, encoding: .utf8) {
                    print(string)
                let decoder = JSONDecoder()
                let lyricsResponse = try decoder.decode(LyricsResponse.self, from: data)
                updateUI(with: lyricsResponse.lyrics)
            }
        }
    }
    

    func updateUI(with lyrics : String){
        lyricsLabel.text = lyrics
    }

}
