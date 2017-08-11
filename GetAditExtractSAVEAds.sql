IF OBJECT_ID('[dbo].[GetAditExtractSAVEAds]') IS NULL -- Check if SP Exists
 EXEC('CREATE PROCEDURE [dbo].[GetAditExtractSAVEAds] AS SET NOCOUNT ON;') -- Create dummy/empty SP
GO


ALTER PROC [dbo].[GetAditExtractSAVEAds](
 @BusinessUnitAbbreviation VARCHAR(50),
 @ClassCode VARCHAR(50),
 @RunDate DATETIME,
 @ExternalReferences VARCHAR(512)
)
AS
BEGIN
BEGIN TRY
SET NOCOUNT ON

	select 
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
	(select top 1 ola.AttributeValue from [Order].[OrderLineAttribute] ola 
	inner join [Global].[AttributeDefinition] ad on 
	ad.AttributeID = ola.AttributeID 
	where ola.OrderLineID in (select [OrderLineID] from [vwOrderLineDetail] where OrderID = vwO.Orderid)
	and ad.AttributeName = 'NameFirst'
	and (ola.AttributeValue is not null or ola.AttributeValue != '')) as NameFirst, 
	(select top 1 ola.AttributeValue from [Order].[OrderLineAttribute] ola 
	inner join [Global].[AttributeDefinition] ad on 
	ad.AttributeID = ola.AttributeID 
	where ola.OrderLineID in (select [OrderLineID] from [vwOrderLineDetail] where OrderID = vwO.Orderid)
	and ad.AttributeName = 'NameLast'
	and (ola.AttributeValue is not null or ola.AttributeValue != '')) as NameLast, 
	(select top 1 ola.AttributeValue from [Order].[OrderLineAttribute] ola 
	inner join [Global].[AttributeDefinition] ad on 
	ad.AttributeID = ola.AttributeID 
	where ola.OrderLineID in (select [OrderLineID] from [vwOrderLineDetail] where OrderID = vwO.Orderid)
	and ad.AttributeName = 'FuneralHomeName'
	and (ola.AttributeValue is not null or ola.AttributeValue != '')) as FuneralHomeName, 
	(select top 1 ola.AttributeValue from [Order].[OrderLineAttribute] ola 
	inner join [Global].[AttributeDefinition] ad on 
	ad.AttributeID = ola.AttributeID 
	where ola.OrderLineID in (select [OrderLineID] from [vwOrderLineDetail] where OrderID = vwO.Orderid)
	and ad.AttributeName = 'FuneralHomeContactPhone'
	and (ola.AttributeValue is not null or ola.AttributeValue != '')) as FuneralHomeContactPhone, 
	(select top 1 ola.AttributeValue from [Order].[OrderLineAttribute] ola 
	inner join [Global].[AttributeDefinition] ad on 
	ad.AttributeID = ola.AttributeID 
	where ola.OrderLineID in (select [OrderLineID] from [vwOrderLineDetail] where OrderID = vwO.Orderid)
	and ad.AttributeName = 'FuneralHomeEmail'
	and (ola.AttributeValue is not null or ola.AttributeValue != '')) as FuneralHomeEmail, 
	(select top 1 ola.AttributeValue from [Order].[OrderLineAttribute] ola 
	inner join [Global].[AttributeDefinition] ad on 
	ad.AttributeID = ola.AttributeID 
	where ola.OrderLineID in (select [OrderLineID] from [vwOrderLineDetail] where OrderID = vwO.Orderid)
	and ad.AttributeName = 'ContactName'
	and (ola.AttributeValue is not null or ola.AttributeValue != '')) as ContactName, 
	(select top 1 ola.AttributeValue from [Order].[OrderLineAttribute] ola 
	inner join [Global].[AttributeDefinition] ad on 
	ad.AttributeID = ola.AttributeID 
	where ola.OrderLineID in (select [OrderLineID] from [vwOrderLineDetail] where OrderID = vwO.Orderid)
	and ad.AttributeName = 'ContactPhone'
	and (ola.AttributeValue is not null or ola.AttributeValue != '')) as ContactPhone, 
	(select top 1 ola.AttributeValue from [Order].[OrderLineAttribute] ola 
	inner join [Global].[AttributeDefinition] ad on 
	ad.AttributeID = ola.AttributeID 
	where ola.OrderLineID in (select [OrderLineID] from [vwOrderLineDetail] where OrderID = vwO.Orderid)
	and ad.AttributeName = 'ContactEmail'
	and (ola.AttributeValue is not null or ola.AttributeValue != '')) as ContactEmail, 					
	(select top 1 ola.AttributeValue from [Order].[OrderLineAttribute] ola 
	inner join [Global].[AttributeDefinition] ad on 
	ad.AttributeID = ola.AttributeID 
	where ola.OrderLineID in (select [OrderLineID] from [vwOrderLineDetail] where OrderID = vwO.Orderid)
	and ad.AttributeName = 'DateDeath'
	and (ola.AttributeValue is not null or ola.AttributeValue != '')) as DateDeath, 
	(select top 1 ola.AttributeValue from [Order].[OrderLineAttribute] ola 
	inner join [Global].[AttributeDefinition] ad on 
	ad.AttributeID = ola.AttributeID 
	where ola.OrderLineID in (select [OrderLineID] from [vwOrderLineDetail] where OrderID = vwO.Orderid)
	and ad.AttributeName = 'DateBirth'
	and (ola.AttributeValue is not null or ola.AttributeValue != '')) as DateBirth, 
	(select top 1 ola.AttributeValue from [Order].[OrderLineAttribute] ola 
	inner join [Global].[AttributeDefinition] ad on 
	ad.AttributeID = ola.AttributeID 
	where ola.OrderLineID in (select [OrderLineID] from [vwOrderLineDetail] where OrderID = vwO.Orderid)
	and ad.AttributeName = 'ObitText'
	and (ola.AttributeValue is not null or ola.AttributeValue != '')) as ObitText,
	(select top 1 ola.AttributeValue from [Order].[OrderLineAttribute] ola 
	inner join [Global].[AttributeDefinition] ad on 
	ad.AttributeID = ola.AttributeID 
	where ola.OrderLineID in (select [OrderLineID] from [vwOrderLineDetail] where OrderID = vwO.Orderid)
	and ad.AttributeName = 'NameMiddle'
	and (ola.AttributeValue is not null or ola.AttributeValue != '')) as NameMiddle,	
	(select top 1 ola.AttributeValue from [Order].[OrderLineAttribute] ola 
	inner join [Global].[AttributeDefinition] ad on 
	ad.AttributeID = ola.AttributeID 
	where ola.OrderLineID in (select [OrderLineID] from [vwOrderLineDetail] where OrderID = vwO.Orderid)
	and ad.AttributeName = 'NameNick'
	and (ola.AttributeValue is not null or ola.AttributeValue != '')) as NameNick			 
	from [vwOrderLine] vwOL 
	inner join [vwOrder] vwO on 
	vwO.OrderID = vwOL.OrderID 
	inner join [vwCustomer] vwC on 
	vwC.CustomerID = vwO.SoldToCustomerID  
	inner join [vwSalesPerson] vwS on 
	vwS.SalesPersonNumber = vwO.SalesPersonNumber	 
	where  
	vwOL.BusinessUnitAbbreviation = @BusinessUnitAbbreviation 
	and vwOL.Class = @ClassCode  
	and vwOL.RunDate =  @RunDate  
	--and vwO.ExternalReferences like @ExternalReferences  
	and vwO.OrderRoutingID IN (1, 4) -- Fulfill (not Bill Only)
	and vwO.StatusId in (2, 4, 6, 7, 10) -- 2=Submitted, 4=Changed, 6=Change Pending, 7=Processed, 10=Invoiced
	and vwOL.StatusID in (2, 4, 6, 7, 10) 
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

