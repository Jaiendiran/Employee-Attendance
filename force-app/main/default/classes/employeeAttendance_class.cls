public with sharing class employeeAttendance_class {
    //Collections
    public List<employeeAttendance__c> ls_empAttd{get; set;}
    public List<employeeAttendance__c> ls_empAtt{get; set;}
    //Variable Declaration
    public employeeAttendance__c empAtt{get; set;}
    public ApexPages.StandardController chckOutBtn;
    
    //controller
    public employeeAttendance_class(ApexPages.StandardController controller) {
        this.chckOutBtn = controller;   
    }
    
    public void save(){
        chckOutBtn.save();
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info, 'Check-In Successfull !'));
    }

    public void chckOutBtn(){
        ls_empAttd = [select ID, Employee_Name__c, Check_In_Date_Time__c, Check_Out_Date_Time__c, Description__c from employeeAttendance__c];

        for(employeeAttendance__c emp: ls_empAttd){
            ls_empAtt = new List<employeeAttendance__c>();

            if(emp.Check_Out_Date_Time__c == null){
                emp.Check_Out_Date_Time__c = System.now();

                ls_empAtt.add(emp);
            }
        }
        update ls_empAtt;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info, 'Check-Out Successfull !'));
    }
}
