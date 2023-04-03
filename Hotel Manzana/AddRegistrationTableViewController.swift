//
//  AddRegistrationTableViewController.swift
//  Hotel Manzana
//
//  Created by Анастасія Грисюк on 22.03.2023.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate {
    func selectRoomTypeTableViewController(_ controller:
       SelectRoomTypeTableViewController, didSelect roomType:
       RoomType) {
        self.roomType = roomType
        updateRoomType()
        updateDateViews()
    }

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkInDatePicker: UIDatePicker!
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet var numberOfAdultsLabel: UILabel!
    @IBOutlet var numberOfAdultsStepper: UIStepper!
    @IBOutlet var numberOfChildrenLabel: UILabel!
    @IBOutlet var numberOfChildrenStepper: UIStepper!

    @IBOutlet var wifiSwitch: UISwitch!
    
    @IBOutlet var roomTypeLabel: UILabel!
    var roomType: RoomType?
    
    @IBOutlet weak var numberOfNights: UILabel!
    @IBOutlet weak var rangeOfNights: UILabel!
    @IBOutlet weak var sumForRooms: UILabel!
    @IBOutlet weak var chosenRoom: UILabel!
    @IBOutlet weak var totalForWiFi: UILabel!
    @IBOutlet weak var needWiFi: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    
    var registration: Registration? {

        guard let roomType = roomType else { return nil }

        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn

        return Registration(firstName: firstName,
                            lastName: lastName,
                            emailAddress: email,
                            checkInDate: checkInDate,
                            checkOutDate: checkOutDate,
                            numberOfAdults: numberOfAdults,
                            numberOfChildren: numberOfChildren,
                            wifi: hasWifi,
                            roomType: roomType)
    }
    
    let checkInDateLabelCellIndexPath = IndexPath(row: 0, section: 1)
    let checkOutDateLabelCellIndexPath = IndexPath(row: 2, section: 1)
    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    
    var isCheckInDatePickerVisible: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerVisible
        }
    }
    
    var isCheckOutDatePickerVisible: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNumberOfGuests()
        updateDateViews()
        updateRoomType()
        
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
    }

    @IBAction func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateDateViews() {
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding:
           .day, value: 1, to: checkInDatePicker.date)
        
        checkInDateLabel.text = checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        checkOutDateLabel.text =
           checkOutDatePicker.date.formatted(date: .abbreviated,
           time: .omitted)
        
        let nights = Calendar.current.dateComponents([.day], from: checkInDatePicker.date, to: checkOutDatePicker.date).day!
        numberOfNights.text = String(nights)
        rangeOfNights.text = (checkInDatePicker.date..<checkOutDatePicker.date).formatted(date: .abbreviated, time: .omitted)
        
        let priceForNights = (roomType?.price ?? 0) * nights
        sumForRooms.text = "$ " + String(priceForNights)
        if let roomType {
            chosenRoom.text = roomType.name + "@ $" + String(roomType.price) + "/night"
        } else {
            chosenRoom.text = ""
        }
        let priceForWiFi = 10 * nights
        if wifiSwitch.isOn {
            totalForWiFi.text = "$ " + String(priceForWiFi)
            needWiFi.text = "Yes"
        } else {
            totalForWiFi.text = "$ 0"
            needWiFi.text = "No"
        }
        
        totalAmount.text = "$ " + String(priceForNights + priceForWiFi)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    func updateNumberOfGuests() {
        numberOfAdultsLabel.text =
           "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text =
           "\(Int(numberOfChildrenStepper.value))"
    }
   
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
   
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        updateDateViews()
    }
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
        } else {
            roomTypeLabel.text = "Not Set"
        }
    }
    
    
    @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
        let selectRoomTypeController =
               SelectRoomTypeTableViewController(coder: coder)
            selectRoomTypeController?.delegate = self
            selectRoomTypeController?.roomType = roomType
        
            return selectRoomTypeController
    }
    
    // MARK: - Table view data source

  
        
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    
    override func tableView(_ tableView: UITableView,
       heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerCellIndexPath where
           isCheckInDatePickerVisible == false:
            return 0
        case checkOutDatePickerCellIndexPath where
           isCheckOutDatePickerVisible == false:
            return 0
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView,
       estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerCellIndexPath:
            return 190
        case checkOutDatePickerCellIndexPath:
            return 190
        default:
            return UITableView.automaticDimension
        }
    }
    
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath == checkInDateLabelCellIndexPath &&
               isCheckOutDatePickerVisible == false {
               
                isCheckInDatePickerVisible.toggle()
            } else if indexPath == checkOutDateLabelCellIndexPath &&
               isCheckInDatePickerVisible == false {
                isCheckOutDatePickerVisible.toggle()
            } else if indexPath == checkInDateLabelCellIndexPath ||
               indexPath == checkOutDateLabelCellIndexPath {
               isCheckInDatePickerVisible.toggle()
                isCheckOutDatePickerVisible.toggle()
            } else {
                return
            }
        
            tableView.beginUpdates()
            tableView.endUpdates()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
