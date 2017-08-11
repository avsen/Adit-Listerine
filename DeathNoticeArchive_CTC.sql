IF OBJECT_ID('[dbo].[sp_DeathNoticeArchive_CTC]') IS NULL -- Check if SP Exists
 EXEC('CREATE PROCEDURE [dbo].[sp_DeathNoticeArchive_CTC] AS SET NOCOUNT ON;') -- Create dummy/empty SP
GO



ALTER PROCEDURE [dbo].[sp_DeathNoticeArchive_CTC] 
	@BusinessUnitAbbreviation nvarchar(50),
	@RunDate nvarchar(50),
	@class nvarchar(50)
	
	
AS
	
	SET NOCOUNT ON;
	select
   vwO.OrderID,
   vwO.OrderDescription,
   vwO.LastPubDate,
   vwC.CustomerID,
   vwC.CustomerName,
   vwC.Address1,
   vwC.City,
   vwC.StateTerritory,
   vwC.PostalCode,
   vwC.AccountTypeValue,
   vwC.CustomerNumber,
   vwC.Phone,
   vwO.SalesPersonNumber,
   vwOL.[OrderLineID],
   vwOL.[RunDate],
   vwOL.Class,
   vwOL.[ProductName],
   vwOL.ProductTypeName,
   vwOL.InsertionNo,
   vwOL.LineNumber,
   vwOL.BusinessUnitAbbreviation,
   (
      select
         top 1 ola.AttributeValue 
      from
         [Order].[OrderLineAttribute] ola 
         inner join
            [Global].[AttributeDefinition] ad 
            on ad.AttributeID = ola.AttributeID 
      where
         ola.OrderLineID in 
         (
            select
               [OrderLineID] 
            from
               [vwOrderLineDetail] 
            where
               OrderID = vwO.Orderid
         )
         and ad.AttributeName = 'NameFirst' 
         and 
         (
            ola.AttributeValue is not null 
            or ola.AttributeValue != ''
         )
   )
   as NameFirst,
   (
      select
         top 1 ola.AttributeValue 
      from
         [Order].[OrderLineAttribute] ola 
         inner join
            [Global].[AttributeDefinition] ad 
            on ad.AttributeID = ola.AttributeID 
      where
         ola.OrderLineID in 
         (
            select
               [OrderLineID] 
            from
               [vwOrderLineDetail] 
            where
               OrderID = vwO.Orderid
         )
         and ad.AttributeName = 'NameLast' 
         and 
         (
            ola.AttributeValue is not null 
            or ola.AttributeValue != ''
         )
   )
   as NameLast,
   (
      select
         top 1 ola.AttributeValue 
      from
         [Order].[OrderLineAttribute] ola 
         inner join
            [Global].[AttributeDefinition] ad 
            on ad.AttributeID = ola.AttributeID 
      where
         ola.OrderLineID in 
         (
            select
               [OrderLineID] 
            from
               [vwOrderLineDetail] 
            where
               OrderID = vwO.Orderid
         )
         and ad.AttributeName = 'FuneralHomeName' 
         and 
         (
            ola.AttributeValue is not null 
            or ola.AttributeValue != ''
         )
   )
   as FuneralHomeName,
   (
      select
         top 1 ola.AttributeValue 
      from
         [Order].[OrderLineAttribute] ola 
         inner join
            [Global].[AttributeDefinition] ad 
            on ad.AttributeID = ola.AttributeID 
      where
         ola.OrderLineID in 
         (
            select
               [OrderLineID] 
            from
               [vwOrderLineDetail] 
            where
               OrderID = vwO.Orderid
         )
         and ad.AttributeName = 'FuneralHomeContactPhone' 
         and 
         (
            ola.AttributeValue is not null 
            or ola.AttributeValue != ''
         )
   )
   as FuneralHomeContactPhone,
   (
      select
         top 1 ola.AttributeValue 
      from
         [Order].[OrderLineAttribute] ola 
         inner join
            [Global].[AttributeDefinition] ad 
            on ad.AttributeID = ola.AttributeID 
      where
         ola.OrderLineID in 
         (
            select
               [OrderLineID] 
            from
               [vwOrderLineDetail] 
            where
               OrderID = vwO.Orderid
         )
         and ad.AttributeName = 'FuneralHomeEmail' 
         and 
         (
            ola.AttributeValue is not null 
            or ola.AttributeValue != ''
         )
   )
   as FuneralHomeEmail,
   (
      select
         top 1 ola.AttributeValue 
      from
         [Order].[OrderLineAttribute] ola 
         inner join
            [Global].[AttributeDefinition] ad 
            on ad.AttributeID = ola.AttributeID 
      where
         ola.OrderLineID in 
         (
            select
               [OrderLineID] 
            from
               [vwOrderLineDetail] 
            where
               OrderID = vwO.Orderid
         )
         and ad.AttributeName = 'ContactName' 
         and 
         (
            ola.AttributeValue is not null 
            or ola.AttributeValue != ''
         )
   )
   as ContactName,
   (
      select
         top 1 ola.AttributeValue 
      from
         [Order].[OrderLineAttribute] ola 
         inner join
            [Global].[AttributeDefinition] ad 
            on ad.AttributeID = ola.AttributeID 
      where
         ola.OrderLineID in 
         (
            select
               [OrderLineID] 
            from
               [vwOrderLineDetail] 
            where
               OrderID = vwO.Orderid
         )
         and ad.AttributeName = 'ContactPhone' 
         and 
         (
            ola.AttributeValue is not null 
            or ola.AttributeValue != ''
         )
   )
   as ContactPhone,
   (
      select
         top 1 ola.AttributeValue 
      from
         [Order].[OrderLineAttribute] ola 
         inner join
            [Global].[AttributeDefinition] ad 
            on ad.AttributeID = ola.AttributeID 
      where
         ola.OrderLineID in 
         (
            select
               [OrderLineID] 
            from
               [vwOrderLineDetail] 
            where
               OrderID = vwO.Orderid
         )
         and ad.AttributeName = 'ContactEmail' 
         and 
         (
            ola.AttributeValue is not null 
            or ola.AttributeValue != ''
         )
   )
   as ContactEmail,
   (
      select
         top 1 ola.AttributeValue 
      from
         [Order].[OrderLineAttribute] ola 
         inner join
            [Global].[AttributeDefinition] ad 
            on ad.AttributeID = ola.AttributeID 
      where
         ola.OrderLineID in 
         (
            select
               [OrderLineID] 
            from
               [vwOrderLineDetail] 
            where
               OrderID = vwO.Orderid
         )
         and ad.AttributeName = 'DateDeath' 
         and 
         (
            ola.AttributeValue is not null 
            or ola.AttributeValue != ''
         )
   )
   as DateDeath,
   (
      select
         top 1 ola.AttributeValue 
      from
         [Order].[OrderLineAttribute] ola 
         inner join
            [Global].[AttributeDefinition] ad 
            on ad.AttributeID = ola.AttributeID 
      where
         ola.OrderLineID in 
         (
            select
               [OrderLineID] 
            from
               [vwOrderLineDetail] 
            where
               OrderID = vwO.Orderid
         )
         and ad.AttributeName = 'DateBirth' 
         and 
         (
            ola.AttributeValue is not null 
            or ola.AttributeValue != ''
         )
   )
   as DateBirth,
   (
      select
         top 1 ola.AttributeValue 
      from
         [Order].[OrderLineAttribute] ola 
         inner join
            [Global].[AttributeDefinition] ad 
            on ad.AttributeID = ola.AttributeID 
      where
         ola.OrderLineID in 
         (
            select
               [OrderLineID] 
            from
               [vwOrderLineDetail] 
            where
               OrderID = vwO.Orderid
         )
         and ad.AttributeName = 'ObitText' 
         and 
         (
            ola.AttributeValue is not null 
            or ola.AttributeValue != ''
         )
   )
   as ObitText,
   (
      select
         top 1 ola.AttributeValue 
      from
         [Order].[OrderLineAttribute] ola 
         inner join
            [Global].[AttributeDefinition] ad 
            on ad.AttributeID = ola.AttributeID 
      where
         ola.OrderLineID in 
         (
            select
               [OrderLineID] 
            from
               [vwOrderLineDetail] 
            where
               OrderID = vwO.Orderid
         )
         and ad.AttributeName = 'NameMiddle' 
         and 
         (
            ola.AttributeValue is not null 
            or ola.AttributeValue != ''
         )
   )
   as NameMiddle,
   (
      select
         top 1 ola.AttributeValue 
      from
         [Order].[OrderLineAttribute] ola 
         inner join
            [Global].[AttributeDefinition] ad 
            on ad.AttributeID = ola.AttributeID 
      where
         ola.OrderLineID in 
         (
            select
               [OrderLineID] 
            from
               [vwOrderLineDetail] 
            where
               OrderID = vwO.Orderid
         )
         and ad.AttributeName = 'NameNick' 
         and 
         (
            ola.AttributeValue is not null 
            or ola.AttributeValue != ''
         )
   )
   as NameNick,
   app.AdPagePositionID,
   app.AdNumber,
   app.FolioPage,
   app.PSPageFile 
