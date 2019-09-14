global class myHandler implements Messaging.InboundEmailHandler {
 
  global Messaging.InboundEmailResult  handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env){

    Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

    String action= 'Approved';

	if(email.subject.equals(action)){
		employee__c emp = new employee__c();

		//Collections
		List<employee__c> ls_emp = [Select ID, Name, Approval_Status__c from employee__c where ID =: 'a022v00001BHjypAAD'];
		List<employee__c> ls_emp1 = new List<employee__c>();

		//Iterating over the objects record.
		for(employee__c empl: ls_emp){
			if(emp.Name == 'Aadhi'){
				emp.Approval_status__c = 'Approved';
			}
			ls_emp1.add(emp);
		}
		update ls_emp;
	}
   	return result;
  }
}