DROP proc [interface].[p_i_cr_Territory]
GO

CREATE proc [interface].[p_i_cr_Territory]
as

DELETE from interface.T_I_CR_Territory

insert into [interface].[T_I_CR_Territory]
 select TER_Description,TER_ID,TER_ParentID,TER_Type,TER_EName from Territory
GO


