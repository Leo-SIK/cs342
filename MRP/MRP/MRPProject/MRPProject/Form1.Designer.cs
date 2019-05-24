using System.Data;
using System.Data.SqlClient;

namespace MRPProject
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.nameText = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.contactText = new System.Windows.Forms.TextBox();
            this.phoneText = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.addressText = new System.Windows.Forms.TextBox();
            this.cityText = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.stateText = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.countryText = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.postalText = new System.Windows.Forms.TextBox();
            this.ratingText = new System.Windows.Forms.TextBox();
            this.label9 = new System.Windows.Forms.Label();
            this.submitButton = new System.Windows.Forms.Button();
            this.clbParts = new System.Windows.Forms.CheckedListBox();
            this.label10 = new System.Windows.Forms.Label();
            this.label11 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // nameText
            // 
            this.nameText.Location = new System.Drawing.Point(103, 43);
            this.nameText.Name = "nameText";
            this.nameText.Size = new System.Drawing.Size(133, 20);
            this.nameText.TabIndex = 0;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(13, 46);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(72, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "Vendor Name";
            this.label1.Click += new System.EventHandler(this.label1_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(13, 72);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(81, 13);
            this.label2.TabIndex = 2;
            this.label2.Text = "Vendor Contact";
            this.label2.Click += new System.EventHandler(this.label2_Click);
            // 
            // contactText
            // 
            this.contactText.Location = new System.Drawing.Point(103, 69);
            this.contactText.Name = "contactText";
            this.contactText.Size = new System.Drawing.Size(133, 20);
            this.contactText.TabIndex = 3;
            // 
            // phoneText
            // 
            this.phoneText.Location = new System.Drawing.Point(140, 95);
            this.phoneText.Name = "phoneText";
            this.phoneText.Size = new System.Drawing.Size(96, 20);
            this.phoneText.TabIndex = 4;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(13, 98);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(118, 13);
            this.label3.TabIndex = 5;
            this.label3.Text = "Contact Phone Number";
            this.label3.Click += new System.EventHandler(this.label3_Click);
            // 
            // addressText
            // 
            this.addressText.Location = new System.Drawing.Point(64, 121);
            this.addressText.Name = "addressText";
            this.addressText.Size = new System.Drawing.Size(172, 20);
            this.addressText.TabIndex = 6;
            // 
            // cityText
            // 
            this.cityText.Location = new System.Drawing.Point(64, 147);
            this.cityText.Name = "cityText";
            this.cityText.Size = new System.Drawing.Size(172, 20);
            this.cityText.TabIndex = 7;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(13, 124);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(45, 13);
            this.label4.TabIndex = 8;
            this.label4.Text = "Address";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(13, 150);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(24, 13);
            this.label5.TabIndex = 9;
            this.label5.Text = "City";
            this.label5.Click += new System.EventHandler(this.label5_Click);
            // 
            // stateText
            // 
            this.stateText.Location = new System.Drawing.Point(64, 173);
            this.stateText.Name = "stateText";
            this.stateText.Size = new System.Drawing.Size(172, 20);
            this.stateText.TabIndex = 10;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(13, 176);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(32, 13);
            this.label6.TabIndex = 11;
            this.label6.Text = "State";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(13, 202);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(43, 13);
            this.label7.TabIndex = 12;
            this.label7.Text = "Country";
            // 
            // countryText
            // 
            this.countryText.Location = new System.Drawing.Point(64, 199);
            this.countryText.Name = "countryText";
            this.countryText.Size = new System.Drawing.Size(172, 20);
            this.countryText.TabIndex = 13;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(13, 228);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(64, 13);
            this.label8.TabIndex = 14;
            this.label8.Text = "Postal Code";
            // 
            // postalText
            // 
            this.postalText.Location = new System.Drawing.Point(83, 225);
            this.postalText.Name = "postalText";
            this.postalText.Size = new System.Drawing.Size(153, 20);
            this.postalText.TabIndex = 15;
            // 
            // ratingText
            // 
            this.ratingText.Location = new System.Drawing.Point(83, 251);
            this.ratingText.Name = "ratingText";
            this.ratingText.Size = new System.Drawing.Size(153, 20);
            this.ratingText.TabIndex = 16;
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(13, 254);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(38, 13);
            this.label9.TabIndex = 17;
            this.label9.Text = "Rating";
            // 
            // submitButton
            // 
            this.submitButton.Location = new System.Drawing.Point(83, 293);
            this.submitButton.Name = "submitButton";
            this.submitButton.Size = new System.Drawing.Size(75, 23);
            this.submitButton.TabIndex = 18;
            this.submitButton.Text = "Submit";
            this.submitButton.UseVisualStyleBackColor = true;
            this.submitButton.Click += new System.EventHandler(this.submitButton_Click);
            // 
            // clbParts
            //

            string constr = "Data Source=localhost;" +
                "Initial Catalog=MRP;Integrated Security=true;";
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter("spSelectParts", con))
                {
                    //Fill the DataTable with records from Table.
                    DataTable dt = new DataTable();
                    sda.Fill(dt);

                    //Assign DataTable as DataSource.
                    clbParts.DataSource = dt;
                    clbParts.DisplayMember = "PartName";
                    clbParts.ValueMember = "PartId";
                }
            }


            this.clbParts.FormattingEnabled = true;
            this.clbParts.Location = new System.Drawing.Point(296, 43);
            this.clbParts.Name = "clbParts";
            this.clbParts.Size = new System.Drawing.Size(471, 334);
            this.clbParts.TabIndex = 19;
            this.clbParts.SelectedIndexChanged += new System.EventHandler(this.checkedListBox1_SelectedIndexChanged);
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(296, 24);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(152, 13);
            this.label10.TabIndex = 20;
            this.label10.Text = "Part to Change to New Vendor";
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Location = new System.Drawing.Point(13, 23);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(121, 13);
            this.label11.TabIndex = 21;
            this.label11.Text = "New Vendor Information";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(833, 450);
            this.Controls.Add(this.label11);
            this.Controls.Add(this.label10);
            this.Controls.Add(this.clbParts);
            this.Controls.Add(this.submitButton);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.ratingText);
            this.Controls.Add(this.postalText);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.countryText);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.stateText);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.cityText);
            this.Controls.Add(this.addressText);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.phoneText);
            this.Controls.Add(this.contactText);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.nameText);
            this.Name = "Form1";
            this.Text = "Form1";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox nameText;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox contactText;
        private System.Windows.Forms.TextBox phoneText;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox addressText;
        private System.Windows.Forms.TextBox cityText;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox stateText;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox countryText;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.TextBox postalText;
        private System.Windows.Forms.TextBox ratingText;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Button submitButton;
        private System.Windows.Forms.CheckedListBox clbParts;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Label label11;
    }
}

