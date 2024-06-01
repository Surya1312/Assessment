public with sharing class LendingSystemIntegration {

    private static final String INSERT_OPERATION = 'I';
    private static final String UPDATE_OPERATION = 'U';
    private static final String DELETE_OPERATION = 'D';
    
    @future(callout=true)
    public static void loanOnInsert(String recs) {

        if(String.isBlank(recs))
            return;

        try {
            HttpRequest insertReq = new HttpRequest();
            insertReq.setEndpoint('callout:Loan_Lenders_Credential/insertLoans');
            insertReq.setMethod('POST');
            insertReq.setHeader('Content-Type', 'application/json');

            List<Loan__c> insertedRecs = (List<Loan__c>)JSON.deserialize(recs, List<Loan__c>.class);

            if(insertedRecs!=null && !insertedRecs.isEmpty()){
                Set<Id> accIds = new Set<Id>();
                for(Loan__c loan:insertedRecs){
                    accIds.add(loan.AccountId);
                }

                if(accIds.size()>0){
                    Map<Id,Account> mapOfAccounts = new Map<Id,Account>([SELECT Id,AccountNumber from Account WHERE Id IN:accIds]);
                    List<InsertRequestWrapper> insertWrapperList = new List<InsertRequestWrapper>();
                    for(Loan__c loan:insertedRecs){
                        InsertRequestWrapper insertWrapper = new InsertRequestWrapper(INSERT_OPERATION,loan.Id,mapOfAccounts.get(loan.AccountId).AccountNumber,loan.Amount__c);
                        insertWrapperList.add(insertWrapper);
                    }
                    if(!insertWrapperList.isEmpty()){
                        insertReq.setBody(JSON.serialize(insertWrapperList));
                        Http http = new Http();
                        HTTPResponse insertRes = http.send(insertReq);
                        if(insertRes.getStatusCode()==200){
                            List<InsertResponseWrapper> insertRes = (List<InsertResponseWrapper>)JSON.deserialize(insertRes.getBody(), List<InsertResponseWrapper>.class);
                            if(insertRes!=null && insertRes.size()>0){
                                List<Loan__c> toUpdate = new List<Loan__c>();
                                for(InsertResponseWrapper wrapper:insertRes){
                                    Loan__c loan = new Loan__c();
                                    loan.Id = wrapper.salesforceLoanId;
                                    loan.LoanId__c = wrapper.loanId;
                                    toUpdate.add(loan);
                                }
                                if(toUpdate.size()>0){
                                    Database.SaveResult[] results = Database.update(toUpdate);
                                    for(Integer i=0;i<results.size();i++){
                                        if(!results.get(i).isSuccess()){
                                            Database.Error dbError = results.get(i).getErrors().get(0);
                                            String recId = toUpdate[i].get('Id');
                                            Logger.info('Loan Rec - '+recId+ ' failed:'+'\n'+dbError.getMessage());
                                        }
                                    }
                                }
                            }
                        }else{
                            Logger.info('Insert Request Failed :'+insertRes.getStatus());
                        }
                    }
                }
            }
        } catch (Exception e) {
            Logger.info('Insert Operation Failed :'+e.getMessage());
        } finally {
            Logger.saveLog();
        }

    }

    @future(callout=true)
    public static void loanOnUpdate(String recs) {

        if(String.isBlank(recs))
            return;
        try {
            HttpRequest updateReq = new HttpRequest();
            updateReq.setEndpoint('callout:Loan_Lenders_Credential/updateLoans');
            updateReq.setMethod('POST');
            updateReq.setHeader('Content-Type', 'application/json');

            List<Loan__c> updatedRecs = (List<Loan__c>)JSON.deserialize(recs, List<Loan__c>.class);

            if(updatedRecs!=null && !updatedRecs.isEmpty()){

                Set<Id> accIds = new Set<Id>();
                for(Loan__c loan:updatedRecs){
                    accIds.add(loan.AccountId);
                }

                if(accIds.size()>0){
                    Map<Id,Account> mapOfAccounts = new Map<Id,Account>([SELECT Id,AccountNumber from Account WHERE Id IN:accIds]);
                    List<UpdateRequestWrapper> updateReqWrapperList = new List<UpdateRequestWrapper>();
                    for(Loan__c loan:updatedRecs){
                        UpdateRequestWrapper reqWrapper = new UpdateRequestWrapper(UPDATE_OPERATION,loan.LoanId__c,mapOfAccounts.get(loan.AccountId),loan.Amount__c);
                        updateReqWrapperList.add(reqWrapper);
                    }            
                    if(updateReqWrapperList.size()>0){
                        updateReq.setBody(JSON.serialize(updateReqWrapperList));
                        Http http = new Http();
                        HTTPResponse updateRes = http.send(updateReq);
                        if(updateRes.getStatusCode()==200){
                            //If anything needed on success
                        }
                        else{
                            Logger.info('Update Request failed :'+updateRes.getStatus());
                        }
                    }
                }

            }
        }
        catch (Exception e) {
            Logger.info('Update Operation Failed :'+e.getMessage());
        } finally {
            Logger.saveLog();
        }
    }

    @future(callout=true)
    public static void loanOnDelete(List<String> loanExternalIds) {

        if(loanExternalIds.isEmpty())
            return;
        try {
            HttpRequest deleteReq = new HttpRequest();
                deleteReq.setEndpoint('callout:Loan_Lenders_Credential/deleteLoans');
                deleteReq.setMethod('POST');
                deleteReq.setHeader('Content-Type', 'application/json');

                List<DeleteRequestWrapper> deleteReqLists = new List<DeleteRequestWrapper>();
                for(String s : loanExternalIds){
                    DeleteRequestWrapper delReq = new DeleteRequestWrapper(DELETE_OPERATION,s);
                    deleteReqLists.add(delReq);
                }
                if(deleteReqLists.size()>0){
                    deleteReq.setBody(JSON.serialize(deleteReqLists));
                        Http http = new Http();
                        HTTPResponse deleteRes = http.send(deleteReq);
                        if(deleteRes.getStatusCode()==200){
                            //If anything needed on success
                        }
                        else{
                            Logger.info('Delete Request failed :'+deleteRes.getStatus());
                        }
                }

        } catch (Exception e) {
            Logger.info('Delete Operation Failed :'+e.getMessage());
        } finally {
            Logger.saveLog();
        } 
    }

    public class InsertRequestWrapper {
        public static String operation;
        public static String salesforceLoanId;
        public static String accountNumber;
        public static Integer amount;

        public InsertRequestWrapper(String opr, String sfId, String accNo, Integer amount ){
            this.operation = opr;
            this.salesforceLoanId = sfId;
            this.accountNumber = accNo;
            this.amount = amount;
        }        
    }

    public class InsertResponseWrapper {
        public static String loanId;
        public static String salesforceLoanId;
    }

    public class UpdateRequestWrapper {
        public static String operation;
        public static String loanId;
        public static String accountNumber;
        public static Integer amount;

        public UpdateRequestWrapper(String opr, String loanId, String accNo, Integer amount ){
            this.operation = opr;
            this.loanId = loanId;
            this.accountNumber = accNo;
            this.amount = amount;
        }
    }

    public class DeleteRequestWrapper {
        public static String operation;
        public static String loanId;

        public UpdateRequestWrapper(String opr, String loanId){
            this.operation = opr;
            this.loanId = loanId;
        }
    }

}