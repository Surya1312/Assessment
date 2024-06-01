public with sharing class LoanServiceImpl implements LoanService{
 
    private static LendingSystemIntegration lendSys = new LendingSystemIntegration();

    public static void sendLoanToLendingSysOnInsert(List<Loan__c> newLoans){
        TriggerStopper.stopLoanRecurring = true;
        lendSys.loanOnInsert(JSON.serialize(newLoans));
    }

    public static void sendLoanToLendingSysOnUpdate(List<Loan__c> updatedLoans){
        TriggerStopper.stopLoanRecurring = true;
        lendSys.loanOnInsert(JSON.serialize(updatedLoans));
    }

    public static void sendLoanToLendingSysOnDelete(List<Loan__c> deletedLoans){
        TriggerStopper.stopLoanRecurring = true;
        List<String> loanExternalIds = new List<String>();
        for(Loan__c loan:deletedLoans){
            loanExternalIds.add(loan.External_Loan_Id__c);
        }
        if(!loanExternalIds.isEmpty()){
            lendSys.loanOnDelete(loanExternalIds);
        }
    }
    
}