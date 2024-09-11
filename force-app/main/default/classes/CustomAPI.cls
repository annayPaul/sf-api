@RestResource(urlMapping='/test/*')
global with sharing class CustomAPI {
    @HttpGet
    global static String doGet(){
        RestRequest request = RestContext.request;
        String pathParams = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
        String result = '';
        
        if(pathParams.equals('')){
            List<Account> acc = [SELECT Id FROM Account];
            for(Account a : acc){
                result += a.Id + '  ';
            }
        }
        else{
            List<Account> accounts = [SELECT Id, Name, Industry, NumberOfEmployees, Phone, ShippingAddress, ShippingCity, ShippingCountry, ShippingState, Type, Website FROM Account WHERE Id = :pathParams LIMIT 1];
            Account acc = accounts[0];
            result += 'Name: ' + acc.Name + '\n\r';
            result += 'Industry: ' + acc.Industry + '\n\r';
            result += 'Number of Employees: ' + acc.NumberOfEmployees + '\n\r';
            result += 'Phone Number: ' + acc.Phone + '\n\r';
            result += 'Shipping Address: ' + acc.ShippingAddress + '\n\r';
            result += 'Shipping City: ' + acc.ShippingCity + '\n\r';
            result += 'Shipping Country: ' + acc.ShippingCountry + '\n\r';
            result += 'Shipping State: ' + acc.ShippingState + '\n\r';
            result += 'Type: ' + acc.Type + '\n\r';
            result += 'Website: ' + acc.Website + '\n\r';
        }
        return result;
    }
}