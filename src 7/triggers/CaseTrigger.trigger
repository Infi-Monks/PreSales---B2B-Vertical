trigger CaseTrigger on Case (before insert) {
    Set<String> caseSubs = new Set<String>();
    Set<Id> caseIds = new Set<Id>();
    List<Id> caseContactIds = new List<Id>();
    List<Case> listCases = new List<Case>();
       
    Map<String, Id> mapCasSubId = new Map<String, Id>(); 
        
    System.debug('1'); 
    for(Case cas : trigger.new) {
        String caseSubject = '';
        caseSubject = cas.Subject;
        if(caseSubject != '' && caseSubject != NULL){
            //caseSubs.add(caseSubject.replace('Re: ',''));
            caseContactIds.add(cas.ContactId);
        }
    }
    system.debug('Case Subject:' + caseSubs);
    listCases = [SELECT Id, Subject, Description FROM Case WHERE Subject IN : caseSubs and ContactId IN: caseContactIds and CreatedDate = Today];
    System.debug(listCases);

    if(listCases.size() > 0) {
        for(Case cas : listCases) {
            mapCasSubId.put(cas.Subject, cas.Id);
            caseIds.add(cas.Id);
        }                   

        for(Case cas : trigger.new) {
            String caseSubject = cas.Subject;
            if(caseSubject !=null && mapCasSubId.containsKey(caseSubject)) {
                cas.Status = 'Closed as Duplicate';
            }
        }
    }
}