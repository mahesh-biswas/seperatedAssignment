/*
    CLASS:  AggregateFunction
    ------------------------------------------------------------------
    This Class is for performing Aggregate SOQL Queries.
    ------------------------------------------------------------------
    Version#        Developer       Date        Description
        1           Mahesh Biswas   23/July/19  Created the class for
                                                performing Aggregate
                                                Functions in SOQL.
*/
public with sharing class AggregateFunction {

    /**
        This creates a Map whose Key is Sum of amount and Value is the
        Year in which the total amount is given.

        OUESTIONS:
        Write a SOQL query to retrieve sum of all closed Opportunity amount
        for current fiscal year. Store this information in a map with
        key as year and value as sum of amount. Iterate this map to display statistics.
    */
    public Map<Integer,Decimal> getMapSumOfAmountAndFiscalYear(){
        Map<Integer, Decimal> yearAmtMap = new Map<Integer, Decimal>();
        for(AggregateResult aggResult : [
                SELECT
                    SUM(Amount) totalSum,
                    FiscalYear
                FROM
                    Opportunity
                WHERE
                    IsClosed = true
                GROUP BY
                    FiscalYear
                ORDER BY
                    FiscalYear
        ]   ){
            yearAmtMap.put(
                (Integer)aggResult.get('FiscalYear'),
                (Decimal)aggResult.get('totalSum')
            );
        }
        System.debug('Year\tAmount');
        for(Integer year : yearAmtMap.keySet()){
            System.debug(year+'\t'+yearAmtMap.get(year));
        }
        return yearAmtMap;
    }

    /**
        This methos just retrieves and displays the LeadSource with distinct
        sources and whose count is greater than 10.

        OUESTIONS:
        Find total number of distinct Lead records on basis of 'Lead Source'
        having greater than 10 leads. Print this information.
    */
    public Map<String,Integer> distinctLeadSourcesWithMoreRecords(){
        System.debug('Lead Source  Lead Count');
        Map<String, Integer> leadSourceAndCountMap = new Map<String, Integer>();
        for(AggregateResult aggResult : [
                SELECT
                    COUNT(Name) nameCount,
                    LeadSource
                FROM
                    Lead
                GROUP BY
                    LeadSource
                HAVING
                    COUNT(Name) > 10
        ]   ){
            leadSourceAndCountMap.put(
                (String)aggResult.get('LeadSource'),
                (Integer)aggResult.get('nameCount')
            );
            System.debug(aggResult.get('LeadSource') + ' ' + aggResult.get('nameCount'));
        }
        return leadSourceAndCountMap;
    }

    /**
        This methos gives Map of Map where the first Maps's Key is the Lead's status.
        and the value is another map whose key is the different Lead Sources ans value
        is the count of that category.

        OUESTIONS:
        Write a SOQL query to find total number of Lead records by status by Lead Source.
        Store this information in map and display the same.
        (Hint: Map<String, Map<String, Integer>>)
    */
    public Map<String, Map<String, Integer>> getMapStatusAndMapSouceAndCount(){
        Map<String, Map<String,I nteger>> statSourceCountMap =
            new Map<String, Map<String, Integer>>();
        for(AggregateResult aggResult : [
                SELECT
                    COUNT(Name) nameCount,
                    Status,
                    LeadSource
                FROM
                    Lead
                GROUP BY
                    LeadSource,
                    Status
                ORDER BY
                    Status,
                    LeadSource
            ]
        ){
            Map<String,Integer> tempInstanceOfMap;
            if(statSourceCountMap.containsKey( (String)aggResult.get('Status') )){
                tempInstanceOfMap = statSourceCountMap.get( (String)aggResult.get('Status') );
            }else{
                tempInstanceOfMap = new Map<String,Integer>();
            }
            tempInstanceOfMap.put(
                (String)aggResult.get('LeadSource'),
                (Integer)aggResult.get('nameCount')
            );
            statSourceCountMap.put( (String)aggResult.get('Status') , tempInstanceOfMap );
        }
        System.debug(statSourceCountMap);
        return statSourceCountMap;
    }

}