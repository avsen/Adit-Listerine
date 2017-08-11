
IF OBJECT_ID('[dbo].[sp_afterCollege_V2]') IS NULL -- Check if SP Exists
 EXEC('CREATE PROCEDURE [dbo].[sp_afterCollege_V2] AS SET NOCOUNT ON;') -- Create dummy/empty SP
GO
ALTER PROCEDURE [dbo].[sp_afterCollege_V2] 
	
	
	@RunDate nvarchar(10)
	


AS
	
BEGIN
   BEGIN TRY
	SET NOCOUNT ON;
	/* --Common Table Expression SiteId_CTE to convert Charge Types into csv SiteIds */WITH siteid_cte
     AS (SELECT Outer_ol.orderid, 
                Outer_ol.linenumber, 
                Stuff((SELECT ', ' + ( CASE Inner_ct.chargetypename 
                                         WHEN 'AfterCollege' THEN 'acdc' 
                                         WHEN 'Call Center' THEN 
                                         'custcarefeb2011' 
                                         WHEN 'Diversity1' THEN 'div1jan2011' 
                                         WHEN 'Diversity2' THEN 'div2jan2011' 
                                         WHEN 'Education' THEN 'edujul2012' 
                                         WHEN 'Energy' THEN 'energyjan2011' 
                                         WHEN 'Green Employer' THEN 
                                         'greenjan2011' 
                                         WHEN 'Healthcare' THEN 'hcjan2011' 
                                         WHEN 
                              'Healthcare & Nursing Network Combo' 
                                       THEN 
                                         'hcrnjan2011' 
                                         WHEN 'IT' THEN 'itdec2011' 
                                         WHEN 'Manufacturing/Engineering' THEN 
                                         'manjun2013' 
                                         WHEN 'MaxRecruit' THEN 'maxrecnov2014' 
                                         WHEN 'Nursing Only' THEN 'nursejan2011' 
                                         WHEN 'Sales' THEN 'salesmarketjun2013' 
                                         WHEN 'Social' THEN 'socnwtaug2012' 
                                         WHEN 'Trucking/Transportation' THEN 
                                         'trucksep2012' 
                                         WHEN 'Veterans' THEN 'veteransfeb2011' 
                                         ELSE 'Unknown Website' 
                                       END ) 
                       FROM   [vworder] Inner_o 
                              JOIN [vworderline] Inner_ol 
                                ON Inner_ol.orderid = Inner_o.orderid 
                              JOIN [Order].orderlinecharge Inner_c 
                                ON Inner_c.orderlineid = Inner_ol.orderlineid 
                              JOIN pricingglobal.chargetype Inner_ct 
                                ON Inner_c.chargetypename = 
                                   Inner_ct.chargetypename 
                                   AND chargetypedescription = 
                                       'Aftercollege.com' 
                       WHERE  Inner_ol.orderid = Outer_ol.orderid 
                              AND Inner_ol.linenumber = Outer_ol.linenumber 
                       FOR xml path('')), 1, 1, '') AS SiteId 
         FROM   [vworder] Outer_o 
                JOIN [vworderline] Outer_ol 
                  ON outer_ol.orderid = outer_o.orderid 
                JOIN [Order].orderlinecharge c 
                  ON c.orderlineid = outer_ol.orderlineid 
                JOIN pricingglobal.chargetype ct 
                  ON c.chargename = ct.chargetypename 
                     AND chargetypedescription = 'Aftercollege.com' 
         WHERE  Outer_ol.businessunitabbreviation IN ( 'OSC', 'SDT' ) 
                /* OSC     'OSC'     -- <<< should be a parameter */ 
                AND Outer_ol.productname = 'AfterCollege.com' 
                /* AfterCollege.com -- <<< should be a parameter */ 
                AND Outer_ol.rundate = '12/25/2016' 
                /* mm-dd-ccyy   -- <<< should be a parameter */ 
                AND Outer_ol.orderid = Outer_o.orderid 
         GROUP  BY Outer_ol.orderid, 
                   Outer_ol.linenumber) 
