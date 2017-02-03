//
//  TimerTableViewController.swift
//  ChessTimer
//
//  Created by David Crooks on 02/02/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import UIKit




class GameCell:UITableViewCell {
    
    @IBOutlet weak var blackLabel: UILabel!
    
    @IBOutlet weak var whiteLable: UILabel!
    
}

class TimerTableViewController: UITableViewController {
    
    @IBAction func edit(_ sender: Any) {
        
        //TODO:- Make table editable
        
    }
    
    var games:[Game] = [Game(white: 1,black: 1),Game(white: 3,black: 3), Game(white: 5,black: 5),Game(white: 10,black: 10),Game(white: 15,black: 15),Game(white: 20,black: 20)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return games.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        
        if let cell =  cell as? GameCell {
            let game = games[indexPath.item]
            
            cell.blackLabel.text = String(game.black)
            cell.whiteLable.text = String(game.white)
        }
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let vc = segue.destination as? ClockViewController
        {
            if let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell){
                vc.gameTimer = GameTimer(game: games[indexPath.item])
            }
            else if let game = sender as? Game {
                 vc.gameTimer = GameTimer(game:game)
            }
        }
        
        if let vc = segue.destination as? TimerPickerViewController
        {
            vc.timerTableVC = self
        }
    }
    

}
