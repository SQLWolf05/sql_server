news- 08/08/20


--Avg
SELECT TOP (25) * FROM [WellsFargo].[dbo].[average_pay_amount_valencia] ORDER BY 1
GO


USE [WellsFargo]
GO
DECLARE @dd as Date = '2020-07-01'
DECLARE @ad as Money = 252.00

INSERT INTO [dbo].[billing_info]
           ([account_id]
           ,[due_date]
           ,[amount_due]
           ,[address_id]
           ,[date_created]
           ,[DateKey])
--/*  att_internet  */	VALUES ('13'	/*	account_id	*/, @dd, @ad, '16', getdate(), CONVERT(VARCHAR(10), @dd, 112))
--/*  costco_citi  */	VALUES ('18'	/*	account_id	*/, @dd, @ad, '16', getdate(), CONVERT(VARCHAR(10), @dd, 112))
--/*  Edison  */		VALUES ('14'	/*	account_id	*/, @dd, @ad, '16', getdate(), CONVERT(VARCHAR(10), @dd, 112))
--/*  LoanDepot - R  */	VALUES ('25'	/*	account_id	*/, @dd, @ad, '16', getdate(), CONVERT(VARCHAR(10), @dd, 112))
--/*  SCV  */			VALUES ('16'	/*	account_id	*/, @dd, @ad, '16', getdate(), CONVERT(VARCHAR(10), @dd, 112))
--/*  SoCalGas  */		VALUES ('22'	/*	account_id	*/, @dd, @ad, '16', getdate(), CONVERT(VARCHAR(10), @dd, 112))
--/*  slate_chase  */	VALUES ('23'	/*	account_id	*/, @dd, @ad, '16', getdate(), CONVERT(VARCHAR(10), @dd, 112))
--/*  stev_rnch  */		VALUES ('21'	/*	account_id	*/, @dd, @ad, '16', getdate(), CONVERT(VARCHAR(10), @dd, 112))
/*  treana  */		VALUES ('20'	/*	account_id	*/, @dd, @ad, '16', getdate(), CONVERT(VARCHAR(10), @dd, 112))
--/*  wm  */			VALUES ('17'	/*	account_id	*/, @dd, @ad, '16', getdate(), CONVERT(VARCHAR(10), @dd, 112))

GO


--Avg
SELECT TOP (25) * FROM [WellsFargo].[dbo].[average_pay_amount_valencia] ORDER BY 1
GO

--10 latest
SELECT top 15 * 
FROM [WellsFargo]..bill_review
where account_name = 'costco_citi'
order by 1 DESC


--current
--12	sdccu
--13	att_internet
--14	SC Edison
--15	LoanDepot
--16	SCV
--17	waste_man
--18	costco_citi
--19	lakeview
--20	treana
--21	src_assoc
--22	socal_gas
--23	slate_chase



--account_id	account_name
--1	checking
--2	kyle
--3	kaiden
--4	ladwp
--5	socal_gas
--6	verizon
--7	sdge
--8	att_uverse
--9	conserve
--10	twc
--11	wf_ira








