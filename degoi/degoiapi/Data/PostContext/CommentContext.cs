using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using degoiapi.Models.QAModels;
using System.Data.SqlClient;
using System.Data;

namespace degoiapi.Data.PostContext
{
    public class CommentContext : DBContext<Comment>
    {
        public List<Comment> getAllCommentOfPost(string userID, int postID)
        {
            List<Comment> comments = new List<Comment>();
            using (SqlCommand cmd = new SqlCommand("[SP_COMMENT_LIKE_CONTENT$GET2]", connection))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@UserId", SqlDbType.NVarChar).Value = userID;
                cmd.Parameters.Add("@PostId", SqlDbType.Int).Value = postID;

                connection.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    int cmtID = Convert.ToInt32(reader[0]);
                    string Author = reader[2].ToString();
                    string AuthorName = reader[3].ToString();
                    string Content = reader[4].ToString();
                    string CrtTime = reader[5].ToString();
                    int CountLike = Convert.ToInt32(reader[6]);
                    bool LikeStatus = Convert.ToInt32(reader[7]) == 1;
                    List<Reply> Replies = new ReplyContext().getAllReplyOfComment(cmtID);
                    comments.Add(new Comment()
                    {
                        id = cmtID,
                        QA_id = postID,
                        author = Author,
                        author_name = AuthorName,
                        content = Content,
                        crt_date = CrtTime,
                        like_count = CountLike,
                        likeStatusOfCurrentUser = LikeStatus,
                        replies = Replies,
                    });
                }
                connection.Close();
            }
            return comments;
        }
        public int addComment(string user_id, string CmtContent, int post_id)
        {
            var commentID = -1;
            using (SqlCommand cmd = new SqlCommand("[SP_COMMENT$POST]", connection))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@UserId", user_id));
                cmd.Parameters.Add(new SqlParameter("@CmtContent", CmtContent));
                cmd.Parameters.Add(new SqlParameter("@PostId", post_id));

                var returnParameter = cmd.Parameters.Add("@ReturnVal", SqlDbType.Int);
                returnParameter.Direction = ParameterDirection.ReturnValue;

                connection.Open();
                cmd.ExecuteNonQuery();
                commentID = (int)returnParameter.Value;
                connection.Close();
            }
            return commentID;
        }
        public int changeLikeStatus(string user_id, int cmt_id, int status)
        {
            var commentID = -1;
            using (SqlCommand cmd = new SqlCommand("[SP_UDP_STT_LIKE$GET]", connection))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@UserId", user_id));
                cmd.Parameters.Add(new SqlParameter("@CmtId", cmt_id));
                cmd.Parameters.Add(new SqlParameter("@Status", status));

                var returnParameter = cmd.Parameters.Add("@ReturnVal", SqlDbType.Int);
                returnParameter.Direction = ParameterDirection.ReturnValue;

                connection.Open();
                cmd.ExecuteNonQuery();
                commentID = (int)returnParameter.Value;
                connection.Close();
            }
            return commentID;
        }
    }

}