IF OBJECT_ID('[dbo].[sp_DeathNotice_Fri4Mon]') IS NULL -- Check if SP Exists
 EXEC('CREATE PROCEDURE [dbo].[sp_DeathNotice_Fri4Mon] AS SET NOCOUNT ON;') -- Create dummy/empty SP
GO



ALTER PROCEDURE [dbo].[sp_DeathNotice_Fri4Mon] 

	@BusinessUnitAbbr nvarchar(50)	

AS
BEGIN
   BEGIN TRY	
	SET NOCOUNT ON;
	SELECT (SELECT TOP 1 Rtrim(Upper(ola.attributevalue)) + ', ' 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = ol.orderid) 
               AND ad.attributename = 'NameLast' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS NameLast, 
       (SELECT TOP 1 Rtrim(ola.attributevalue) + ' ' 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = ol.orderid) 
               AND ad.attributename = 'NameFirst ' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS NameFirst, 
       (SELECT TOP 1 Rtrim(ola.attributevalue) 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = ol.orderid) 
               AND ad.attributename = 'NameMiddle' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS NameMiddle 
FROM   dbo.vworderline ol 
WHERE  ol.businessunitabbreviation = @BusinessUnitAbbr /* SDT  */ 
       AND ol.statuscode IN ( 'Processed', 'Invoiced', 'Changed', 
                              'Change Pending' ) 
       AND ol.class = '91010' 
       AND ol.producttypename = 'Classified Listings' 
       AND ol.productname IN ( 'San Diego Union Tribune' ) 
       /* 'ProductHardcoded' may be a parameter */ 
       /* and ol.RunDate = '12/30/2016'        */ 
       /* mm-dd-ccyyy please make rundate a parameter */ 
       AND ol.rundate = CONVERT(CHAR(12), Dateadd(day, 3, Getdate()), 101) 
/* selects current day + 3 */ 
ORDER  BY namelast  
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

