public interface LoanService{    

    void sendLoanToLendingSysOnInsert(List<Loan__c> newLoans);
    
    void sendLoanToLendingSysOnUpdate(List<Loan__c> updatedLoans, Map<Id,Loan__c> oldLoans);
    
    void sendLoanToLendingSysOnDelete(List<Loan__c> deletedLoans);

}