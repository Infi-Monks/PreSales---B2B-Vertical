/** --------------------------------------------------------------------------------------------------
* Class/Trigger Name : ContactTrigger
* Trigger to call Method in ContactTriggerHandler class
* Trigger context : After Insert
* @author   :   Vetriselvan Manoharan
------------------------------------------------------------------------------------------------------**/
trigger ContactTrigger on Contact ( before insert, after insert, after undelete ) {
    
    ContactTriggerHandler conHandler = new ContactTriggerHandler();
    Set<Id> contactIds = new Set<Id>();
    if( Trigger.isbefore ){
        if( Trigger.isInsert ){
            conHandler.UpdateBillingAddress( trigger.new ); 
        }
        else if ( Trigger.isUpdate ){
            
        }
    }
    else if ( Trigger.isafter ){
        if( Trigger.isInsert ){
            conHandler.CreateOpportunity( trigger.new );
        }
        else if ( Trigger.isUpdate ){
            
        }
        else if ( Trigger.isUndelete ){
            conHandler.UndeleteContact( trigger.new );
        }
        
    }
    
    
}