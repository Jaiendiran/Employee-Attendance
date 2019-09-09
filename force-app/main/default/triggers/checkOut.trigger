trigger checkOut on employeeAttendance__c (before update) {
    List<employeeAttendance__c> ls_emp = new List<employeeAttendance__c>();

    for(employeeAttendance__c emp: trigger.new){
        if(emp.Check_In_Date_Time__c != null){
            emp.Check_Out_Date_Time__c = System.now();

            ls_emp.add(emp);
        }
    }
}