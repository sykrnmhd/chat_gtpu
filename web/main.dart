// main.dart
import 'dart:html';
import 'payroll_class.dart';

void main() 
{
  var payrollSystem = PayrollManagementSystem(); // Create an instance of the class
  payrollSystem.loadFromLocalStorage(); // Load data from local storage

  var recordButton = querySelector('#recordButton'); // get the data for the record button
  var calculateButton = querySelector('#calculateButton'); // get the data for the calculate button
  var resetButton = querySelector('#resetButton');  // get the data for the reset button

  

  if (recordButton != null) 
  {
    recordButton.onClick.listen((_) 
    {
      var employeeIdInput = querySelector('#employeeId') as InputElement?; // get the data for employee id input
      var timeInInput = querySelector('#timeIn') as InputElement?;
      var timeOutInput = querySelector('#timeOut') as InputElement?;

      int? employeeId = employeeIdInput?.valueAsNumber?.toInt(); // the data for employee id input as integer
      String? checkInTime = timeInInput?.value; 
      String? checkOutTime = timeOutInput?.value;

      payrollSystem.recordWorkingHours(employeeId, checkInTime, checkOutTime); //pass to the recordWorkingHours function
    });
  }

  if (calculateButton != null) 
  {
    calculateButton.onClick.listen((_)
    {
      var calculateEmployeeIdInput = querySelector('#calculateEmployeeId') as InputElement?; // get the data for calculate employee id input
      int? employeeId = calculateEmployeeIdInput?.valueAsNumber?.toInt(); // the data for employee id input as integer

      payrollSystem.calculateSalary(employeeId); //pass to the calculateSalary function
    });
  }

  if (resetButton != null) 
  {
    resetButton.onClick.listen((_) 
    {
      var resetEmployeeIdInput = querySelector('#resetEmployeeId') as InputElement?; // get the data for reset employee id input
      int? resetEmployeeId = resetEmployeeIdInput?.valueAsNumber?.toInt(); // the data for employee id input as integer

      payrollSystem.resetWorkingHours(resetEmployeeId); //pass to the calculateSalary function
    });
  }
}


