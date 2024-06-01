trigger LoanIntegrationTrigger on Loan__c(before insert, after insert, before update, after update, before Delete){
    TriggerService.onTrigger();
}