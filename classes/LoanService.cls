public interface LoanService{    

    void sendLoanToLendingSysOnInsert(List<Loan__c> newLoans);
    
    void sendLoanToLendingSysOnUpdate(List<Loan__c> updatedLoans);
    
    void sendLoanToLendingSysOnDelete(List<Loan__c> deletedLoans);

}