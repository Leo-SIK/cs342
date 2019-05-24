using System;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    class Program
    {
        static void Main(string[] args)
        {
            String inTitleId;
            int iQty;
            Console.Write("Enter Title ID: ");
            inTitleId = Console.ReadLine();
            Console.Write("Enter Quantity: ");
            iQty = int.Parse(Console.ReadLine());

            String connString = "Data Source=localhost;" +
                "Initial Catalog=pubs;" +
                "Integrated Security=true ";

            SqlConnection conn = new SqlConnection(connString);

            runProc(conn, inTitleId, iQty);
        }

        public static void runProc(SqlConnection conn, String inTitleId, int iQty)
        {
            SqlCommand rSproc = new SqlCommand("prAddToOrder", conn);
            rSproc.CommandType = System.Data.CommandType.StoredProcedure;

            SqlParameter spReturn = new SqlParameter();
            spReturn.ParameterName = "@return_value";
            spReturn.SqlDbType = System.Data.SqlDbType.Int;
            spReturn.Direction = System.Data.ParameterDirection.ReturnValue;
            rSproc.Parameters.Add(spReturn);

            SqlParameter sp_tParam = new SqlParameter();
            sp_tParam.ParameterName = "@inTitleId";
            sp_tParam.SqlDbType = System.Data.SqlDbType.Text;
            sp_tParam.Size = 12;
            sp_tParam.Direction = System.Data.ParameterDirection.Input;
            sp_tParam.Value = inTitleId;
            rSproc.Parameters.Add(sp_tParam);

            SqlParameter sp_qParam = new SqlParameter();
            sp_qParam.ParameterName = "@inIncrease";
            sp_qParam.SqlDbType = System.Data.SqlDbType.Int;
            sp_qParam.Direction = System.Data.ParameterDirection.Input;
            sp_qParam.Value = iQty;
            rSproc.Parameters.Add(sp_qParam);

            SqlParameter sp_oParam = new SqlParameter();
            sp_oParam.ParameterName = "@outTotalAdd";
            sp_oParam.SqlDbType = System.Data.SqlDbType.Int;
            sp_oParam.Direction = System.Data.ParameterDirection.Output;
            rSproc.Parameters.Add(sp_oParam);

            conn.Open();

            try
            {
                rSproc.ExecuteNonQuery();
                Console.WriteLine("Added: " + rSproc.Parameters[3].Value.ToString());
            }
            catch (SqlException e)
            {
                Console.WriteLine("SqlError: " + e.Message);
            }

            rSproc.ExecuteNonQuery();
        }
    }
}
