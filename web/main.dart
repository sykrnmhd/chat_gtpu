// main.dart
import 'dart:html';
import 'payroll_class.dart';

void main() {
  var payrollSystem = PayrollManagementSystem();
  payrollSystem.loadFromLocalStorage();

  var recordButton = querySelector('#recordButton');
  var calculateButton = querySelector('#calculateButton');
  var resetButton = querySelector('#resetButton');

  if (recordButton != null) {
    recordButton.onClick.listen((_) {
      var employeeIdInput = querySelector('#employeeId') as InputElement?;
      var timeInInput = querySelector('#timeIn') as InputElement?;
      var timeOutInput = querySelector('#timeOut') as InputElement?;

      int? employeeId = employeeIdInput?.valueAsNumber?.toInt();
      String? checkInTime = timeInInput?.value;
      String? checkOutTime = timeOutInput?.value;

      payrollSystem.recordWorkingHours(employeeId, checkInTime, checkOutTime);
    });
  }

  if (calculateButton != null) {
    calculateButton.onClick.listen((_) {
      var calculateEmployeeIdInput =
          querySelector('#calculateEmployeeId') as InputElement?;
      int? employeeId = calculateEmployeeIdInput?.valueAsNumber?.toInt();

      payrollSystem.calculateSalary(employeeId);
    });
  }

  if (resetButton != null) {
    resetButton.onClick.listen((_) {
      var resetEmployeeIdInput =
          querySelector('#resetEmployeeId') as InputElement?;
      int? resetEmployeeId = resetEmployeeIdInput?.valueAsNumber?.toInt();

      payrollSystem.resetWorkingHours(resetEmployeeId);
    });
  }
}
