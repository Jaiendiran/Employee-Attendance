trigger employeeID on employeeAttendance__c (before insert) {
    List<employeeAttendance__c> ls_empAtt = new List<employeeAttendance__c>();

    for(employeeAttendance__c empAtt: trigger.new){
        employee__c emp = new employee__c();

        if(empAtt.Employee_Name__c != null){
            empAtt.Employee_ID__c = empAtt.Employee_Name__r.ID;
        }

        ls_empAtt.add(empAtt);
    }
    insert ls_empAtt;
}