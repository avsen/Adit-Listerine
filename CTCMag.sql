IF OBJECT_ID('[dbo].[GetAditExtractAdsXML]') IS NULL -- Check if SP Exists
 EXEC('CREATE PROCEDURE [dbo].[GetAditExtractAdsXML] AS SET NOCOUNT ON;') -- Create dummy/empty SP
GO


ALTER PROC [dbo].[GetAditExtractAdsXML](
 @BusinessUnitAbbreviation VARCHAR(50),
 @ClassCode varchar(max),
 @RunDate DATETIME,
 @ExternalReferences VARCHAR(512),
 @ProductTypeName VARCHAR(512),
 @StartDate DATETIME = NULL
)
AS
BEGIN
 BEGIN TRY
SET NOCOUNT ON

IF @StartDate IS NOT NULL 
	BEGIN
	    DECLARE @EndDate DATETIME
		SET @EndDate = DATEADD(DAY, 1, @StartDate)
		EXECUTE ('select 
		vwO.OrderID, 
		vwO.OrderDescription, 
		vwO.LastPubDate, 
		vwC.CustomerName, 
		vwC.Address1,
		vwC.City,
		vwC.StateTerritory, 
		vwC.PostalCode, 
		vwC.AccountTypeValue, 
		vwC.CustomerNumber, 
		vwC.Email, 
		vwC.Phone, 
		vwOL.[OrderLineID], 
		vwOL.[RunDate], 
		vwOL.Class,
		vwOL.[ProductName], 	 
		vwOL.ProductTypeName, 	
		vwOL.InsertionNo, 
		vwOL.LineNumber, 
		vwS.SalesPersonNumber, 
		vwS.FullName,
		vwOL.BusinessUnitAbbreviation,  
		CONVERT(XML, 
		(SELECT AttributeName, AttributeValue  
		FROM vwOrderLineAttribute 
		WHERE OrderLineID = vwOL.OrderLineID 
		FOR XML RAW (''Attribute''), ELEMENTS, root(''Attributes''))) as Attributes		 
		from [vwOrderLine] vwOL 
		inner join [vwOrder] vwO on 
		vwO.OrderID = vwOL.OrderID 
		inner join [vwCustomer] vwC on 
		vwC.CustomerID = vwO.SoldToCustomerID  
		inner join [vwSalesPerson] vwS on 
		vwS.SalesPersonNumber = vwO.SalesPersonNumber	 
		where  
		vwOL.BusinessUnitAbbreviation = ''' + @BusinessUnitAbbreviation + '''
		and vwOL.Class in (' + @ClassCode + ')
		and (vwO.Created BETWEEN ''' + @StartDate + ''' AND ''' + @EndDate + '''			
			OR
			vwO.Modified BETWEEN ''' + @StartDate + ''' AND ''' + @EndDate + ''')
		--and vwO.ExternalReferences like @ExternalReferences  
		and vwO.OrderRoutingID IN (1, 4) -- Fulfill (not Bill Only)  
		and vwO.StatusId in (2, 4, 6, 7, 10) -- 2=Submitted, 4=Changed, 6=Change Pending, 7=Processed, 10=Invoiced 
		AND vwOL.ProductTypeName like ''' + @ProductTypeName + '''') 
	END
	ELSE
	BEGIN
		EXECUTE ('select 
		vwO.OrderID, 
		vwO.OrderDescription, 
		vwO.LastPubDate, 
		vwC.CustomerName, 
		vwC.Address1,
		vwC.City,
		vwC.StateTerritory, 
		vwC.PostalCode, 
		vwC.AccountTypeValue, 
		vwC.CustomerNumber, 
		vwC.Email, 
		vwC.Phone, 
		vwOL.[OrderLineID], 
		vwOL.[RunDate], 
		vwOL.Class,
		vwOL.[ProductName], 	 
		vwOL.ProductTypeName, 	
		vwOL.InsertionNo, 
		vwOL.LineNumber, 
		vwS.SalesPersonNumber, 
		vwS.FullName,
		vwOL.BusinessUnitAbbreviation,  
		CONVERT(XML, 
		(SELECT AttributeName, AttributeValue  
		FROM vwOrderLineAttribute 
		WHERE OrderLineID = vwOL.OrderLineID 
		FOR XML RAW (''Attribute''), ELEMENTS, root(''Attributes''))) as Attributes		 
		from [vwOrderLine] vwOL 
		inner join [vwOrder] vwO on 
		vwO.OrderID = vwOL.OrderID 
		inner join [vwCustomer] vwC on 
		vwC.CustomerID = vwO.SoldToCustomerID  
		inner join [vwSalesPerson] vwS on 
		vwS.SalesPersonNumber = vwO.SalesPersonNumber	 
		where  
		vwOL.BusinessUnitAbbreviation = ''' + @BusinessUnitAbbreviation + '''
		and vwOL.Class in (' + @ClassCode + ')
		and vwOL.RunDate =  ''' + @RunDate + '''
		--and vwO.ExternalReferences like @ExternalReferences  
		and vwO.OrderRoutingID IN (1, 4) -- Fulfill (not Bill Only)  
		and vwO.StatusId in (2, 4, 6, 7, 10) -- 2=Submitted, 4=Changed, 6=Change Pending, 7=Processed, 10=Invoiced 
		AND vwOL.ProductTypeName like ''' + @ProductTypeName + '''') 
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

