USE [GenesisDMS_PRD]
GO

/****** Object:  Table [dbo].[InterfaceOrderStatus]    Script Date: 2019/12/18 14:53:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[InterfaceOrderStatus](
	[Id] [uniqueidentifier] NOT NULL,
	[ImportDate] [datetime] NULL,
	[ProcessDate] [datetime] NULL,
	[OrderNo] [nvarchar](50) NULL,
	[OrderStatus] [nvarchar](50) NULL,
	[LineNbr] int NULL,
	[ClientId] [nvarchar](50) NULL,
	[BatchNbr] [nvarchar](50) NULL,
	[ProblemDescription] [nvarchar](500) NULL,
 CONSTRAINT [PK_InterfaceOrderStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) 

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceOrderStatus', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'导入时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceOrderStatus', @level2type=N'COLUMN',@level2name=N'ImportDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'处理时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceOrderStatus', @level2type=N'COLUMN',@level2name=N'ProcessDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'订单编号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceOrderStatus', @level2type=N'COLUMN',@level2name=N'OrderNo'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'订单状态' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceOrderStatus', @level2type=N'COLUMN',@level2name=N'OrderStatus'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'行号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceOrderStatus', @level2type=N'COLUMN',@level2name=N'LineNbr'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'接口调用标识' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceOrderStatus', @level2type=N'COLUMN',@level2name=N'ClientId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'批处理号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceOrderStatus', @level2type=N'COLUMN',@level2name=N'BatchNbr'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'验证错误信息' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceOrderStatus', @level2type=N'COLUMN',@level2name=N'ProblemDescription'
GO



