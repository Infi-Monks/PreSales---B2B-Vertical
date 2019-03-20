trigger Compare_OldandNewvalues on Account (before update) {
    
    for (Account acc: Trigger.new) {
        
        Account oldAccount = Trigger.oldMap.get(acc.ID);
        if(acc.AccountNumber != oldAccount.AccountNumber) {
            System.debug('--*Account Number is changed*--');
            System.debug('**Old Account Number :'+oldAccount.AccountNumber);
            System.debug('**New Account Number :'+acc.AccountNumber);
            acc.Type = 'Prospect';
        }
        else
        {
            System.debug('--**Account Number has not been Updated**--');
            acc.Type = 'Other';
        }
    }
}