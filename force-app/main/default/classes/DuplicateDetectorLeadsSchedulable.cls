/**
 * @File Name          : DuplicateDetectorLeadsSchedulable.cls
 * @Description        : Implements the Schedulable class to make the
                         DuplicateDetectorLeads Schedulable.
 * @Author             : Mahesh Biswas
 * @Last Modified By   : Mahesh Biswas
 * @Last Modified On   : 8/26/2019, 2:37:47 PM
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    8/26/2019, 2:33:49 PM   Mahesh Biswas     Initial Version
**/
public class DuplicateDetectorLeadsSchedulable implements Schedulable {

    /**
    * @description  Makes the Duplicate Detector Leads Class Schedulable.
    *               To be scheduled every 3 hour. <0 0 * /3 ? * *>
    * @author Mahesh Biswas | 8/26/2019
    * @param NONE
    * @return null
    */
	public void execute(SchedulableContext SC) {
        new DuplicateDetectorLeads();
    }
}