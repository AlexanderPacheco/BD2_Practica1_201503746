-- *********************************************************************************************** --
-- ************************************* INICIA SUBSCRIBER 1 ************************************* --
-- *********************************************************************************************** --
-- lets enable the database for replication
USE [USAC_201503746];
EXEC sp_replicationdboption @dbname = N'USAC_201503746',
                            @optname = N'publish',
                            @value = N'true';

-- Add the publication (this will create the snapshot agent if we wanted to use it)
-- Rename the BD name to expose to subscriber
EXEC sp_addpublication @publication = N'USAC_201503746DB1',
                       @description = N'',
                       @retention = 0,
                       @allow_push = N'true',
                       @repl_freq = N'continuous',
                       @status = N'active',
                       @independent_agent = N'true';

-- now let's add an article to our publication
-- an article(or table) let will published
USE [USAC_201503746];
EXEC sp_addarticle @publication = N'USAC_201503746DB1', --aliasBD
                   @article = N'suppliers',
                   @source_owner = N'dbo',
                   @source_object = N'suppliers',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'suppliers',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';

EXEC sp_addarticle @publication = N'USAC_201503746DB1', --aliasBD
                   @article = N'region',
                   @source_owner = N'dbo',
                   @source_object = N'region',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'region',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';

EXEC sp_addarticle @publication = N'USAC_201503746DB1', --aliasBD
                   @article = N'shippers',
                   @source_owner = N'dbo',
                   @source_object = N'shippers',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'shippers',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';

EXEC sp_addarticle @publication = N'USAC_201503746DB1', --aliasBD
                   @article = N'customers',
                   @source_owner = N'dbo',
                   @source_object = N'customers',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'customers',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';


EXEC sp_addarticle @publication = N'USAC_201503746DB1', --aliasBD
                   @article = N'customerdemographics',
                   @source_owner = N'dbo',
                   @source_object = N'customerdemographics',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'customerdemographics',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';

-- now let's add a subscriber to our publication
use [USAC_201503746]
exec sp_addsubscription
@publication = N'USAC_201503746DB1', --aliasBD
@subscriber = 'subscriber1',
@destination_db = 'USAC_201503746',
@subscription_type = N'Push',
@sync_type = N'none',
@article = N'all',
@update_mode = N'read only',
@subscriber_type = 0

-- and add the push agent
exec sp_addpushsubscription_agent
@publication = N'USAC_201503746DB1',
@subscriber = 'subscriber1',
@subscriber_db = 'USAC_201503746',
@subscriber_security_mode = 0,
@subscriber_login =  'sa',
@subscriber_password =  'Pa55w0rd!',
@frequency_type = 64,
@frequency_interval = 0,
@frequency_relative_interval = 0,
@frequency_recurrence_factor = 0,
@frequency_subday = 0,
@frequency_subday_interval = 0,
@active_start_time_of_day = 0,
@active_end_time_of_day = 0,
@active_start_date = 0,
@active_end_date = 19950101
GO

-- by default it sets up the log reader agent with a default account that won�t work, you need to change that to something that will.
EXEC sp_changelogreader_agent @publisher_security_mode = 0,
                              @publisher_login = 'sa',
                              @publisher_password = 'Pa55w0rd!';
-- *********************************************************************************************** --
-- ************************************ FINALIZA SUBSCRIBER 1 ************************************ --
-- *********************************************************************************************** --