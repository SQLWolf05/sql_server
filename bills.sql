
:exit

--Avg
SELECT TOP (25) * FROM [WellsFargo].[dbo].[average_pay_amount_valencia] ORDER BY 1
GO

/*
exec [WellsFargo].[dbo].[bp_auto_citi_att_internet]		'2022-04-05', '53.00'
exec [WellsFargo].[dbo].[bp_auto_citi_burrtec]			'2022-04-01', '84.60'
exec [WellsFargo].[dbo].[bp_auto_citi_citicostco]		'2022-05-09', '3190.48'
exec [WellsFargo].[dbo].[bp_auto_citi_scv]				'2022-04-22', '31.15'
exec [WellsFargo].[dbo].[bp_auto_citi_stevenson_ST1]	'2022-04-01', '90.00'
exec [WellsFargo].[dbo].[bp_auto_citi_treana_TR6]		'2022-05-01', '290.00'
exec [WellsFargo].[dbo].[bp_auto_wf_mrcooper]			'2022-04-01', '2703.30'
exec [WellsFargo].[dbo].[bp_auto_wf_socalgas]			'2022-05-08', '11.11'


MANUAL
exec [WellsFargo].[dbo].[bp_MAN_wf_socaledison]			'2022-03-07', '87.42'
*/


  ----------------------------------------------------------------------------------------------------

--Avg
SELECT TOP (25) * FROM [WellsFargo].[dbo].[average_pay_amount_valencia] ORDER BY 1
GO

--10 latest
SELECT top 30 * 
FROM [WellsFargo]..bill_review
where account_name LIKE '%ocal%'
order by 3 DESC


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





416