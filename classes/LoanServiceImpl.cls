public with sharing class LoanServiceImpl implements LoanService{
 
    private static LendingSystemIntegration lendSys = new LendingSystemIntegration();

    public static void sendLoanToLendingSysOnInsert(List<Loan__c> newLoans){
        TriggerStopper.stopLoanRecurring = true;
        lendSys.loanOnInsert(JSON.serialize(newLoans));
    }

    public static void sendLoanToLendingSysOnUpdate(List<Loan__c> updatedLoans,Map<Id,Loan__c> oldLoans){
        TriggerStopper.stopLoanRecurring = true;
        List<Loan__c> loansToUpdate = new List<Loan__c>();
        if(updatedLoans.size()>0){
            for(Loan__c loan:updatedLoans){
                if(loan.AccountId!=oldLoans.get(loan.Id).AccountId || loan.Amount__c!=oldLoans.get(loan.Id).Amount__c) {
                    loansToUpdate.add(loan);
                }
            }
            if(loansToUpdate.size()>0){
                lendSys.loanOnInsert(JSON.serialize(loansToUpdate));
            }
        }
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