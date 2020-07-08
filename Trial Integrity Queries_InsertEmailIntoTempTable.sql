
:CONNECT H80124-DB

set nocount OFF

declare @server_name_basic varchar(255)
declare @server_name_instance_name varchar(255)
declare @server_time_zone varchar(255)
set @server_name_basic = (SELECT cast(serverproperty('servername') as varchar(255)))
set @server_name_instance_name = (SELECT replace(cast(serverproperty('servername') as varchar(255)), '\', ' SQL Instance: '))
exec master.dbo.xp_regread 'hkey_local_machine', 'system\currentcontrolset\control\timezoneinformation','timezonekeyname', @server_time_zone out
 
  -----------------------------------------------------------------------------------------------
  --//	set message subject.
declare @message_subject varchar(255)
set @message_subject = 'ACT / VCA Comparison: ' + @server_name_instance_name
 
 ----------------------------------------------------------------------------------------------------
---///	Enter the numbers we get FROM ACT here in the respective variables
---///	Client Counts FROM ACT
 ----------------------------------------------------------------------------------------------------
DECLARE @act_client_active AS INT		= 4805
DECLARE @act_client_inactive AS INT		= 9666
DECLARE @act_patient_active AS INT		= 23828
DECLARE @act_patient_inactive AS INT	= 2705
DECLARE @act_deceased AS INT			= 8232

 ----------------------------------------------------------------------------------------------------
---///	Client Counts FROM VCA
 ----------------------------------------------------------------------------------------------------
DECLARE @VCA_client_active AS INT = (SELECT COUNT(*) AS ActiveClients FROM client WHERE StatusId = 1)
DECLARE @VCA_client_inactive AS INT = (SELECT COUNT(*) AS InactiveClients FROM client WHERE StatusId = 3)
DECLARE @VCA_patient_active AS INT = (SELECT COUNT(*) AS ActivePatients FROM Patient WHERE StatusId = 2)
DECLARE @VCA_patient_inactive AS INT = (SELECT COUNT(*) AS InactivePatients FROM Patient WHERE StatusId = 4)
DECLARE @VCA_deceased AS INT = (SELECT COUNT(*) AS DeceasedPatients FROM Patient WHERE StatusId = 7)



 ----------------------------------------------------------------------------------------------------
---///	Variable for the Percentage of Patient Breeds to Totatl Patients (below)
 ----------------------------------------------------------------------------------------------------
DECLARE @PatientBreeds AS FLOAT = (SELECT COUNT(*) FROM patient WHERE patientid not in(SELECT patientid FROM PatientBreeds))
DECLARE @PatientColors AS FLOAT = (SELECT COUNT(*) FROM patient WHERE patientid not in (SELECT patientid FROM PatientAppearance))
DECLARE @PatientSpecies AS FLOAT = (SELECT COUNT(*) FROM patient WHERE speciesid is null)
DECLARE @PatientGenders AS FLOAT = (SELECT COUNT(*) FROM patient WHERE genderid is null)
DECLARE @PatientWeightIsZero AS FLOAT = (SELECT COUNT(*) FROM PetWeight WHERE EnteredWeightinPounds <= 0)


 ----------------------------------------------------------------------------------------------------
---///	Create temp table to store ACT/VCA numbers
 ----------------------------------------------------------------------------------------------------
if object_id('tempdb..#act_vca_number') is not null
 drop table #act_vca_number
 
create table #act_vca_number
(
 [id] INT IDENTITY (1,1)
, [Title] VARCHAR (40)
, [ACT Count]		INT
, [VCA Count]		INT
)


	 ----------------------------------------------------------------------------------------------------
	---///	Load data into previous temp table #act_vca_number
	 ----------------------------------------------------------------------------------------------------
	INSERT INTO #act_vca_number ([Title], [ACT Count], [VCA Count]) 
	SELECT [Title] = 'client_active', [ACT Count] = @act_client_active, [VCA Count] = @VCA_client_active
	INSERT INTO #act_vca_number ([Title], [ACT Count], [VCA Count]) 
	SELECT [Title] = 'client_inactive', [ACT Count] = @act_client_inactive, [VCA Count] = @VCA_client_inactive
	INSERT INTO #act_vca_number ([Title], [ACT Count], [VCA Count]) 
	SELECT [Title] = 'patient_active', [ACT Count] = @act_patient_active, [VCA Count] = @VCA_patient_active
	INSERT INTO #act_vca_number ([Title], [ACT Count], [VCA Count]) 
	SELECT [Title] = 'patient_inactive', [ACT Count] = @act_patient_inactive, [VCA Count] = @VCA_patient_inactive
	INSERT INTO #act_vca_number ([Title], [ACT Count], [VCA Count]) 
	SELECT [Title] = 'deceased', [ACT Count] = @act_deceased, [VCA Count] = @VCA_deceased

	 --SELECT * FROM #act_vca_number



 ----------------------------------------------------------------------------------------------------
---///	Create temp table to store Percentage of total Patients
 ----------------------------------------------------------------------------------------------------
if object_id('tempdb..#act_vca_perc') is not null
 drop table #act_vca_perc
 
create table #act_vca_perc
(
 [id] INT IDENTITY (1,1)
, [Title] VARCHAR (40)
, [Total]		INT
, [Percentage of all Patients]		VARCHAR (40)
)	


	 ----------------------------------------------------------------------------------------------------
	---///	Load data into previous temp table act_vca_perc.  Percentage of total Patients (Declaration at the top of page)
	 ----------------------------------------------------------------------------------------------------
	INSERT INTO #act_vca_perc ([Title], [Total], [Percentage of all Patients]) 
	SELECT 'NoPatientSpecies' AS 'Label', @PatientSpecies AS [Total], FORMAT((@PatientSpecies/(@act_patient_inactive + @act_patient_active)),'P') as [Percentage of all Patients] 
	
	INSERT INTO #act_vca_perc ([Title], [Total], [Percentage of all Patients]) 
	SELECT 'NoPatientBreed' AS 'Label', @PatientBreeds AS [Total], FORMAT((@PatientBreeds/(@act_patient_inactive + @act_patient_active)),'P') as [Percentage of all Patients] 

	INSERT INTO #act_vca_perc ([Title], [Total], [Percentage of all Patients]) 
	SELECT 'NoPatientColor' AS 'Label', @PatientColors AS [Total], FORMAT((@PatientColors/(@act_patient_inactive + @act_patient_active)),'P') as [Percentage of all Patients] 

	INSERT INTO #act_vca_perc ([Title], [Total], [Percentage of all Patients]) 
	SELECT 'NoPatientGender' AS 'Label', @PatientGenders AS [Total], FORMAT((@PatientGenders/(@act_patient_inactive + @act_patient_active)),'P') as [Percentage of all Patients] 

	INSERT INTO #act_vca_perc ([Title], [Total], [Percentage of all Patients]) 
	SELECT 'PatientWeightIsZero' AS 'Label', @PatientWeightIsZero AS [Total], FORMAT((@PatientWeightIsZero/(@act_patient_inactive + @act_patient_active)),'P') as [Percentage of all Patients] 

	--SELECT * FROM #act_vca_perc



---------These Queries Are To Be Used As Part Of The Trial Integrity Check For New Conversions-------
 ----------------------------------------------------------------------------------------------------
---///	Create temp table to store Calculated Balance discrepancies
 ----------------------------------------------------------------------------------------------------
if object_id('tempdb..#bal_discrepancy') is not null
 drop table #bal_discrepancy
 
CREATE TABLE #bal_discrepancy
(
 [id] INT IDENTITY (1,1)
, [ClientId] VARCHAR (40)
, [ChartNumber]		VARCHAR (40)
, [lastname]		VARCHAR (40)
, [firstname]		VARCHAR (40)
, [AccountBalance]		VARCHAR (40)
, [CalculatedBalance]		VARCHAR (40)
)

 ----------------------------------------------------------------------------------------------------
---///	Create temp table to store XML Email Content
 ----------------------------------------------------------------------------------------------------
if object_id('tempdb..#xml_Breed_Pct') is not null
 drop table #xml_Breed_Pct
 
CREATE TABLE #xml_Breed_Pct
(
 [id] INT IDENTITY (1,1)
, [EmailBody] XML
)


	 ----------------------------------------------------------------------------------------------------
	---///	Load data into previous temp table #bal_discrepancy
	 ----------------------------------------------------------------------------------------------------
	INSERT INTO #bal_discrepancy ([ClientId], [ChartNumber], [lastname], [firstname], [AccountBalance], [CalculatedBalance]) 
		SELECT f.ClientId, f.ChartNumber, f.lastname, f.firstname, f.AccountBalance, e.CalculatedBalance FROM client f
		inner join (
		SELECT sum(d.amount) - sum(c.paymentsum) as CalculatedBalance, ClientId FROM invoice d
		inner join (
		SELECT sum(case when b.PaymentAmount is not null then b.PaymentAmount else 0 end) as PaymentSum, a.InvoiceId FROM invoice a
		left join (
		SELECT case when amount is not null then amount else 0 end as PaymentAmount, InvoiceId FROM Payment) b
		on a.InvoiceId = b.InvoiceId
		group by a.InvoiceId) c
		on c.InvoiceId = d.InvoiceId
		group by ClientId) e
		on e.ClientId = f.ClientId
		WHERE f.AccountBalance != e.CalculatedBalance

			--SELECT TOP 10 * FROM #bal_discrepancy
			--SELECT COUNT(*) FROM #bal_discrepancy



 ----------------------------------------------------------------------------------------------------
  --//	create conditions for html tables of email.
 
declare @xml_actvcanumber NVARCHAR(MAX)
declare @xml_breed_pct NVARCHAR(MAX)
declare @xml_G2 NVARCHAR(MAX)
declare @xml_G2a NVARCHAR(MAX)
declare @xml_BD NVARCHAR(MAX)
declare @xml_BD_cnt NVARCHAR(MAX) = (SELECT COUNT(*) FROM #bal_discrepancy) 
 
  -----------------------------------------------------------------------------------------------
  --//	set xml first table td's
  --//	create html table object for: #act_vca_number
set @xml_actvcanumber =
 cast(
		 (SELECT
		  [Title] AS 'td', ''
		 , [ACT Count] AS 'td', ''
		 , [VCA Count] AS 'td'
		 FROM #act_vca_number
		 FOR XML PATH('tr')
		 , ELEMENTS)
		 as NVARCHAR(MAX)
	 )
 
  -----------------------------------------------------------------------------------------------
  --//	set xml second table td's
  --//	create html table object for: #act_vca_perc
set @xml_G2 =
 cast(
 (SELECT
 [Title] as 'td'
 , ''
 , [Total] as 'td'
 , ''
 , [Percentage of all Patients] as 'td'
 FROM #act_vca_perc
 --order by [job_name], [step_id] asc
 for xml path('tr')
 , elements)
 as NVARCHAR(MAX)
 )
 
  -----------------------------------------------------------------------------------------------
  --//	set xml third table td's
  --//	create html table object for: #patient_color
set @xml_BD =
 cast(
 (SELECT TOP 10
 [ClientId] as 'td'
 , ''
 , [ChartNumber] as 'td'
 , ''
 , [lastname] as 'td'
 , ''
 , [firstname] as 'td'
 , ''
 , [AccountBalance] as 'td'
 , ''
 , [CalculatedBalance] as 'td'
FROM #bal_discrepancy
 for xml path('tr')
 , elements)
 as NVARCHAR(MAX)
 )
  
 
  -----------------------------------------------------------------------------------------------
  --//	set xml fifth table td's
  --//	create html table object for: Count #bal_discrepancy
set @xml_BD_cnt =
 cast(
 (SELECT COUNT(*)
FROM #bal_discrepancy
 for xml path('tr')
 , elements)
 as NVARCHAR(MAX)
 )

  ----------------------------------------------------------------------------------------------- 
Insert into #xml_Breed_Pct (EmailBody)
select 
			'<html>
				<head>
					<style>
						h1{
						font-family: "arial";
						font-size: "90%";
						}
						h3{
						font-family: "verdana";
						font-size: "90%";
						color: "blue";
						}
 
						table, td, tr, 
						th {
						font-family: "verdana";
						font-size: "90%";
						border: "1px solid black";
						border-collapse: "collapse";
						}

						th	{
							text-align: "center";
							font-family: "verdana";
							font-size: "90%";
							background-color: "#238AAB";
							color: "white";
							padding: "5px";
							}
 
						td {padding: "5px";}
					</style>
				</head>
				
			 <body>
			 <h1>Note: This Server Time is operating on: ' + @server_time_zone + '</h1> 
			 <h1>ACT / VCA comparison' + '</h1>
			 <table border = "1.25">
			 <tr>
			 <th> Title </th>
			 <th> ACT Count </th>
			 <th> VCA Count </th>
			 </tr>'
 
			 + @xml_actvcanumber + '</table>
			 <br>
			 <br>
			 <br>
			 </br>
			 </br>
			 </br>
			<h1>% of total Patients </h1>
			 <table border = "1.25">
			 <tr>
			 <th> Title </th>
			 <th> Total </th>
			 <th> Percentage of all Patients </th>
			 </tr>'
 
			+ @xml_G2 + 

			 '</table>
			 <br>
			 <br>
			 <br>
			 </br>
			 </br>
			 </br>
			<h1>Total Discrepancies </h1>
			 <table border = "1.25">
			 <tr>
			 <th> Client ID </th>
			 <th> Chart Nmbr </th>
			 <th> Last Name </th>
			 <th> First Name </th>
			 <th> Acct Bal </th>
			 <th> Calculated Bal </th>
			 </tr>
			'

			  + @xml_BD +  

			 '</table>
			 <br>
			 <br>
			 <br>
			 </br>
			 </br>
			 </br>
			<h1>Total Discrepancies </h1>
			 <table border = "1.25">
			 <tr>
			 <th> Count </th>
			 </tr>
			 </table>'
			 +
			 @xml_BD_cnt  
 
			+ '</body></html>';

Insert into #xml_Breed_Pct (EmailBody)
select 
			'<html>
				<head>
					<style>
						h1{
						font-family: "arial";
						font-size: "90%";
						}
						h3{
						font-family: "verdana";
						font-size: "90%";
						color: "blue";
						}
 
						table, td, tr, 
						th {
						font-family: "verdana";
						font-size: "90%";
						border: "1px solid black";
						border-collapse: "collapse";
						}

						th	{
							text-align: "center";
							font-family: "verdana";
							font-size: "90%";
							background-color: "#238AAB";
							color: "white";
							padding: "5px";
							}
 
						td {padding: "5px";}
					</style>
				</head>
				
			 <body>
			 <h1>Note: This Server Time is operating on: ' + @server_time_zone + '</h1> 
			 <h1>ACT / VCA comparison' + '</h1>
			 <table border = "1.25">
			 <tr>
			 <th> Title </th>
			 <th> ACT Count </th>
			 <th> VCA Count </th>
			 </tr>'
 
			 + @xml_actvcanumber + '</table>
			 <br>
			 <br>
			 <br>
			 </br>
			 </br>
			 </br>
			<h1>% of total Patients</h1>
			 <table border = "1.25">
			 <tr>
			 <th> Title </th>
			 <th> Total </th>
			 <th> Percentage of all Patients </th>
			 </tr>'
 
			+ @xml_G2 + 

			
			 '</table>
			 <br>
			 <br>
			 <br>
			 </br>
			 </br>
			 </br>
			<h1>Total Discrepancies </h1>
			 <table border = "1.25">
			 <tr>
			 <th>  Count </th>
			 </tr>
			 </table>'
			 +
			 @xml_BD_cnt  
 
			+ '</body></html>';


  -----------------------------------------------------------------------------------------------
  --//	send email.
 
 set @xml_breed_pct =
 (select top 1 cast(emailbody as nvarchar(max)) from #xml_breed_pct where emailbody is not null)

EXEC msdb.dbo.sp_send_dbmail
 @profile_name = 'SQLAlerts'
, @recipients = 'trey.savilla@vca.com'
, @subject = @message_subject
, @body = @xml_breed_pct
, @body_format = 'HTML';
 
drop table #act_vca_number
drop table #act_vca_perc