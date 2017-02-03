//
//  TimerPickerViewController.swift
//  ChessTimer
//
//  Created by David Crooks on 03/02/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import UIKit




class TimerPickerViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    @IBOutlet weak var whitePicker: UIPickerView!
    @IBOutlet weak var blackPicker: UIPickerView!
    var timerTableVC:TimerTableViewController?
    @IBAction func Ok(_ sender: Any) {
        if let ttvc = timerTableVC {
            ttvc.games.append(game)
            ttvc.tableView.reloadData()
            dismiss(animated: true, completion: {
               ttvc.performSegue(withIdentifier:"clockVCSegue", sender:self.game)
            })
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var game:Game = Game(white:10,black:10)
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        whitePicker.delegate = self
        blackPicker.delegate = self
        whitePicker.dataSource = self
        blackPicker.dataSource = self
        
        whitePicker.selectRow(game.white, inComponent: 0, animated: false)
        blackPicker.selectRow(game.black, inComponent: 0, animated: false)
        //Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Pickerview delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
       return String(row)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === whitePicker {
            game.white = row
        }
        else {
            game.black = row
        }
    }
    // MARK: - Pickerview datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    /*
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
