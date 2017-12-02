USE [DEGOI]
GO

/****** Object:  StoredProcedure [dbo].[SP_POST_TAG$POST]    Script Date: 12/2/2017 12:47:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[SP_POST_TAG$POST]
	@UserId Nvarchar(128),
	@PostContent Text,
	@TagId Text
AS
BEGIN
	DECLARE @NEW_POST_ID AS Nvarchar(20)
	DECLARE @ABCD AS Nvarchar(100)
	Set NoCount ON
	INSERT INTO Post(
			UserId
		   ,PostContent
           ,CrtTime
           ,UpdTime)
     VALUES
           (@UserId
           ,@PostContent
           ,GETDATE()
           ,GETDATE())
	SET @NEW_POST_ID = SCOPE_IDENTITY();
	
	INSERT INTO PostTag
			   (PostId
			   ,TagId
			   ,CrtTime)
	SELECT @NEW_POST_ID AS PostID ,
	NAME AS TagID,
	GETDATE() AS CrtDate
	FROM splitstring(@TagId);
	 
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
	BEGIN
		SELECT @NEW_POST_ID AS POST;
		Return(@NEW_POST_ID)
	END
	ErrorHandler:
    BEGIN
		SELECT '-1';
		Return(0)
	END
END



GO