from
   [vwOrderLine] vwOL 
   inner join
      [vwOrder] vwO 
      on vwO.OrderID = vwOL.OrderID 
   inner join
      [vwCustomer] vwC 
      on vwC.CustomerID = vwO.SoldToCustomerID 
   left outer join
      [Order].AdPagePosition app 
      ON vwOL.OrderlineID = app.OrderlineID 		/* 25APR2016 Per Deepika  */
      /*left outer join  [Order].AdPagePosition app ON  vwOL.OrderID = app.OrderID */
      /* 18JUL2016 reverted back to orderlineid due to CTC duplicates */
where
   vwOL.BusinessUnitAbbreviation = @BusinessUnitAbbreviation 	/* 'CTC'  */
   and vwOL.Class = @class 
   and app.Zone != '?' 	/* 04MAY2015  per Dan Sanders */
   and app.Edition != '?' 	/* 04MAY2015  per Dan Sanders */
   and vwOL.RunDate = @RunDate 	/* << '01-26-2014' should be a parameter! */
   and vwOL.ProductTypeName = 'Classified Listings' 
   and vwO.OrderRoutingID IN 
   (
      1,
      4
   )
   /* -- Fulfill (not Bill Only) */
   and vwO.StatusId in 
   (
      2,
      4,
      6,
      7,
      10
   )
   /* -- 2=Submitted, 4=Changed, 6=Change Pending, 7=Processed, 10=Invoiced */
   and vwOL.StatusID in 
   (
      2,
      4,
      6,
      7,
      10
   )
   /* 18JUL2016 -Per Debby Vinakos (PE-16546) The editions that should be sent are the following: */
   /* Sunday: SHD edition  */
   /* Mon-Sat: HD edition  */
   and 
   (
( DATENAME(dw, vwol.Rundate) = 'Sunday' 
      and app.edition = 'SHD' ) 
      OR 
      (
         DATENAME(dw, vwol.Rundate) != 'Sunday' 
         and app.edition = 'HD' 
      )
   )


 
GO

