-- 1459aaa0-4763-4f3e-99e2-1521e2e00bae
-- 37b0dafd-ac3e-499d-ba39-d566c6d9467c

   ------------------------------------------------------------------------------------------------------
   --  Get all post by tag --> List<Post>
   ------------------------------------------------------------------------------------------------------
   /****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [PostId]
      ,[UserId]
      ,[PostContent]
      ,[CrtTime]
      ,[UpdTime]
  FROM [DEGOI].[dbo].[Post]

  -- Get Post by Tag
  SELECT Post.PostId, Post.PostContent,Post.CrtTime
  


  SELECT Post.PostId, Pos FROM Post 
  LEFT JOIN PostTag ON Post.PostId = PostTag.PostId
  LEFT JOIN Tag ON Tag.TagId = PostTag.TagId
  WHERE Post.PostId IN (SELECT Post.PostId
   FROM 
  Post 
   JOIN PostTag ON Post.PostId = PostTag.PostId
  LEFT JOIN Tag ON Tag.TagId = PostTag.TagId
  WHERE PostTag.TagId = 1000)



  (SELECT post.PostId,
		TagId =		STUFF((
          SELECT ',' + CAST(Tag.TagName AS VARCHAR(30))
          FROM PostTag postTag
		  JOIN Tag ON postTag.TagId = Tag.TagId
		  WHERE postTag.PostId = post.PostId
          FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
   FROM PostTag post
   GROUP BY post.PostId ) 


 SELECT 
	Post.PostId
	,Post.PostContent
	,TagTbl.TagList 
  FROM Post 
  LEFT JOIN 
  (SELECT post.PostId,
		TagList =		STUFF((
          SELECT ',' + CAST(Tag.TagName AS VARCHAR(30))
          FROM PostTag postTag
		  JOIN Tag ON postTag.TagId = Tag.TagId
		  WHERE postTag.PostId = post.PostId
          FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
   FROM PostTag post
   GROUP BY post.PostId ) TagTbl ON Post.PostId = TagTbl.PostId
  WHERE Post.PostId IN (SELECT Post.PostId
		   FROM 
		  Post 
		   JOIN PostTag ON Post.PostId = PostTag.PostId
		  LEFT JOIN Tag ON Tag.TagId = PostTag.TagId
		  WHERE PostTag.TagId = 1000)



  (SELECT post.PostId,
		TagId =		STUFF((
          SELECT ',' + CAST(Tag.TagName AS VARCHAR(30))
          FROM PostTag postTag
		  JOIN Tag ON postTag.TagId = Tag.TagId
		  WHERE postTag.PostId = post.PostId
          FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
   FROM PostTag post
   GROUP BY post.PostId ) 

   ------------------------------------------------------------------------------------------------------
   -- THEM POST ( + TAG ) Post Post --> UserID, Content, CrtTime, List<Tag>(String) OUT ---> PostId
   ------------------------------------------------------------------------------------------------------

INSERT INTO Post(
			UserId
		   ,PostContent
           ,CrtTime
           ,UpdTime)
     VALUES
           ('1459aaa0-4763-4f3e-99e2-1521e2e00bae'
           ,'Em la SieuNhan'
           ,'2017-12-01 23:11:30.000'
           ,'2017-12-01 23:11:30.000')
	SET @NEW_POST_ID = SCOPE_IDENTITY();
	DECLARE @ABC AS Nvarchar(100)
	DECLARE @ABCD AS Nvarchar(100)
	SET @ABCD = '1001,1003,1004' 
	INSERT INTO PostTag
			   (PostId
			   ,TagId
			   ,CrtTime)
	SELECT @NEW_POST_ID AS PostID ,
	NAME AS TagID,
	GETDATE() AS CrtDate
	FROM splitstring(@ABCD) 
	
GO

CREATE FUNCTION dbo.splitstring ( @stringToSplit VARCHAR(MAX) )
RETURNS
 @returnList TABLE ([Name] [nvarchar] (500))
AS
BEGIN

 DECLARE @name NVARCHAR(255)
 DECLARE @pos INT

 WHILE CHARINDEX(',', @stringToSplit) > 0
 BEGIN
  SELECT @pos  = CHARINDEX(',', @stringToSplit)  
  SELECT @name = SUBSTRING(@stringToSplit, 1, @pos-1)

  INSERT INTO @returnList 
  SELECT @name

  SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
 END

 INSERT INTO @returnList
 SELECT @stringToSplit

 RETURN
END



SELECT GETDATE()