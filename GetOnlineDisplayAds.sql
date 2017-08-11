IF OBJECT_ID('[dbo].[GetOnlineDisplayAds]') IS NULL -- Check if SP Exists
 EXEC('CREATE PROCEDURE [dbo].[GetOnlineDisplayAds] AS SET NOCOUNT ON;') -- Create dummy/empty SP
GO



ALTER PROC [dbo].[GetOnlineDisplayAds](
 @BusinessUnitAbbreviation VARCHAR(10),
 @ProductName VARCHAR(30),
 @RunDate DATETIME,
 @ChangeDate DATETIME = NULL,
 @IsDailyRun BIT = 0)
AS
BEGIN
BEGIN TRY
 SET NOCOUNT ON
 
 DECLARE @ProductName1 VARCHAR(50)
 DECLARE @ProductName2 VARCHAR(50)
 
 -- Handle special product names
 SET @ProductName1 = @ProductName
 SET @ProductName2 = @ProductName
 IF @ProductName = 'CNG_Print2Web' 
 BEGIN
   SET @ProductName2 = 'CNG_Print2Web_Magazines'
 END
 IF @ProductName = 'TBS_P2i' 
 BEGIN
   SET @ProductName2 = 'TBS_P2i_b'
 END
 
 CREATE TABLE #OnlineOrderLines (
	OrderID         INT,
	OrderLineID     INT,
	BusinessUnitID  INT,
	RunDate         DATETIME 
 )

 -- Get order numbers for specified online product & date
 IF @ChangeDate IS NOT NULL
 BEGIN
     -- Get all orders created/modified on ChangeDate
     -- that publish on/after the RunDate.
     DECLARE @ChangeStartDate DATETIME
     DECLARE @ChangeEndDate DATETIME
     SET @ChangeStartDate = @ChangeDate
     SET @ChangeEndDate = DATEADD(DAY, 1, @ChangeDate)
     INSERT INTO #OnlineOrderLines (OrderID, OrderLineID, BusinessUnitID, RunDate)
	 SELECT OrderID, OrderLineID, BusinessUnitID, RunDate
	 FROM vwOrderLineDetail
	 WHERE BusinessUnitAbbreviation = @BusinessUnitAbbreviation AND
		ProductName IN (@ProductName1, @ProductName2) AND 
		(Created  BETWEEN @ChangeStartDate AND @ChangeEndDate OR
		 Modified BETWEEN @ChangeStartDate AND @ChangeEndDate) AND
		RunDate >= @RunDate 
 END
 ELSE BEGIN
     -- Get all orders that publish on RunDate.
    IF @IsDailyRun = 1
	BEGIN
     INSERT INTO #OnlineOrderLines (OrderID, OrderLineID, BusinessUnitID, RunDate)
	 SELECT OrderID, OrderLineID, BusinessUnitID, RunDate
	 FROM vwOrderLineDetail
	 WHERE BusinessUnitAbbreviation = @BusinessUnitAbbreviation AND
		   ProductName IN (@ProductName1, @ProductName2) AND
		   DATEDIFF(d, RunDate, @RunDate) BETWEEN 0 AND 6 
	END
	ELSE
	BEGIN
     INSERT INTO #OnlineOrderLines (OrderID, OrderLineID, BusinessUnitID, RunDate)
	 SELECT OrderID, OrderLineID, BusinessUnitID, RunDate
	 FROM vwOrderLineDetail
	 WHERE BusinessUnitAbbreviation = @BusinessUnitAbbreviation AND
		   ProductName IN (@ProductName1, @ProductName2) AND 
		   RunDate = @RunDate 
	END
 END

 -- Find matching display order lines
 SELECT o.OrderID, o.OrderLineID OnlineOrderLineID, o.BusinessUnitID, MIN(d.OrderLineID) PrintOrderLineID
 INTO #OnlineDisplayOrderLines
 FROM #OnlineOrderLines o
   JOIN vwOrderLineDetail d ON d.OrderID = o.OrderID AND 
                               d.RunDate = o.RunDate
   JOIN [order].[order] ord ON ord.OrderID = d.OrderID
 WHERE d.ProductTypeName IN ('Display', 'Alternative Print') 
    AND d.StatusCode NOT LIKE 'Kill%' 
    AND d.ZoneName like
    case when @BusinessUnitAbbreviation = 'HTF'
    then '%'
    else '%Full%'
    end
    AND ord.StatusID IN (2, 4, 6, 7, 10 )  -- 2=Submitted, 4=Changed, 6=Change Pending, 7=Processed, 10=Invoiced
    AND ord.OrderTypeID = 1                -- Order (not Quote or Reservation)
    AND ord.OrderKindID NOT IN (14, 15)    -- Not spec or HFO
    AND ord.OrderRoutingID IN (1, 4)       -- Fulfill (not Bill Only)    
 GROUP BY o.OrderID, o.OrderLineID, o.BusinessUnitID
 
 SET NOCOUNT OFF

 -- Return the info
 SELECT o.ZoneName, o.BusinessUnitAbbreviation, 
        b.BusinessUnitName,
     o.ProductName OnlineProductName,
     o.SectionName OnlineSectionName,
     o.RunDate     OnlineRunDate,
     p.ProductName PrintProductName,
     p.SectionName PrintSectionName,
     p.ZoneName    PrintZoneName,
     p.RunDate     PrintRunDate,
     ord.OrderID, 
     p.MaterialNumber,
     COALESCE(ord.OrderDescription, '') OrderDescription,
     ord.SoldToCustomerNumber,
     ord.SoldToCustomer,
     ord.TotalPrice,
   (SELECT AttributeValue 
    FROM vwOrderLineAttribute
    WHERE OrderLineID = l.OnlineOrderLineID
    and AttributeName = 'StartDate') as StartDate,
    (SELECT AttributeValue 
    FROM vwOrderLineAttribute
    WHERE OrderLineID = l.OnlineOrderLineID
    and AttributeName = 'EndDate') as EndDate,
   (SELECT AttributeValue 
    FROM vwOrderLineAttribute
    WHERE OrderLineID = l.OnlineOrderLineID
    and AttributeName = 'CBCount') as CBCount,
    (SELECT AttributeValue 
    FROM vwOrderLineAttribute
    WHERE OrderLineID = l.OnlineOrderLineID
    and AttributeName = 'CBDays') as CBDays,
    (SELECT AttributeValue 
    FROM vwOrderLineAttribute
    WHERE OrderLineID = l.OnlineOrderLineID
    and AttributeName = 'CBCode') as CBCode      
    
 FROM #OnlineDisplayOrderLines l
		JOIN Global.BusinessUnit b ON b.BusinessUnitID = l.BusinessUnitID
		JOIN vwOrderLineDetail o ON o.OrderLineID = l.OnlineOrderLineID
		JOIN vwOrderLineDetail p ON p.OrderLineID = l.PrintOrderLineID
		JOIN vwOrder ord ON ord.OrderID = l.OrderID
		JOIN [Order].[Order] ordr ON ordr.orderid = l.OrderID    
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

