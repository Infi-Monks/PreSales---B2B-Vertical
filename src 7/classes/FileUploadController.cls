public with sharing class FileUploadController {
 
  public Document document {
    get {
      if (document == null)
        document = new Document();
      return document;
    }
    set;
  }
 
  public PageReference upload() {
 
    document.AuthorId = UserInfo.getUserId();//Current User Id
    document.FolderId = UserInfo.getUserId();//Add Folder Id
    document.ContentType = 'image/jpeg';
    try {
      insert document;
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
      return null;
    } finally {
      document.body = null;//Clear the View State
      document = new Document();
    }
 
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Document uploaded successfully'));
    return null;
  }
}