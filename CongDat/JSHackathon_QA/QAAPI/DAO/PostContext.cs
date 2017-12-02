using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QAAPI.Models;
using System.Data.SqlClient;
using System.Data;

namespace QAAPI.DAO
{
    public class PostContext : DBContext<Post>
    {
        public List<Post> getAllPostByTag(int tagID)
        {
            List<Post> posts = new List<Post>();
            using (SqlCommand cmd = new SqlCommand("SP_POST_TAG$GET", connection))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@TagId", SqlDbType.Int).Value = tagID;

                connection.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    int ID = Convert.ToInt32(reader[0]);
                    string Title = reader[1].ToString();
                    string Content = reader[2].ToString();
                    List<Tag> Tags = new List<Tag>();
                    String[] txtTags = reader[3].ToString().Split(',');
                    foreach (String tag in txtTags)
                    {
                        Tags.Add(new Tag() { content = tag });
                    }
                    string Author= reader[4].ToString();
                    string CrtTime = reader[5].ToString();                                        
                    posts.Add(new Post()
                    {
                        id = ID,
                        author = Author,
                        content = Content,
                        crt_date =CrtTime,
                        title =Title,
                        tags = Tags,                        
                    });
                }
                connection.Close();
            }
            return posts;
        }
        public Post getPostByID(int postID)
        {
            List<Post> posts = new List<Post>();
            using (SqlCommand cmd = new SqlCommand("[SP_POST_BY_ID$GET]", connection))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@PostId", SqlDbType.Int).Value = postID;

                connection.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    int ID = Convert.ToInt32(reader[0]);
                    string Title = reader[1].ToString();
                    string Content = reader[2].ToString();
                    List<Tag> Tags = new List<Tag>();
                    String[] txtTags = reader[3].ToString().Split(',');
                    foreach (String tag in txtTags)
                    {
                        Tags.Add(new Tag() { content = tag });
                    }
                    string Author = reader[4].ToString();
                    string CrtTime = reader[5].ToString();
                    posts.Add(new Post()
                    {
                        id = ID,
                        author = Author,
                        content = Content,
                        crt_date = CrtTime,
                        title = Title,
                        tags = Tags,
                    });
                }
                connection.Close();
            }
            return posts[0];
        }
        public int addPost(string userID, string title,string content, string tags, string crtTime)
        {
            var postid = -1;
            using (SqlCommand cmd = new SqlCommand("SP_POST_TAG$POST", connection))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@UserId", userID));
                cmd.Parameters.Add(new SqlParameter("@PostTitle", title));
                cmd.Parameters.Add(new SqlParameter("@PostContent", content));
                cmd.Parameters.Add(new SqlParameter("@TagId",tags ));

                var returnParameter = cmd.Parameters.Add("@ReturnVal", SqlDbType.Int);
                returnParameter.Direction = ParameterDirection.ReturnValue;

                connection.Open();
                cmd.ExecuteNonQuery();
                postid = (int)returnParameter.Value; 
                connection.Close();
                
            }
            return postid;
        }
    }
    
}