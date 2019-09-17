global class myHandler implements Messaging.InboundEmailHandler {
 
  global Messaging.InboundEmailResult  handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env){

    Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
   
   	//Variable Declaration
	String[] emailBody = email.plainTextBody.split('\n', 0);
	String apprStatus = emailBody[0]; 
	string usrID = email.subject;

	//Collections
	list<Employee__c> ls_emp = [select ID, Name, (select id, Name, Employee_Name__c, Description__c, Approval_Status__c from employeeAttendances__r where createdDate = Today) from employee__c where ID =: usrID];
	list<employeeAttendance__c> ls_approved = new list<employeeAttendance__c>();
	list<employeeAttendance__c> ls_rejected = new list<employeeAttendance__c>();

	
	if(apprStatus == 'Approved'){
		//Iterates over employee and employee attendance object to update approval status field as 'Approved'.
		for(Employee__c emp: ls_emp){
			for(employeeAttendance__c empAtt: emp.employeeAttendances__r){
				if(empAtt.Description__c != null){
					if(empAtt.Approval_status__c == null){
						empAtt.Approval_status__c = 'Approved';
						ls_approved.add(empAtt);
					}
				}
			}
		} 
		update ls_approved;
	} else if(apprStatus == 'Rejected'){
		//Iterates over employee and employee attedance object to update approval status field as 'rejected'.
		for(Employee__c empl: ls_emp){
			for(employeeAttendance__c empAttd: empl.employeeAttendances__r){
				if(empAttd.Description__c != null){
					if(empAttd.Approval_status__c == null){
						empAttd.Approval_status__c = 'Rejected';
						ls_rejected.add(empAttd);
					}
				}
			}
		}    
		update ls_rejected;
	}

   	return result;
  }
}