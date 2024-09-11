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
            result += 'Name: ' + acc.Name + '   ';
            result += 'Industry: ' + acc.Industry + '   ';
            result += 'Number of Employees: ' + acc.NumberOfEmployees + '   ';
            result += 'Phone Number: ' + acc.Phone + '   ';
            result += 'Shipping Address: ' + acc.ShippingAddress + '   ';
            result += 'Shipping City: ' + acc.ShippingCity + '   ';
            result += 'Shipping Country: ' + acc.ShippingCountry + '   ';
            result += 'Shipping State: ' + acc.ShippingState + '   ';
            result += 'Type: ' + acc.Type + '   ';
            result += 'Website: ' + acc.Website + '   ';
        }
        return result;
    }

    @HttpPost
    global static String doPost(String name, String phone, String industry, Integer numberOfEmployees){
        Account account = new Account();
        account.Name = name;
        account.phone = phone;
        account.industry = industry;
        account.numberOfEmployees = numberOfEmployees;
        insert account;
        return account.Id;
    }
}