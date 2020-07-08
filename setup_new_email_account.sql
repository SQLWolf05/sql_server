SP_CONFIGURE 'Show adv', 1
RECONFIGURE WITH OVERRIDE
GO

SP_CONFIGURE 'Database M', 1
RECONFIGURE WITH OVERRIDE
GO

SP_CONFIGURE 'Show adv', 0
RECONFIGURE WITH OVERRIDE
GO


-- Create a Database Mail profile  
EXECUTE msdb.dbo.sysmail_add_profile_sp  
    @profile_name = 'SQLAlerts',  
    @description = 'Profile used for sending outgoing notifications.' ;  
GO



-- Grant access to the profile to the DBMailUsers role  
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp  
    @profile_name = 'SQLAlerts',  
    @principal_name = 'public',  
    @is_default = 1 ;
GO


-- Create a Database Mail account  
EXECUTE msdb.dbo.sysmail_add_account_sp  
    @account_name = 'SQLAlerts',  
    @description = 'Mail account for sending outgoing notifications.',  
    @email_address = 'H4010-DB@vcaantech.com',    ---/// CHANGE Here!!
    @display_name = 'H4010-DB@vcaantech.com',  	  ---/// CHANGE Here!!
	@replyto_address = 'H4010-DB@vcaantech.com',  ---/// CHANGE Here!!
    @mailserver_name = 'relay.vcaantech.com',
	@use_default_credentials = 1,
    @port = 25,
    @enable_ssl = 1;  
GO



-- Add the account to the profile  
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp  
    @profile_name = 'SQLAlerts',  
    @account_name = 'SQLAlerts',  
    @sequence_number =1 ;  
GO



-- TEST TEST TEST  
EXEC msdb.dbo.sp_send_dbmail
     @profile_name = 'SQLAlerts',
     @recipients = 'kyle.hayes@vca.com',
     @body = 'The database mail configuration was completed successfully.',
     @subject = 'Automated Success Message';
GO