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

   -------------------------------------------------------------------------------------------
   -- THEM 