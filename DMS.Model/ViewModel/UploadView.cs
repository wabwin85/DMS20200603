using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.ViewModel
{
    public class UploadView
    {
        public UploadView()
        {
            Data = new ArrayList();
        }
        /// <summary>
        /// 返回状态成功，失败，缺少列等
        /// </summary>
        public string Status { get; set; }
        /// <summary>
        /// 文件路径
        /// </summary>
        public string FilePath { get; set; }
        /// <summary>
        /// 文件名
        /// </summary>
        public string FileName { get; set; }
        /// <summary>
        /// 文件大小
        /// </summary>
        public string FileSize { get; set; }
        /// <summary>
        /// 返回的错误信息
        /// </summary>
        public string Error { get; set; }
        /// <summary>
        /// 政策PID
        /// </summary>
        public string PID { get; set; }
        /// <summary>
        /// 备用字段
        /// </summary>
        public string CTemp { get; set; }
        /// <summary>
        ///例如： sheet1
        /// </summary>
        public string SheetName { get; set; }

        /// <summary>
        /// sheet的列数
        /// </summary>
        public string FieldCount { get; set; }

        /// <summary>
        /// 如：ExcelTemplate，一般为固定
        /// </summary>
        public string ForeignType { get; set; }

        /// <summary>
        /// 一般为下载的模版文件名字，Template_PromotionPointRatio.xls，加上后缀
        /// </summary>
        public string DownLoadFileName { get; set; }
        /// <summary>
        /// 下载下来的文件的全路径，用于直接解析
        /// </summary>
        public string UpLoadUrl { get; set; }

        /// <summary>
        /// 请求返回的数据
        /// </summary>
        public ArrayList Data { get; set; }

        /// <summary>
        /// 维护类型，区分是什么维护
        /// </summary>
        public string MaintainType { get; set; }

        /// <summary>
        /// 政策因素ID
        /// </summary>
        public string PolicyFactorID { get; set; }

        /// <summary>
        /// 政策因素类型
        /// </summary>
        public string PolicyFactorType { get; set; }

        /// <summary>
        /// 封顶值类型
        /// </summary>
        public string TopValType { get; set; }


    }
}
