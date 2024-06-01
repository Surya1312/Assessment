@isTest
private class LoanTriggerHandler_Test{

    @TestSetup
    static void makeData(){
        
        List<Account> accs = TestUtils.createAccounts(1);
        insert accs;

        List<Loan__c> loans = TestUtils.createLoans(accs[0].Id,1);
        insert loans;

    }

    @isTest
    public static void testLoanInsert() {

        List<Account> accInsert = [SELECT Id,AccountNumber__c FROM Account];
        List<Loan__c> loanToInsert = TestUtils.createLoans(accInsert[0].Id,1);
        
        Test.startTest();
        insert loanToInsert;
        Test.stopTest();

        List<Loan__c> toCheck = new List<Loan__c>();
        toCheck = [SELECT Id FROM Loan__c WHERE Name like 'Testing Loan%'];
        System.assertEquals(true, toCheck.size()>0);

    }

    @isTest
    public static void testLoanUpdate() {
        Loan__c loanToUpdate =  new Loan__c();
        loanToUpdate = [SELECT Id,AccountId,Amount__c FROM Loan__c WHERE Name like 'Testing Loan%' LIMIT 1];
        
        if(loanToUpdate!=null){
            Test.startTest();
            
            loanToUpdate.Amount__c = 2000;            
            update loanToUpdate;

            Test.stopTest();

            System.assertEquals(2000, loanToUpdate.Amount__c);
        }        
    }

    @isTest
    public static void testLoanDelete() {
        List<Loan__c> loanToDelete = new List<Loan__c>();
        loanToDelete = [SELECT Id,LoanId__c FROM Loan__c WHERE Name like 'Testing Loan%' LIMIT 1];
        String loanExternalId = loanToDelete[0].LoanId__c;
        if(loanToDelete!=null){
            Test.startTest();
            delete loanToDelete;
            Test.stopTest();

            System.assertEquals(null,[SELECT Id FROM Loan__c WHERE LoanId__c=:loanExternalId]);
        }
    }

}