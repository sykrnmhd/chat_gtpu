import 'dart:html';
import 'dart:convert';

class PayrollManagementSystem {
  Map<int, double> workingHoursMap = {};
  int accumulationCount = 0;
  
  double hourlyRate = 6.0; // RM per hour
  double epfContributionRate = 0.11; // 11% EPF contribution rate

  void recordWorkingHours(int? employeeId, String? checkInTime, String? checkOutTime) {
    if (employeeId != null && checkInTime != null && checkOutTime != null) {
      DateTime checkIn = DateTime.parse('1970-01-01 $checkInTime:00Z');
      DateTime checkOut = DateTime.parse('1970-01-01 $checkOutTime:00Z');
      double hours = checkOut.difference(checkIn).inMinutes / 60.0;

      workingHoursMap[employeeId] = 
          (workingHoursMap[employeeId] ?? 0.0) + (hours);
    }

    var hoursRecordedElement = querySelector('#hoursRecorded');
      hoursRecordedElement?.text =
          "Working hour(s) for Employee $employeeId has been recorded";

    // Automatically reset after 22 accumulations
      accumulationCount++;
      if (accumulationCount >= 22) {
        resetWorkingHours();
      }
  }

  void calculateSalary(int? employeeId) {
    if (employeeId != null) {
      double hoursWorked = workingHoursMap[employeeId] ?? 0.0;
      double grossSalary = hoursWorked * hourlyRate;
      double epfContribution = grossSalary * epfContributionRate;
      double netSalary = grossSalary - epfContribution;

      // Display the result in the UI
      var resultGrossElement = querySelector('#resultGross');
      resultGrossElement?.text =
          "Gross Salary for Employee $employeeId: RM ${grossSalary.toStringAsFixed(2)}";

      var resultNetElement = querySelector('#resultNet');
      resultNetElement?.text =
          "Net Salary for Employee $employeeId: RM ${netSalary.toStringAsFixed(2)}";

      var accCount = querySelector('#accCount');
      accCount?.text = "Days Worked for the month: $accumulationCount" + "/22";
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