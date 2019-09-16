global class myHandler implements Messaging.InboundEmailHandler {
 
  global Messaging.InboundEmailResult  handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env){

    Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
   
   	//Variable Declaration
	String[] recordID = email.plainTextBody.split('\n', 0); 
	string sub = email.subject;
	Date dt = Date.today();

	//Collections
	list<Employee__c> ls_emp = [select ID, name, (select id, name, CreatedDate, Description__c, Approval_status__c from employeeAttendances__r where createdDate =:dt) from Employee__c where ID =:recordID];
	list<employeeAttendance__c> ls_approved = new list<employeeAttendance__c>();
	list<employeeAttendance__c> ls_rejected = new list<employeeAttendance__c>();

	
	if(sub == 'Approved'){
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
	} else if(sub == 'Rejected'){
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