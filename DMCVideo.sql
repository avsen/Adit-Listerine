IF OBJECT_ID('[dbo].[sp_DMCVideo_V2]') IS NULL -- Check if SP Exists
 EXEC('CREATE PROCEDURE [dbo].[sp_DMCVideo_V2] AS SET NOCOUNT ON;') -- Create dummy/empty SP
GO


ALTER PROCEDURE [dbo].[sp_DMCVideo_V2] 
	
	@BusinessUnitAbbr nvarchar(50),
	@ProductName nvarchar(50),
	@ModifiedDate nvarchar(50)
	
	AS
	BEGIN
	BEGIN TRY	
	SET NOCOUNT ON;
	
	SELECT DISTINCT ol.orderid                                              AS 
                Ad_Number, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'CompanyName' 
                        AND ( COALESCE(ola.attributevalue, '') != '' )) AS 
                Company, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'JobTitle' 
                        AND ( COALESCE(ola.attributevalue, '') != '' )) AS 
                Position, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'JobType' 
                        AND ( COALESCE(ola.attributevalue, '') != '' )) AS 
                Category, 
                CONVERT(VARCHAR(10), ol.rundate, 126)                   AS 
                StartDate, 
                CONVERT(VARCHAR(10), vwOLD.enddate, 126)                AS 
                EndDate, 
                (SELECT TOP 1 ola.attributevalue 
                 FROM   [Order].[orderlineattribute] ola 
                        INNER JOIN [Global].[attributedefinition] ad 
                                ON ad.attributeid = ola.attributeid 
                 WHERE  ola.orderlineid = ol.orderlineid 
                        AND ad.attributename = 'JobDescription' 
                        AND ( COALESCE(ola.attributevalue, '') != '' )) AS 
                Ad_Text, 
                S.onlineduration                                        AS 
                Days_Online 
FROM   [vworderline] OL 
       INNER JOIN [vworder] O 
               ON O.orderid = OL.orderid 
       JOIN vworderlinedetail vwOLD 
         ON vwOLD.orderlineid = OL.orderlineid 
       JOIN [vwsection] S 
         ON S.sectionid = ol.sectionid 
       JOIN [Order].orderlinecharge c 
         ON c.orderlineid = OL.orderlineid 
       JOIN pricingglobal.chargetype ct 
         ON c.chargetypename = ct.chargetypename 
WHERE  ol.businessunitabbreviation = @BusinessUnitAbbr 
       /*-- <<< 'SDT' should be a parameter */ 
       AND ol.productname = @ProductName 
       /*-- <<< 'careerbuilder.com' should be a parameter */ 
       AND CONVERT(VARCHAR(10), o.modifieddate, 101) = @ModifiedDate 
       /*-- dd/MM/yyyy format*/ /* and o.ModifiedDate <= '06/02/2016'*/ 
       /*-- <<< 'System Date' should be a parameter */ 
       /* and o.ModifiedDate >= '06/02/2016'  */ 
       /*-- <<< 'System Date' should be a parameter */ 
       AND o.orderroutingid IN ( 1, 4 ) /*-- Fulfill (not Bill Only) */ 
       AND o.statusid IN ( 2, 4, 6, 7, 10 ) 
/*-- 2=Submitted, 4=Changed, 6=Change Pending, 7=Processed, 10=Invoiced */ 
       AND ol.statusid IN ( 2, 4, 6, 7, 10 ) 
       AND ct.chargetypename IN ( 'Video7', 'Video30' ) 
ORDER  BY ad_number 
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

