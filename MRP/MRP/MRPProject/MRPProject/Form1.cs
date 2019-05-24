using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace MRPProject
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void label5_Click(object sender, EventArgs e)
        {

        }

        private void submitButton_Click(object sender, EventArgs e)
        {
            string vendorName = nameText.Text;
            string vendorContact = contactText.Text;
            string vendorPhoneNumber = phoneText.Text;
            string vendorAddress = addressText.Text;
            string vendorCity = cityText.Text;
            string vendorState = stateText.Text;
            string vendorCountry = countryText.Text;
            string vendorPostal = postalText.Text;
            string vendorRating = ratingText.Text;

            String connString = "Data Source=localhost;" +
                "Initial Catalog=MRP;Integrated Security=true;";

            SqlConnection conn = new SqlConnection(connString);

            SqlDataAdapter adapter = new SqlDataAdapter();

            try
            {
                conn.Open();

                SqlCommand insertAddressCommand = new SqlCommand("spInsertAddress", conn);
                insertAddressCommand.Parameters.Add(new SqlParameter("StreetAddress", vendorAddress));
                insertAddressCommand.Parameters.Add(new SqlParameter("City", vendorCity));
                insertAddressCommand.Parameters.Add(new SqlParameter("State", vendorState));
                insertAddressCommand.Parameters.Add(new SqlParameter("Country", vendorCountry));
                insertAddressCommand.Parameters.Add(new SqlParameter("PostalCode", vendorPostal));

                insertAddressCommand.CommandType = CommandType.StoredProcedure;
                insertAddressCommand.ExecuteNonQuery();

                SqlCommand selectAddressCommand = new SqlCommand("spSelectAddressID", conn);
                selectAddressCommand.Parameters.Add(new SqlParameter("StreetAddress", vendorAddress));
                selectAddressCommand.Parameters.Add(new SqlParameter("City", vendorCity));
                selectAddressCommand.Parameters.Add(new SqlParameter("State", vendorState));
                selectAddressCommand.Parameters.Add(new SqlParameter("Country", vendorCountry));
                selectAddressCommand.Parameters.Add(new SqlParameter("PostalCode", vendorPostal));

                selectAddressCommand.CommandType = CommandType.StoredProcedure;

                SqlDataReader reader = selectAddressCommand.ExecuteReader();

                reader.Read();

                int addressID = Convert.ToInt32(reader["AddressID"].ToString());

                reader.Close();
                
                SqlCommand insertVendorCommand = new SqlCommand("spInsertVendor", conn);
                insertVendorCommand.Parameters.Add(new SqlParameter("VendorName", vendorName));
                insertVendorCommand.Parameters.Add(new SqlParameter("ContactPerson", vendorContact));
                insertVendorCommand.Parameters.Add(new SqlParameter("PhoneNumber", vendorPhoneNumber));
                insertVendorCommand.Parameters.Add(new SqlParameter("VendorAddressID", addressID));
                insertVendorCommand.Parameters.Add(new SqlParameter("VendorRating", vendorRating));

                insertVendorCommand.CommandType = CommandType.StoredProcedure;
                insertVendorCommand.ExecuteNonQuery();

                MessageBox.Show(vendorName);

                SqlCommand selectVendorCommand = new SqlCommand("select VendorID from Vendors where VendorName = @VendorName and ContactPerson = @ContactPerson and PhoneNumber = @PhoneNumber and VendorAddressID = @VendorAddressID and VendorRating = @VendorRating", conn);
                selectVendorCommand.Parameters.Add(new SqlParameter("VendorName", vendorName));
                selectVendorCommand.Parameters.Add(new SqlParameter("ContactPerson", vendorContact));
                selectVendorCommand.Parameters.Add(new SqlParameter("PhoneNumber", vendorPhoneNumber));
                selectVendorCommand.Parameters.Add(new SqlParameter("VendorAddressID", addressID));
                selectVendorCommand.Parameters.Add(new SqlParameter("VendorRating", vendorRating));

                reader = selectVendorCommand.ExecuteReader();

                reader.Read();

                int vendorID = Convert.ToInt32(reader["VendorID"].ToString());

                reader.Close();

                int partID = 0;

                SqlCommand updatePartsCommand;

                foreach (object item in clbParts.CheckedItems)
                {
                    DataRowView rowItem = item as DataRowView;
                    partID = (int) rowItem["PartID"];

                    MessageBox.Show(vendorID.ToString());
                                        
                    updatePartsCommand = new SqlCommand("spChangePartVendor", conn);
                    updatePartsCommand.Parameters.Add(new SqlParameter("VendorID", vendorID));
                    updatePartsCommand.Parameters.Add(new SqlParameter("PartID", partID));

                    updatePartsCommand.CommandType = CommandType.StoredProcedure;
                    updatePartsCommand.ExecuteNonQuery();
                }
                
                conn.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }


        }

        private void checkedListBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
