DROP view [interface].[V_I_QV_DealerComplain]
GO




CREATE view [interface].[V_I_QV_DealerComplain]
as

select 'BSC' as ComplainType,DC_ComplainNbr,DC_Status,DC_CreatedDate from DealerComplain
union all
select 'CRM' as ComplainType,DC_ComplainNbr,DC_Status,DC_CreatedDate from DealerComplainCRM














GO


