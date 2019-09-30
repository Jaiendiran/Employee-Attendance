@RestResource(urlMapping='/InvestorFacilityDetails')
global class WSInvestorFacilityDetails {
   
     @HttpGET
    global static Response InvestorFacilityDetails()
    {
        RestRequest req = RestContext.request;
        RestResponse restRes = RestContext.response;
        Response res = new Response('InvestorFacilityDetails');
        //Headers from request
        String accountId = req.headers.get('Account-ID');
        System.debug('Value of accountId in WSInvestorFacilityDetails = '+accountId);
       
        if(!Test.isRunningTest()){        
            ServerMaintainence__c sm = [Select id, Enable__c from ServerMaintainence__c limit 1];
             
           
            if(sm.Enable__c==true)
            {
                res.status = peer.Constants.SUCCESS;
                restRes.statusCode = 503;
                res.message = 'Server under maintainence';                
                return res;
            }
        }
       
        if(accountId == null){
            res.errorCode = peer.Constants.INVALID_INPUT;
            res.status = peer.Constants.ERROR;
            res.message = 'ACCOUNT_ID_NOT_PRESENT_IN_HEADER';
            restRes.statuscode = peer.Constants.HTTP_BAD_REQUEST;
            return res;
        }
        try{
            wrapperfaclity faclacc = new wrapperfaclity();
           // list<wrapperfaclity> faac = new list<wrapperfaclity>();
           
            wrapperfacility2 fac;
            list<wrapperfacility2> ivcl= new list<wrapperfacility2>();
           
             
            //Query Account Object
            Account account = new Account();
            List <Account> accountList = new List<Account>();
            accountList =[select id,name,type,User_ID__c,phone,cnotify__Email__c from account where  Id =: accountId  limit 1];
           
            if(accountList.isEmpty())
            {
                res.status = peer.Constants.ERROR;
                res.errorCode = 'ACCOUNT_ID_NOT_FOUND';
                res.message = 'Account Id not does not match the records';
                restRes.statuscode = peer.Constants.HTTP_BAD_REQUEST;
                return res;
            }
            else{
                for(Account a :accountList){
                faclacc.id = a.id;    
                faclacc.name = a.name;
                faclacc.type = a.type;
                faclacc.userid = a.User_ID__c;
                faclacc.mobile = a.phone;
                faclacc.email = a.cnotify__Email__c;
               
                }
            }
  catch (Exception e)
            {            
             System.debug('Line Number is = '+e.getLineNumber()+' Message is = ' +e.getMessage());        
             res.errorCode = 'EXCEPTION_OCCURRED';  
             res.status = peer.Constants.ERROR;  
             res.message = 'Internal Exception Occurred Line Number is = '+e.getLineNumber()+' Message is = ' +e.getMessage();
             restRes.statuscode = peer.Constants.HTTP_INTERNAL_ERROR;  
             return res;
            }
    //return null;
   
       
    }
 //**********************************investorfacilitydetailsfrontend***********************************************************//    
   
            string NA = 'N/A';
              List <loan__Investor_Loan__c> investmentOrderList = new List<loan__Investor_Loan__c>();
              // loan__Investor_Loan__c investmentOrder;
           
            investmentOrderList = [select id,loan__Loan__r.Genesis_Product__c,ProdType__c,loan__Loan__r.Is_It_Disclosed__c,loan__Loan__r.Premieum_Component__c,loan__Loan__r.loan__Principal_Remaining__c,loan__Loan__r.Loan_App_ID__c,Borrower_Name__c,loan__Investment_Amount__c,Total_Insurance_Premium_Paid__c,Interest_Rate_p_m__c,loan__Loan__r.Genesis_Tenure__c,loan__Loan__r.loan__Expected_Disbursal_Date__c,loan__Loan__r.loan__Last_Payment_Date__c,Principal_Paid__c,Interest_Amount_Paid_excl_waived__c,Fees_Paid_excl_waived__c,loan__Total_Amount_Paid__c,Contract_Status__c from loan__Investor_Loan__c where (loan__Status__c = 'Active' OR loan__Investor_End_Date__c = THIS_MONTH OR loan__Charged_Off_Date__c = THIS_MONTH)and loan__Account__c =: accountId ];
             
           
            for(loan__Investor_Loan__c inv :investmentOrderList){
                fac = new wrapperfacility2();
                fac.LoanProduct = inv.loan__Loan__r.Genesis_Product__c;
                fac.PrincipalOutstandingBalance = inv.loan__Loan__r.loan__Principal_Remaining__c;
                fac.LoanID = inv.loan__Loan__r.Loan_App_ID__c;
                fac.BorrowerName = inv.Borrower_Name__c;
                fac.InvestmentAmount = inv.loan__Investment_Amount__c;
                fac.Insurance = inv.Total_Insurance_Premium_Paid__c;
                fac.InterestRate = inv.Interest_Rate_p_m__c;
                fac.Tenurpm = inv.loan__Loan__r.Genesis_Tenure__c;
                fac.DisbursalDate = inv.loan__Loan__r.loan__Expected_Disbursal_Date__c;
                fac.LastRepaymentDate = inv.loan__Loan__r.loan__Last_Payment_Date__c;
                fac.PrincipalPaid = inv.Principal_Paid__c;
                fac.Interestlaterepaymentfeepaid = inv.Interest_Amount_Paid_excl_waived__c + inv.Fees_Paid_excl_waived__c;
                fac.TotalPaid = inv.loan__Total_Amount_Paid__c;
                fac.Status = inv.Contract_Status__c;
                if((inv.loan__Loan__r.Genesis_Product__c == 'Accounts Receivable Financing' || inv.loan__Loan__r.Genesis_Product__c == 'Corporate Vendor Financing') && (inv.loan__Loan__r.Is_It_Disclosed__c != false || inv.loan__Loan__r.Premieum_Component__c != false)  ){
                fac.Type = inv.ProdType__c;
                } else{
                    fac.Type = 'N/A';
                }
                ivcl.add(fac);
            }
           
             res.facacc = faclacc;
             res.fa = ivcl;
             res.status = peer.Constants.success;  
             restRes.statuscode = peer.Constants.HTTP_INTERNAL_ERROR;  
             return res;
           
           
        }
     
   
}