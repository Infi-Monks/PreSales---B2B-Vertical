public class grid_all_editable_ext {

    public List<Account> acctList {get; set;}

    public grid_all_editable_ext(ApexPages.StandardController controller) {
        acctList = [SELECT Id, Name, OwnerId, Phone
        				FROM Account];
    }
    
    public void save(){
	    upsert acctList;
    }
}