public without sharing class TriggerContext {

    public List<sObject> oldList { get; set; }
    public Map<Id, sObject> oldMap { get; set; }
    public List<sObject> newList { get; set; }
    public Map<Id, sObject> newMap { get; set; }
    public Boolean isBefore { get; set; }
    public Boolean isAfter { get; set; }
    public Boolean isInsert { get; set; }
    public Boolean isUpdate { get; set; }
    public Boolean isDelete { get; set; }
    public Boolean isUndelete { get; set; }

	/**
	* @description Constructor
	* @param oldList list of old values
	* @param oldMap map with old values
	* @param newList list of new values
	* @param newMap map with new values
	* @param isBefore indicates whether trigger is before
	* @param isAfter indicates whether trigger is after
	* @param isInsert indicates whether trigger is insert
	* @param isUpdate indicates whether trigger is update
	* @param isDelete indicates whether trigger is delete
    * @param isUndelete indicates whether trigger is undelete
	*/
    public TriggerContext(List<sObject> oldList, Map<Id, sObject> oldMap, List<sObject> newList, Map<Id, sObject> newMap, Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete) {
        this.oldList = oldList;
        this.oldMap = oldMap;
        this.newList = newList;
        this.newMap = newMap;
        this.isBefore = isBefore;
        this.isAfter = isAfter;
        this.isInsert = isInsert;
        this.isUpdate = isUpdate;
        this.isDelete = isDelete;
        this.isUndelete = isUndelete;
    }

}