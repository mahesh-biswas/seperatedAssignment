/*
    CLASS:  AggregateFunctionTest
    ----------------------------
    This is a Test Class for AggregateFunction.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   25/July/19  Created test class for the Aggregate Function
                                                Testing.
                                                Tests the functionality in Aggregate Function class.
*/
@isTest
public with sharing class AggregateFunctionTest {

    /**
        Populates the Opportunity records, in order to have fiscal year generated.
        We have to generate/populate the closedate field.
    */
    @isTest
    public static void getMapSumOfAmountAndFiscalYear(){
        List<Opportunity> opportunityList = new List<Opportunity>();
        for(Opportunity oppItr : TestDataFactory.createOpportunityWithNameStageAndRandomCloseDate(
                                    20,
                                    'fiscal year 2012',
                                    'Closed Won',
                                    False
                                )
        ){
            oppItr.closeDate = Date.newInstance(2012,08,2);
            oppItr.amount = 1000;
            opportunityList.add(oppItr);
        }
        for(Opportunity oppItr : TestDataFactory.createOpportunityWithNameStageAndRandomCloseDate(
                                    20,
                                    'fiscal year 2014',
                                    'Closed Won',
                                    False
                                )
        ){
            oppItr.closeDate = Date.newInstance(2014,08,2);
            oppItr.amount = 2000;
            opportunityList.add(oppItr);
        }
        insert opportunityList;
        System.Test.startTest();
        Map<Integer,Decimal> resultMap =
                                new AggregateFunction().getMapSumOfAmountAndFiscalYear();
        System.Test.stopTest();
        System.assertEquals(
            1000*20,
            resultMap.get(2012),
            'comparing the amount inserted for fiscal year 2012 is same as retrieved'
        );
        System.assertEquals(
            2000*20,
            resultMap.get(2014),
            'comparing the amount inserted for fiscal year 2014 is same as retrieved'
        );
    }

    /**
        Populates the Lead records, with different sources. Then compare it with results.
    */
    @isTest
    public static void distinctLeadSourcesWithMoreRecords(){
        List<Lead> leadList = new List<Lead>();
        for(Lead leadItr : TestDataFactory.createLeadWithName(12, 'web source name', True)){
            leadItr.LeadSource = 'Web';
            leadItr.Company = leadItr.LeadSource+'company';
            leadList.add(leadItr);
        }
        for(Lead leadItr : TestDataFactory.createLeadWithName(30, 'Phone source name', True)){
            leadItr.LeadSource = 'Phone Inquiry';
            leadItr.Company = leadItr.LeadSource+'company';
            leadList.add(leadItr);
        }
        for(Lead leadItr : TestDataFactory.createLeadWithName(36, 'Purchase source name', True)){
            leadItr.LeadSource = 'Purchased List';
            leadItr.Company = leadItr.LeadSource+'company';
            leadList.add(leadItr);
        }
        insert leadList;
        System.Test.startTest();
        Map<String,Integer> resultMap =
                                new AggregateFunction().distinctLeadSourcesWithMoreRecords();
        System.Test.stopTest();
        System.assertEquals(
            12,
            resultMap.get('Web'),
            'comparing the count with source WEB'
        );
        System.assertEquals(
            30,
            resultMap.get('Phone Inquiry'),
            'comparing the count with source Phone Inquiry'
        );
        System.assertEquals(
            36,
            resultMap.get('Purchased List'),
            'comparing the count with source Purchased List'
        );
    }

    @isTest
    public static void getMapStatusAndMapSouceAndCount(){
        List<Lead> leadList = new List<Lead>();
        final String STATUS_OPEN = 'Open - Not Contacted';
        final String STATUS_WORKING = 'Working - Contacted';
        final String STATUS_CLOSED = 'Closed - Converted';
        final String SOURCE_WEB = 'Web';
        final String SOURCE_PHONE = 'Phone Inquiry';
        final String SOURCE_PURCHASE = 'Purchased List';
        //  WEB    OPEN    10
        for(Lead leadItr : TestDataFactory.createLeadWithName(10, 'web open-nc name', True)){
            leadItr.LeadSource = SOURCE_WEB;
            leadItr.Status = STATUS_OPEN;
            leadItr.Company = leadItr.LeadSource+'company';
            leadList.add(leadItr);
        }
        //  WEB    WORKING    6
        for(Lead leadItr : TestDataFactory.createLeadWithName(6, 'web working-c name', True)){
            leadItr.LeadSource = SOURCE_WEB;
            leadItr.Status = STATUS_WORKING;
            leadItr.Company = leadItr.LeadSource+'company';
            leadList.add(leadItr);
        }
        //  PHONE    WORKING    30
        for(Lead leadItr : TestDataFactory.createLeadWithName(30, 'Phone working name', True)){
            leadItr.LeadSource = SOURCE_PHONE;
            leadItr.Status = STATUS_WORKING;
            leadItr.Company = leadItr.LeadSource+'company';
            leadList.add(leadItr);
        }
        //  PURCHASE    CLOSED    36
        for(Lead leadItr : TestDataFactory.createLeadWithName(36, 'Purchase converted name', True)){
            leadItr.LeadSource = SOURCE_PURCHASE;
            leadItr.Status = STATUS_CLOSED;
            leadItr.Company = leadItr.LeadSource+'company';
            leadList.add(leadItr);
        }
        //  PURCHASE    WORKING    24
        for(Lead leadItr : TestDataFactory.createLeadWithName(24, 'Purchase working name', True)){
            leadItr.LeadSource = SOURCE_PURCHASE;
            leadItr.Status = STATUS_WORKING;
            leadItr.Company = leadItr.LeadSource+'company';
            leadList.add(leadItr);
        }
        //  PURCHASE    OPEN    29
        for(Lead leadItr : TestDataFactory.createLeadWithName(29, 'Purchase open name', True)){
            leadItr.LeadSource = SOURCE_PURCHASE;
            leadItr.Status = STATUS_OPEN;
            leadItr.Company = leadItr.LeadSource+'company';
            leadList.add(leadItr);
        }
        insert leadList;
        System.Test.startTest();
        Map<String, Map<String, Integer>> resultMap =
            new AggregateFunction().getMapStatusAndMapSouceAndCount();
        System.Test.stopTest();
        System.assertEquals(
            10,
            resultMap.get(STATUS_OPEN).get(SOURCE_WEB),
            'Status: OPEN, Source: Web'
        );
        System.assertEquals(
            29,
            resultMap.get(STATUS_OPEN).get(SOURCE_PURCHASE),
            'Status: OPEN, Source: Purchase'
        );
        System.assertEquals(
            6,
            resultMap.get(STATUS_WORKING).get(SOURCE_WEB),
            'Status: Working, Source: Web'
        );
        System.assertEquals(
            30,
            resultMap.get(STATUS_WORKING).get(SOURCE_PHONE),
            'Status: Working, Source: Phone'
        );
        System.assertEquals(
            24,
            resultMap.get(STATUS_WORKING).get(SOURCE_PURCHASE),
            'Status: Working, Source: Purchase'
        );
        System.assertEquals(
            36,
            resultMap.get(STATUS_CLOSED).get(SOURCE_PURCHASE),
            'Status: Working, Source: Purchase'
        );
    }
}