public class TriggerService {

    public  static void onTrigger() {
        if (!Trigger.isExecuting) {
            throw new TriggerServiceException('Should be invoked by a Trigger');
        }

        // prepare context
        TriggerContext context = new TriggerContext(Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap, Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.isUndelete);
        executeActions(context);
    }

    @TestVisible
    private static void executeActions(TriggerContext context) {
        
        String sobjectType = getSObjectType(context);
        
        // instantiate handlers
        List<TriggerHandler> handlers = instantiateHandlers(sobjectType);

        // execute handlers
        for (TriggerHandler handler : handlers) {
            if (context.isBefore) {
                if (context.isInsert) {
                    handler.beforeInsert(context);
                } else if (context.isUpdate) {
                    handler.beforeUpdate(context);
                } else if (context.isDelete) {
                    handler.beforeDelete(context);
                } else if (context.isUndelete) {
                    handler.beforeUndelete(context);
                }
            } else if (context.isAfter) {
                if (context.isInsert) {
                    handler.afterInsert(context);
                } else if (context.isUpdate) {
                    handler.afterUpdate(context);
                } else if (context.isDelete) {
                    handler.afterDelete(context);
                } else if (context.isUndelete) {
                    handler.afterUndelete(context);
                }
            }
        }
    }

    // Retrieve the sObject types
    private static String getSObjectType(TriggerContext context) {
        List<SObject> sobjects = context.isDelete ? context.oldList : context.newList;
        return sobjects.getSObjectType().getDescribe().getName();
    }

    private static List<TriggerHandler> instantiateHandlers(String sType) {
        List<TriggerHandler> handlers = new List<TriggerHandler>();
        for (Trigger_Handler__mdt setting : fetchAllActiveHandlerSettings(sType)) {
            try {
                Type handlerType = Type.forName(setting.DeveloperName);
                if (handlerType <> null) {
                    handlers.add((TriggerHandler) handlerType.newInstance());
                } else {
                    System.debug(LoggingLevel.ERROR, 'TriggerService::onTrigger can\'t instantiate handler for setting: ' + setting);
                }
            } catch (Exception exp) {
                System.debug(LoggingLevel.ERROR, 'TriggerService::onTrigger exception instantiating handler for setting: ' + setting + ' Exception: ' + exp.getMessage());
            }
        }
        return handlers;
    }

    private static List<Trigger_Handler__mdt> fetchAllActiveHandlerSettings(String sType) {
        // Custom Metadata query doesn't count towards governor limits!
        List<Trigger_Handler__mdt> settings = new List<Trigger_Handler__mdt>();
        for(Trigger_Handler__mdt r : [SELECT Id, MasterLabel, DeveloperName, sType__c, Active__c, Bypass_Active__c, Bypass_Custom_Permission__c FROM Trigger_Handler__mdt WHERE sType__c =:sType AND Active__c = true ORDER BY Order__c ASC]){
            // If bypass = true and assigned to current user = don't add
            if(r.Bypass_Active__c && System.FeatureManagement.checkPermission(r.Bypass_Custom_Permission__c)){
                //You've been bypassed!
                System.debug('Trigger Bypassed: ' + r.DeveloperName);
            }else{
                settings.add(r);
            }
        }
        return settings;
    }

    // Extend the standard exception to use custom exceptions
    private class TriggerServiceException extends Exception {}
}