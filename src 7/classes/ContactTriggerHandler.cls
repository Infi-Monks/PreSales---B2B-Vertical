/** --------------------------------------------------------------------------------------------------
* Class/Trigger Name : 'ContactTriggerHandler'
* Class to handle functionalities of contact trigger
* @author   :   Vetriselvan Manoharan
------------------------------------------------------------------------------------------------------**/
public class ContactTriggerHandler {
    
    
    /** --------------------------------------------------------------------------------------------------
    * Method name : UpdateBillingAddress
    * Param : List of Contact - Trigger.new
    ------------------------------------------------------------------------------------------------------**/
    public void UpdateBillingAddress( List<Contact> newContactList ){ 
        Map<Id, Contact> accountContactMap = new Map<Id, Contact>();
        Map<Id, Account> accountMap = new Map<Id,Account>();
        
        for( Contact con : newContactList ) {
            accountContactMap.put(con.AccountId, con);
        }
        System.debug('Account Contact Map' + accountContactMap);
        
        List<Account> accountList = [ SELECT 
                                      BillingCity,
                                      BillingCountry,
                                      BillingPostalCode,
                                      BillingState,
                                      BillingStreet 
                                      FROM Account WHERE ID IN : accountContactMap.keySet() ];
        
        for ( Account acc : accountList ){
            accountMap.put( acc.Id, acc );
        }
        
        System.debug('Account Map' + accountMap);
        
        for( Contact con : accountContactMap.values() ){
            System.debug('Billing City' + accountMap.get(con.AccountId).BillingCity);
            con.MailingCity = accountMap.get(con.AccountId).BillingCity;
            con.MailingStreet = accountMap.get(con.AccountId).BillingStreet;
            con.MailingState = accountMap.get(con.AccountId).BillingState;
            con.MailingCountry = accountMap.get(con.AccountId).BillingCountry;
            con.MailingPostalCode = accountMap.get(con.AccountId).BillingPostalCode;
        }
        
    }
    
    
    /** --------------------------------------------------------------------------------------------------
    * Method name : UpdateBillingAddress1
    * Param : List of Contact - Trigger.new
    ------------------------------------------------------------------------------------------------------**/
    public void UpdateBillingAddress1 ( Set<Id> newContactIds ){
        
        Contact[] contactList = [SELECT Account.BillingCity, Account.BillingCountry, Account.BillingState, Account.BillingStreet FROM Contact Where Id IN:newContactIds];
        List<Contact> contactsToUpdate = new List<Contact>();
    
        for(Contact c : contactList){
            c.MailingCity = c.Account.BillingCity;
            c.MailingCountry = c.Account.BillingCountry;
    		c.MailingState = c.Account.BillingState;
            c.MailingStreet = c.Account.BillingStreet;
            contactsToUpdate.add(c);
        }
        
        if( contactsToUpdate.size() > 0 ){
            update contactsToUpdate;
        }
    }
    
    /** --------------------------------------------------------------------------------------------------
    * Method name : UndeleteContact
    * Param : List of Contact - Trigger.new
    ------------------------------------------------------------------------------------------------------**/
    public void CreateOpportunity ( List<Contact> contactList ){
        List<Opportunity> newOppsToCreate = new List<Opportunity>();
        Set<Id> accIds = new Set<Id>();
        for( Contact con : contactList ){
            accIds.add(con.AccountId);
        }
        System.debug(accIds);
        List<Account> accList =  [ SELECT Id, Name FROM Account WHERE Id IN :accIds ];
        
        for ( Account acc : accList ){
            Opportunity opp = new Opportunity();
            opp.Name        = acc.Name + ' Opportunity';
            opp.StageName   = 'Prospecting';
            opp.CloseDate   = Date.today() + 90;
            opp.AccountId   = acc.Id; // Use the trigger record's ID
            newOppsToCreate.add(opp);
        }
        System.debug(newOppsToCreate);
        if( newOppsToCreate.size() > 0 ) {
            insert newOppsToCreate;
        } 
        
    }
    
    /** --------------------------------------------------------------------------------------------------
    * Method name : UpdateContactDescription
    * Param : Contact Map
    ------------------------------------------------------------------------------------------------------**/
    public void UpdateContactDescription( Map<Id,Contact> contactMap){
        Map<Id,contact> map1 = new Map<Id,contact>();
        for(contact con : contactMap.values()){
            map1.put(con.AccountId,con);
        }
        Map<Id,Account> map2 = new Map<Id,Account>([SELECT Id ,Description FROM Account WHERE Id IN :map1.keySet()]);
        
        for(Contact con : contactMap.values()){
          if(map2.get(con.AccountId).Description != NULL)
             con.Description = map2.get(con.AccountId).Description;
        }
    }
    
    /** --------------------------------------------------------------------------------------------------
    * Method name : UndeleteContact
    * Param : List of Contact - Trigger.new
    ------------------------------------------------------------------------------------------------------**/
    public void UndeleteContact ( List<Contact> undeleteContactList ) {
        List<Contact> conList = new List<Contact>();
        Set<Id> conIds = new Set<Id>();
        for( Contact con : undeleteContactList ){
             conIds.add(con.Id);
        }
        
        conList = [ SELECT Id, Is_Retrieved__c FROM Contact WHERE Id in :conIds ];
        for( Contact con : conList ){
            con.Is_Retrieved__c = true;
        }
        update conList;
    }
}