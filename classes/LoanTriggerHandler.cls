public without sharing class LoanTriggerHandler extends TriggerHandler{

    private LoanService LoanServ;

    public LoanTriggerHandler(){
        this.LoanServ = new LoanServiceImpl();
    }

    public override void afterInsert(TriggerContext context){
        if(!TriggerStopper.stopLoanRecurring){
            LoanServ.sendLoanToLendingSysOnInsert((List<Loan__c>)context.newList);
        }
    }   

    public override void beforeUpdate(TriggerContext context){
        if(!TriggerStopper.stopLoanRecurring){
            LoanServ.sendLoanToLendingSysOnUpdate((List<Loan__c>)context.newList, (Map<Id,Loan__c>)context.oldMap);
        }
    }

    public override void beforeDelete(TriggerContext context){
        if(!TriggerStopper.stopLoanRecurring){
            LoanServ.sendLoanToLendingSysOnDelete((List<Loan__c>)context.oldList);
        }
    }

}