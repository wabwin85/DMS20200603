DROP PROC [DP].[SP_MERGE_BscFeedback_SFDC]
GO

CREATE PROC [DP].[SP_MERGE_BscFeedback_SFDC]
AS
BEGIN
	UPDATE dp.BscFeedback
	SET BscFeedStatus=st.BscFeedStatus
		,CurrentProposal=st.CurrentProposal
		,ProposalTime=st.ProposalTime
	FROM dp.BscFeedback bf
	INNER JOIN dp.BscFeedback_stage st
		ON bf.FeedbackCode=st.FeedbackCode
	WHERE st.BscFeedStatus<=30

	INSERT INTO dp.BscFeedback (
		FeedbackId
		,Bu
		,SubBu
		,Year
		,Quarter
		,SapCode
		,BscFeedStatus
		,CurrentProposal
		,FeedbackCode
		,ProposalTime
		)
	SELECT NEWID() AS FeedbackId
		,Bu
		,SubBu
		,Year
		,Quarter
		,SapCode
		,BscFeedStatus
		,CurrentProposal
		,FeedbackCode
		,ProposalTime
	FROM dp.BscFeedback_stage bf
	WHERE NOT EXISTS(
		SELECT 1 FROM dp.BscFeedback st
		WHERE bf.FeedbackCode = st.FeedbackCode
		)


	UPDATE dp.BscFeedbackProposal
	SET ProposalUser=st.ProposalUser
		,ProposalContent=st.ProposalContent
		,ProposalRemark=st.ProposalRemark
	FROM dp.BscFeedbackProposal bf
	INNER JOIN dp.BscFeedbackProposal_stage st
		ON bf.ProposalId=st.ProposalId

	INSERT INTO dp.BscFeedbackProposal (
		ProposalId
		,FeedbackCode
		,HospitalCode
		,ProposalType
		,ProposalRole
		,ProposalUser
		,ProposalContent
		,ProposalRemark
		,ProposalTime
		)
	SELECT ProposalId
		,FeedbackCode
		,HospitalCode
		,ProposalType
		,ProposalRole
		,ProposalUser
		,ProposalContent
		,ProposalRemark
		,ProposalTime
	FROM dp.BscFeedbackProposal_stage bf
	WHERE NOT EXISTS (
			SELECT 1
			FROM dp.BscFeedbackProposal st
			WHERE bf.ProposalId = st.ProposalId
			)

END





GO


