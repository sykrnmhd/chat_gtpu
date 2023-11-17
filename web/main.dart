// main.dart
import 'dart:html';
import 'dart:convert';

class PayrollManagementSystem {
  Map<int, double> workingHoursMap = {};
  int accumulationCount = 0;

  double hourlyRate = 6.0; // RM per hour
  double epfContributionRate = 0.11; // 11% EPF contribution rate

  void recordWorkingHours(int? employeeId, double? hours) {
    if (employeeId != null && hours != null) {
      workingHoursMap[employeeId] ??= 0.0;
      workingHoursMap[employeeId] =
          (workingHoursMap[employeeId] ?? 0.0) + hours;
      print(
          "Working hours recorded for Employee $employeeId: ${workingHoursMap[employeeId]} hours");
    } else {
      print("Invalid input. Please provide both Employee ID and Hours Worked.");
    }
  }

  void calculateSalary(int? employeeId) {
    if (employeeId != null) {
      double hoursWorked = workingHoursMap[employeeId] ?? 0.0;
      double grossSalary = hoursWorked * hourlyRate;
      double epfContribution = grossSalary * epfContributionRate;
      double netSalary = grossSalary - epfContribution;

      print("Employee $employeeId Salary Details:");
      print("Hours Worked: $hoursWorked hours");
      print("Gross Salary (Before EPF): RM $grossSalary");
      print("EPF Contribution (11%): RM $epfContribution");
      print("Net Salary (After EPF): RM $netSalary");

      // Display the result in the UI
      var resultGrossElement = querySelector('#resultGross');
      resultGrossElement?.text =
          "Gross Salary for Employee $employeeId: RM $grossSalary";

      var resultNetElement = querySelector('#resultNet');
      resultNetElement?.text =
          "Net Salary for Employee $employeeId: RM $netSalary";

      // Automatically reset after 22 accumulations
      accumulationCount++;
      if (accumulationCount >= 22) {
        resetWorkingHours();
      }
    } else {
      print(
          "Invalid input. Please provide Employee ID for salary calculation.");
    }
  }

  void resetWorkingHours() {
    workingHoursMap.clear();
    accumulationCount = 0;
    print("Working hours reset.");
  }

  void saveToLocalStorage() {
    window.localStorage['workingHoursMap'] = json.encode(workingHoursMap);
    window.localStorage['accumulationCount'] = json.encode(accumulationCount);
  }

  void loadFromLocalStorage() {
    var storedData = window.localStorage['workingHoursMap'];
    if (storedData != null) {
      workingHoursMap = Map<int, double>.from(json.decode(storedData));
    }

    var countData = window.localStorage['accumulationCount'];
    if (countData != null) {
      accumulationCount = json.decode(countData);
    }
  }
}

void main() {
  var payrollSystem = PayrollManagementSystem();
  payrollSystem.loadFromLocalStorage();

  var recordButton = querySelector('#recordButton');
  var calculateButton = querySelector('#calculateButton');
  var resetButton = querySelector('#resetButton');

  if (recordButton != null) {
    recordButton.onClick.listen((_) {
      var employeeIdInput = querySelector('#employeeId') as InputElement?;
      var hoursInput = querySelector('#hoursWorked') as InputElement?;

      int? employeeId = employeeIdInput?.valueAsNumber?.toInt();
      double? hours = hoursInput?.valueAsNumber?.toDouble();

      payrollSystem.recordWorkingHours(employeeId, hours);
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
      payrollSystem.resetWorkingHours();
    });
  }
}
