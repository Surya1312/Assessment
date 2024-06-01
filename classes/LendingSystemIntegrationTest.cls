@isTest
public class LendingSystemIntegrationTest {

    @TestSetup
    static void makeData(){
        List<Account> accs = TestUtils.createAccounts(1);
        insert accs;

        List<Loan__c> loans = TestUtils.createLoans(accs[0].Id,1);
        insert loans;
    }
    
    @IsTest
    static void testInsertAPI(){
        Test.setMock(HttpCalloutMock.class, new MockResponseGenerator());
        
        List<Loan__c> loans = [SELECT Id,LoanId__c,Amount__c FROM Loan__c];

        Test.startTest();      
        HttpResponse res = LendingSystemIntegration.loanOnInsert(JSON.serialize(loans));
        Test.stopTest();

        String contentType = res.getHeader('Content-Type');
        String actualValue = res.getBody();
        System.assert(contentType == 'application/json');       
        System.assertEquals(actualValue, '{loanId:"loan-123456"}');
        
    }

    @IsTest
    public static void testUpdateAPI() {
        Test.setMock(HttpCalloutMock.class, new MockResponseGenerator());

        List<Loan__c> loans = [SELECT Id,LoanId__c,Amount__c FROM Loan__c];

        Test.startTest();      
        HttpResponse res = LendingSystemIntegration.loanOnUpdate(JSON.serialize(loans));
        Test.stopTest();

        System.assertEquals(200, res.getStatusCode());
    }

    @isTest
    public static void testDeleteAPI() {
        Test.setMock(HttpCalloutMock.class, new MockResponseGenerator());

        List<Loan__c> loans = [SELECT Id,LoanId__c,Amount__c FROM Loan__c WHERE Name='Testing Loan 1' LIMIT 1];

        Test.startTest();      
        HttpResponse res = LendingSystemIntegration.loanOnDelete(loans[0].LoanId__c);
        Test.stopTest();

        System.assertEquals(200, res.getStatusCode());
    }

}