@isTest
public class TestUtils {

    public static List<Account> createAccounts( Integer noOfAccs) {

        if(noOfAccs<=0)
            return;

        List<Account> accs = new List<Account>();
        for(Integer i=0;i<noOfAccs;i++){
            Account acc = new Account(
                Name = 'Test Account '+i,
                BillingCity = 'Calgary',
                BillingState = 'Alberta',
                BillingCountry = 'Canada',
                AccountNumber__c = 234282 +i
            );
            accs.add(acc);
        }
        return accs;
    }
    
    public static List<loan__c> createLoans(String accId, Integer noOfLoans) {
        
        if(noOfLoans<=0 || String.isBlank(accId))
            return;
        
        List<Loan__c> loans = new List<Loan__c>();
        for(Integer i=0;i<noOfLoans;i++){
            Loan__c loan = new Loan__c(
                Name = 'Testing Loan '+i,
                Active__c = true,
                AccountId = acc.Id,
                Amount__c = 1000 + i
            );
            loans.add(loan);
        }
        return loans;
    }

}