
IF OBJECT_ID('[dbo].[sp_AceMobi_SDT_V2]') IS NULL -- Check if SP Exists
 EXEC('CREATE PROCEDURE [dbo].[sp_AceMobi_SDT_V2] AS SET NOCOUNT ON;') -- Create dummy/empty SP
GO
 
ALTER PROCEDURE [dbo].[sp_AceMobi_SDT_V2] -- Alter the SP Always
	 @BusinessUnitAbbr nvarchar(25),/* --SDT */
	 @RunDate nvarchar(25),			/* --12/27/2016(MM/dd/yyyy) */
	 @EndDate nvarchar(25),			/* --12/27/2016(MM/dd/yyyy) */
	 @ProductTypeName nvarchar(25), /* --Online */
	 @ProductName nvarchar(25)		/* --mobile.sduniontribune.com */
AS
BEGIN
   BEGIN TRY
 -- Insert statements for procedure here
	SELECT vwOL.businessunitabbreviation                 BU, 
       vwOL.orderid                                  AS [ad_id], 
       vwOL.materialnumber                           AS [ad_id_suffix], 
       scat.selfservicename                          AS [category], 
       scat.selfservicename                          AS [sub-category], 
       acc.advertisercodedescription                 AS [subject-title], 
       Substring(acc.advertiserclasscodevalue, 1, 1) 
       + '0000'                                      AS [placement-description], 
       acc.advertiserclasscodevalue                  AS [position-description], 
       (SELECT TOP 1 dbo.Getadcopy(orderlineid) 
        FROM   [Order].orderline ol 
        WHERE  ol.orderlineid = vwOL.orderlineid)    AS [Description], 
       CONVERT(VARCHAR(10), vwOL.[rundate], 126)     start_date, 
       vwOLD.enddate                                 AS stop_date, 
       vwC.customername, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'ContactEmail'
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS ContactEmail, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'ImagePath1' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS Photo1, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'ImagePath2' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS Photo2, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'ImagePath3' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS Photo3, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'ImagePath4' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS Photo4, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'ImagePath5' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS Photo5, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'ImagePath6' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS Photo6, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'ImagePath7' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS Photo7, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'ImagePath8' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS Photo8, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'ImagePath9' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS Photo9, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'ImagePath10' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS Photo10 
FROM   [vworderline] vwOL 
       JOIN [vworder] vwO 
         ON vwO.orderid = vwOL.orderid 
       JOIN vworderlinedetail vwOLD 
         ON vwOLD.orderlineid = vwOL.orderlineid 
       JOIN [vwcustomer] vwC 
         ON vwC.customerid = vwO.soldtocustomerid 
       JOIN global.advertiserclasscode acc 
         ON vwOL.businessunitid = acc.businessunitid 
            AND vwOL.class = acc.advertiserclasscodevalue 
       JOIN global.advertisersubcategory scat 
         ON acc.advertisersubcategoryid = scat.advertisersubcategoryid 
WHERE  vwOL.businessunitabbreviation = @BusinessUnitAbbr /* BU SDT parameter 0 */ 
       AND vwOL.[rundate] <= @RunDate /* -- should be parameter 2  */ 
       AND vwOLD.[enddate] >= @EndDate /* -- should be parameter 2 )*/ 
       AND vwOL.producttypename = @ProductTypeName 
       AND vwO.orderroutingid IN ( 1, 4 ) /*-- Fulfill (not Bill Only) */ 
       AND vwO.statusid IN ( 2, 4, 6, 7, 10 ) 
/*-- 2=Submitted, 4=Changed, 6=Change Pending, 7=Processed, 10=Invoiced */ 
       AND vwOL.statusid IN ( 2, 4, 6, 7, 10 ) 
       AND vwOL.productname = @ProductName 
/* should be a parameter 2 */ 
ORDER  BY vwOL.orderid 
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