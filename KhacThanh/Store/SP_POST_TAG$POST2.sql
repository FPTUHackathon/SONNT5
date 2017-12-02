USE [DEGOI]
GO

/****** Object:  StoredProcedure [dbo].[SP_POST_TAG$GET]    Script Date: 12/1/2017 10:54:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_POST_TAG$POST2]
	@UserId Nvarchar(128),
	@PostContent Text,
	@TagId Text,
	@CrtDate datetime
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
           ,@CrtDate
           ,@CrtDate)
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
		SELECT @NEW_POST_ID;
	    Return(@NEW_POST_ID)
	END
	ErrorHandler:
    BEGIN
		SELECT '-1';
		Return(0)
	END
END



