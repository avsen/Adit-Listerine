IF OBJECT_ID('[dbo].[sp_DeathNoticeArchive]') IS NULL -- Check if SP Exists
 EXEC('CREATE PROCEDURE [dbo].[sp_DeathNoticeArchive] AS SET NOCOUNT ON;') -- Create dummy/empty SP
GO


ALTER PROCEDURE [dbo].[sp_DeathNoticeArchive] 
	@BusinessUnitAbbreviation nvarchar(50),
	@RunDate nvarchar(50),
	@class nvarchar(50)
	
AS
BEGIN
   BEGIN TRY
 -- Insert statements for procedure here	
	
		BEGIN
		SELECT vwO.orderid, 
       vwO.orderdescription, 
       vwO.lastpubdate, 
       vwC.customerid, 
       vwC.customername, 
       vwC.address1, 
       vwC.city, 
       vwC.stateterritory, 
       vwC.postalcode, 
       vwC.accounttypevalue, 
       vwC.customernumber, 
       vwC.phone, 
       vwO.salespersonnumber, 
       vwOL.[orderlineid], 
       vwOL.[rundate], 
       vwOL.class, 
       vwOL.[productname], 
       vwOL.producttypename, 
       vwOL.insertionno, 
       vwOL.linenumber, 
       vwOL.businessunitabbreviation, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'NameFirst' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS NameFirst, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'NameLast' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS NameLast, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'FuneralHomeName' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS FuneralHomeName, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'FuneralHomeContactPhone' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS FuneralHomeContactPhone, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'FuneralHomeEmail' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS FuneralHomeEmail, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'ContactName' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS ContactName, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'ContactPhone' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS ContactPhone, 
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
               AND ad.attributename = 'DateDeath' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS DateDeath, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'DateBirth' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS DateBirth, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'ObitText' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS ObitText, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'NameMiddle' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS NameMiddle, 
       (SELECT TOP 1 ola.attributevalue 
        FROM   [Order].[orderlineattribute] ola 
               INNER JOIN [Global].[attributedefinition] ad 
                       ON ad.attributeid = ola.attributeid 
        WHERE  ola.orderlineid IN (SELECT [orderlineid] 
                                   FROM   [vworderlinedetail] 
                                   WHERE  orderid = vwO.orderid) 
               AND ad.attributename = 'NameNick' 
               AND ( ola.attributevalue IS NOT NULL 
                      OR ola.attributevalue != '' )) AS NameNick, 
       app.adpagepositionid, 
       app.adnumber, 
       app.foliopage, 
       app.pspagefile 
FROM   [vworderline] vwOL 
       INNER JOIN [vworder] vwO 
               ON vwO.orderid = vwOL.orderid 
       INNER JOIN [vwcustomer] vwC 
               ON vwC.customerid = vwO.soldtocustomerid 
       LEFT OUTER JOIN [Order].adpageposition app 
                    ON vwOL.orderlineid = app.orderlineid 
/* 25APR2016 Per Deepika  */ 
/* left outer join  [Order].AdPagePosition app ON  vwOL.OrderID = app.OrderID  */ /* 21JUN2016 reverted due to DPR duplicates*/
WHERE  vwOL.businessunitabbreviation = @BusinessUnitAbbreviation /* 'ALT'  */ 
       AND vwOL.class = @class 
       AND app.zone != '?' /* 04MAY2015  per Dan Sanders */ 
       AND app.edition != '?' /* 04MAY2015  per Dan Sanders */ 
       AND vwOL.rundate = @RunDate 
       /* << '01-27-2016' should be a parameter! */ 
       AND vwOL.producttypename = 'Classified Listings' 
       AND vwO.orderroutingid IN ( 1, 4 ) /* -- Fulfill (not Bill Only) */ 
       AND vwO.statusid IN ( 2, 4, 6, 7, 10 ) 
/* -- 2=Submitted, 4=Changed, 6=Change Pending, 7=Processed, 10=Invoiced */ 
       AND vwOL.statusid IN ( 2, 4, 6, 7, 10 ) 
	END 
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

