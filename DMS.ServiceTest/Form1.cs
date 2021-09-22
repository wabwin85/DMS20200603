using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Configuration;
using System.Threading;

namespace DMS.ServiceTest
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private PlatformService.Platform GetClient()
        {
            PlatformService.Platform client = new DMS.ServiceTest.PlatformService.Platform();
            client.AuthHeaderValue = new DMS.ServiceTest.PlatformService.AuthHeader();
            client.AuthHeaderValue.User = this.textBox1.Text;
            client.AuthHeaderValue.Password = this.textBox2.Text;

            client.Timeout = Timeout.Infinite;

            return client;
        }

        private HospitalService.Hospital GetHospitalClient()
        {
            HospitalService.Hospital client = new DMS.ServiceTest.HospitalService.Hospital();
            client.AuthHeaderValue = new DMS.ServiceTest.HospitalService.AuthHeader();
            client.AuthHeaderValue.User = this.textBox1.Text;
            client.AuthHeaderValue.Password = this.textBox2.Text;

            client.Timeout = Timeout.Infinite;

            return client;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().DownloadDealerOrder();
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().DownloadDealerReturn();
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }

        }

        private void button3_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().DownloadDealerSales();
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }

        }

        private void button4_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().DownloadLpDistributor();
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }

        }

        private void button5_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().DownloadLpHospital();
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }

        }

        private void button6_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().DownloadLpOrder();
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }

        }

        private void button7_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().DownloadLpReturn();
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }

        }

        private void button15_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().DownloadLpShipment();
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }

        }

        private void button8_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().UploadConsignmentWarehouse(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }

        }

        private void button10_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().UploadDealerConsignment(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }

        }

        private void button12_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().UploadDealerOrderConfirmation(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }

        }

        private void button14_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().UploadDealerShipment(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }

        }

        private void button13_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().UploadLpAdjust(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }

        }

        private void button11_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().UploadLpBorrow(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }

        }

        private void button9_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().UploadLpReturnConfirm(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }

        }

        private void button17_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().UploadLpSales(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }

        }

        private void button16_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().UploadLpShipmentConfirm(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }

        }

        private void button18_Click(object sender, EventArgs e)
        {
            try
            {
                BSCService.BIInterface client = new DMS.ServiceTest.BSCService.BIInterface();
                string rtn = client.ReadData(1, "midwj#567YU");                
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button19_Click(object sender, EventArgs e)
        {
            try
            {
                BSCService.BIInterface client = new DMS.ServiceTest.BSCService.BIInterface();
                int rtn = client.WriteData(1, "midwj#567YU",this.richTextBox1.Text);
                this.richTextBox2.Text = rtn.ToString();
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button20_Click(object sender, EventArgs e)
        {
            try
            {
                ShareTracService.outlet client = new DMS.ServiceTest.ShareTracService.outlet();
                DataTable dt = client.GetHospitalPrivilege("bsc", "WERJ783DS");
                if (dt != null && dt.Rows.Count > 0)
                {
                    SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                    SqlBulkCopy bulkCopy = new SqlBulkCopy(sqlConn);
                    bulkCopy.DestinationTableName = "HospitalPrivilege";
                    bulkCopy.BatchSize = dt.Rows.Count;
                    try
                    {
                        sqlConn.Open();
                        bulkCopy.WriteToServer(dt);
                    }
                    catch (Exception ex1)
                    {
                        throw ex1;
                    }
                    finally
                    {
                        if (bulkCopy != null)
                        {
                            bulkCopy.Close();
                            bulkCopy = null;
                        }
                        if (sqlConn != null)
                        {
                            sqlConn.Close();
                            sqlConn = null;
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button21_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().DownloadBSCInvoiceData();
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button22_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().DownloadProductData();
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button23_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().UploadDealerSalesWritebackData(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }

        }

        private void button24_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().UploadDealerReturnConfirmData(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button25_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().UploadDealerConsignmentSalesPrice(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button26_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().DownLoadLPComplain();
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button27_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().DownloadT2DealerConsignmentToSelling();
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button28_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().DownloadLPRent();
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button29_Click(object sender, EventArgs e)
        {
            try
            {
            HospitalService.Hospital client = new DMS.ServiceTest.HospitalService.Hospital();
            client.AuthHeaderValue = new DMS.ServiceTest.HospitalService.AuthHeader();
            client.AuthHeaderValue.User = "EAI";
            client.AuthHeaderValue.Password = "midwj#567YU";
            client.Timeout = Timeout.Infinite;
            string rtn = client.DownloadDealerInventoryWithQR(this.textBox1.Text, this.textBox2.Text);
            this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button30_Click(object sender, EventArgs e)
        {
            try
            {

                HospitalService.Hospital client = new DMS.ServiceTest.HospitalService.Hospital();

                client.AuthHeaderValue = new DMS.ServiceTest.HospitalService.AuthHeader();
                client.AuthHeaderValue.User = this.textBox1.Text;
                client.AuthHeaderValue.Password = this.textBox2.Text;

                client.Timeout = Timeout.Infinite;

                string rtn = client.DownloadChannelLogisticInfoWithQR(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button31_Click(object sender, EventArgs e)
        {
            try
            {

                HospitalService.Hospital client = new DMS.ServiceTest.HospitalService.Hospital();

                client.AuthHeaderValue = new DMS.ServiceTest.HospitalService.AuthHeader();
                client.AuthHeaderValue.User = this.textBox1.Text;
                client.AuthHeaderValue.Password = this.textBox2.Text;

                client.Timeout = Timeout.Infinite;

                string rtn = client.UploadHospitalTransactionWithQR(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button32_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn =GetClient().UploadT2PointsAdjustment(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button33_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().UploadT2CreditMemo(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button34_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().DownloadDMSCalculatedPoints();
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button35_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().UploadBSCDelivery(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button36_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetHospitalClient().UploadRedCrossHospitalTransactionWithQR(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }

        }

        private void button37_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().DownloadT2CommercialIndex(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }

        private void button38_Click(object sender, EventArgs e)
        {
            try
            {
                string rtn = GetClient().UploadLpTransfer(this.richTextBox1.Text);
                this.richTextBox2.Text = rtn;
            }
            catch (Exception ex)
            {
                this.richTextBox2.Text = ex.ToString();
            }
        }
    }
}
