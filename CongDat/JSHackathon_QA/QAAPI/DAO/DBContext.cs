using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace QAAPI.DAO
{
    public abstract class DBContext<T>
    {
        public SqlConnection connection;
        public DBContext()
        {
            string connectionString = ConfigurationManager.
                ConnectionStrings["DEGOI"].ConnectionString;
            connection = new SqlConnection(connectionString);
        }
    }
}