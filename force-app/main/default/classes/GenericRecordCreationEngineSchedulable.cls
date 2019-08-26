/**
 * @File Name          : GenericRecordCreationEngineSchedulable.cls
 * @Description        : Implements the Schedulable class to make the
                         GenericRecordCreationEngine Schedulable.
 * @Author             : Mahesh Biswas
 * @Last Modified By   : Mahesh Biswas
 * @Last Modified On   : 8/26/2019, 2:54:06 PM
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    8/26/2019, 2:52:37 PM   Mahesh Biswas     Initial Version
**/
public with sharing class GenericRecordCreationEngineSchedulable implements Schedulable {

    /**
    * @description  Makes the Duplicate Detector Leads Class Schedulable.
    *               To be scheduled every minute.
    * @author Mahesh Biswas | 8/26/2019
    * @param NONE
    * @return null
    */
	public void execute(SchedulableContext SC) {
        new GenericRecordCreationEngine();
    }
}
