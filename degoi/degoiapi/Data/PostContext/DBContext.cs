using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace degoiapi.Data.PostContext
{
    public abstract class DBContext<T>
    {
        public SqlConnection connection;
        public DBContext()
        {
            string connectionString = ConfigurationManager.
                ConnectionStrings["db"].ConnectionString;
            connection = new SqlConnection(connectionString);
        }
    }
}