/*  -- End of Common Table Expression  */ 
SELECT DISTINCT o.orderid, 
                ol.linenumber, 
                ol.businessunitabbreviation                        BU, 
                CONVERT(CHAR(12), ol.rundate, 101)                 RunDate, 
                ol.producttypename, 
                ol.productname, 
                CASE ol.businessunitabbreviation 
                  WHEN 'ALT' THEN '1158' 
                  WHEN 'TBS' THEN '1165' 
                  WHEN 'CTC' THEN '1160' 
                  WHEN 'DPR' THEN '1162' 
                  WHEN 'HTC' THEN '1163' 
                  WHEN 'LAT' THEN '1012' 
                  WHEN 'OSC' THEN '1165' 
                  WHEN 'SSC' THEN '1840' 
                  WHEN 'SDT' THEN '1534' 
                  ELSE '9999' 
                END                                                AS DFID, 
                (SELECT siteid_cte.siteid 
                 FROM   siteid_cte 
                 WHERE  siteid_cte.orderid = ol.orderid 
                        AND siteid_cte.linenumber = ol.linenumber) AS SiteId1, 
                ol.class,/* --ct.ChargeTypeName, */ /* --c.Amount, */ 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'JobContactName' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS 
                JobContactName, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'CompanyName' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS 
                CompanyName, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'EmployerAddress' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS 
                EmployerAddress, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'EmployerCity' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS 
                EmployerCity, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'EmployerState' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS 
                EmployerState, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'EmployerZip' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS 
                EmployerZip, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'Fax' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS Fax, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'ContactEmail' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS 
                ContactEmail, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'ApplyURL' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS ApplyURL, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'EmployerDescription' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS 
                EmployerDescription, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'JobTitle' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS JobTitle, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'JobLocationCity' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS 
                JobLocationCity, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'JobLocationState' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS 
                JobLocationState, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'JobLocationZip' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS 
                JobLocationZip, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'WorkType' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS WorkType, 
                CASE (SELECT TOP 1 ola.attributevalue 
                      FROM   [Order].[orderlineattribute] ola 
                             INNER JOIN [Global].[attributedefinition] ad 
                                     ON ad.attributeid = ola.attributeid 
                      WHERE  ola.orderlineid = ol.orderlineid 
                             AND ad.attributename = 'WorkType' 
                             AND ( ola.attributevalue IS NOT NULL 
                                    OR ola.attributevalue != '' )) 
                  WHEN 'Full-Time' THEN '1' 
                  WHEN 'Intern/Co-op' THEN '3' 
                  WHEN 'Part-Time' THEN '4' 
                  ELSE '1' 
                END                                                AS 
                WorkTypeCode, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'JobDescription' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS 
                JobDescription, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'Qualifications' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS 
                Qualifications, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'Industry' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS Industry, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'JobType' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS JobType, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'StartDate' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS StartDate, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'EndDate' 
                        AND ( ola.attributevalue IS NOT NULL 
                               OR ola.attributevalue != '' ))      AS EndDate 
/*--,*/ 
FROM   [vworder] o 
       JOIN [vworderline] ol 
         ON OL.orderid = O.orderid 
       JOIN [Order].orderlinecharge c 
         ON c.orderlineid = ol.orderlineid 
       JOIN pricingglobal.chargetype ct 
         ON c.chargetypename = ct.chargetypename 
            AND chargetypedescription = 'Aftercollege.com' 
WHERE  ol.businessunitabbreviation IN ( 'OSC', 'SDT' ) 
       /* --  OSC   'OSC'      <<< should be a parameter  */ 
       AND ol.productname = 'AfterCollege.com' 
       /* --  Aftercollege.com <<< should be a parameter  */ 
       AND ol.rundate = @RunDate 
       /* --  mm-dd-ccyy       <<< should be a parameter  */ 
       AND o.orderroutingid IN ( 1, 4 ) /* -- Fulfill (not Bill Only)    */ 
       AND o.statusid IN ( 2, 4, 6, 7, 10 ) 
/* -- 2=Submitted, 4=Changed, 6=Change Pending, 7=Processed, 10=Invoiced */ 
       AND ol.statusid IN ( 2, 4, 6, 7, 10 ) 
ORDER  BY o.orderid, 
          ol.linenumber  
END TRY
 BEGIN CATCH
    IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION;
 
    DECLARE @ErrorNumber INT = ERROR_NUMBER();
    DECLARE @ErrorLine INT = ERROR_LINE();
 
    PRINT 'Actual error number: ' + CAST(@ErrorNumber AS VARCHAR(10));
    PRINT 'Actual line number: ' + CAST(@ErrorLine AS VARCHAR(10));
 
    THROW;
  END CATCH
  END
GO

