import 'dart:html';
import 'dart:convert';

class PayrollManagementSystem {
  Map<int, double> workingHoursMap = {};
  Map<int, int> accumulationCountMap = {};
  double hourlyRate = 6.0; // RM per hour
  double epfContributionRate = 0.11; // 11% EPF contribution rate

  void recordWorkingHours(
      int? employeeId, String? checkInTime, String? checkOutTime) {
    if (employeeId != null && checkInTime != null && checkOutTime != null) {
      DateTime checkIn = DateTime.parse('1970-01-01 $checkInTime:00Z');
      DateTime checkOut = DateTime.parse('1970-01-01 $checkOutTime:00Z');
      double hours = checkOut.difference(checkIn).inMinutes / 60.0;

      var hoursRecordedElement = querySelector('#hoursRecorded');
      hoursRecordedElement?.text =
          "Working hour(s) for Employee $employeeId has been recorded";

      workingHoursMap[employeeId] =
          (workingHoursMap[employeeId] ?? 0.0) + (hours);

      accumulationCountMap[employeeId] =
          (accumulationCountMap[employeeId] ?? 0) + 1;

      if (accumulationCountMap[employeeId]! > 22) {
        resetWorkingHours(employeeId);
      }
    }
  }

  void calculateSalary(int? employeeId) {
  if (employeeId != null) {
    double hoursWorked = workingHoursMap[employeeId] ?? 0.0;
    double grossSalary = hoursWorked * hourlyRate;
    double epfContribution = grossSalary * epfContributionRate;
    double netSalary = grossSalary - epfContribution;

    // Create a new dialog element
    var dialog = DivElement()
      ..id = 'dialog'
      ..classes.add('dialog');

    // Create the dialog content
    var dialogContent = DivElement()
      ..classes.add('dialog-content');
    dialog.append(dialogContent);

    // Create the text elements
    var resultGrossElement = ParagraphElement()
      ..text = "Gross Salary for Employee $employeeId: RM ${grossSalary.toStringAsFixed(2)}";
    dialogContent.append(resultGrossElement);

    var resultNetElement = ParagraphElement()
      ..text = "Net Salary for Employee $employeeId: RM ${netSalary.toStringAsFixed(2)}";
    dialogContent.append(resultNetElement);

    var accCount = ParagraphElement()
      ..text = "Days Worked for Employee $employeeId: ${accumulationCountMap[employeeId] ?? 0}";
    dialogContent.append(accCount);

    // Create the close button
    var closeButton = ButtonElement()
      ..classes.add('close-button')
      ..text = 'Close'
      ..onClick.listen((_) {
        dialog.remove(); // Remove the dialog when the close button is clicked
      });
    dialogContent.append(closeButton);

    document.body?.append(dialog); // Add the dialog to the body of the page
  }
  }

  void resetWorkingHours(int? employeeId) {
    if (employeeId != null) {
      workingHoursMap.remove(employeeId);
      accumulationCountMap.remove(employeeId);
    } else {
      workingHoursMap.clear();
      accumulationCountMap.clear();
    }
  }

  void saveToLocalStorage() {
    window.localStorage['workingHoursMap'] = json.encode(workingHoursMap);
    window.localStorage['accumulationCountMap'] =
        json.encode(accumulationCountMap);
  }

  void loadFromLocalStorage() {
    var storedData = window.localStorage['workingHoursMap'];
    if (storedData != null) {
      workingHoursMap = Map<int, double>.from(json.decode(storedData));
    }

    var countData = window.localStorage['accumulationCountMap'];
    if (countData != null) {
      accumulationCountMap = Map<int, int>.from(json.decode(countData));
    }
  }
}
