@isTest
global class MockResponseGenerator implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {

        String endPoint = req.getEndpoint();
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if(endPoint.equals('https://loanlenders.com/insertLoans')){
            res.setBody('{loanId: "loan-123456"}');
        }
        else {
            res.setBody('Success');
        }
        res.setStatusCode(200);
        return res;
    }
}