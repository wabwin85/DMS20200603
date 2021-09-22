
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

namespace DMS.Model
{
    using DMS.Common;

    public enum RowState
    {
        Unchanged,
        Added,
        Modified,
        Deleted
    }

    /// <summary>
    /// 所有实体的基类
    /// </summary>	
    [Serializable]
    public abstract class BaseModel : ICloneable, IEditableObject
    {

        #region base Method
        protected BaseModel _oldValue = null;

        private RowState _state = RowState.Unchanged;
        private bool _Editing = false;
        private bool _delete_flag = false;

        public BaseModel()
        {
            this._state = RowState.Unchanged;
        }

        protected void SetRowState(RowState state)
        {
            _state = state;
        }

        public RowState State
        {
            get { return _state; }
        }

        public virtual void AcceptChanged()
        {
            _state = RowState.Unchanged;
            _oldValue = null;
            this._Editing = false;
        }

        /// <summary>
        /// 实现深度Clone
        /// </summary>
        public virtual object Clone()
        {
            MemoryStream stream = new MemoryStream();
            BinaryFormatter formatter = new BinaryFormatter();
            formatter.Serialize(stream, this);
            stream.Position = 0;
            return formatter.Deserialize(stream);
        }

        public virtual void BeginEdit()
        {
            //将当前数据的状态，属性进行临时的保存一下
            if (!this._Editing)
            {
                this._Editing = true;
                //this._oldValue = this.Clone() as baseDomain;
            }
        }

        public virtual void CancelEdit()
        {
            if (this._Editing)
            {
                _oldValue = null;
            }
        }

        public virtual void EndEdit()
        {
            if (this._Editing)
            {
                if (this.State == RowState.Added)
                {
                    this.LastUpdateDate = DateTime.Now;
                    this.CreateDate = this.LastUpdateDate;
                }
                else
                {
                    this.LastUpdateDate = DateTime.Now;
                }

                this._Editing = false;
            }
        }

        #endregion

        public virtual void PropertyChanged()
        {
            if (this._state == RowState.Unchanged)
                this._state = RowState.Modified;
        }

        public int row_number { get; set; }

        public bool DeletedFlag 
        { 
            get { return _delete_flag; } 
            set { _delete_flag = value; } 
        }

        public Guid? CreateUser { get; set; }

        private DateTime? _createDate = null;
        public virtual DateTime? CreateDate
        {
            get { return _createDate; }
            set { _createDate = value; }
        }

        public Guid? LastUpdateUser { get; set; }

        private DateTime? _lastUpdateDate = DateTime.Now;

        public virtual DateTime? LastUpdateDate {
            get { return _lastUpdateDate; }
            set { _lastUpdateDate = value; } 
        }


        /// <summary>
        /// Gets or sets the owner id.
        /// </summary>
        /// <value>The owner id.</value>
        public Guid? OwnerId { get; set; }

        /// <summary>
        /// Gets or sets the owner organization units.
        /// </summary>
        /// <value>The owner organization units.</value>
        public string[] OwnerOrganizationUnits { get;set;}

        /// <summary>
        /// Gets or sets the owner corp id.
        /// </summary>
        /// <value>The owner corp id.</value>
        public Guid OwnerCorporationId { get; set; }

        /// <summary>
        /// Gets or sets the type of the identity.
        /// </summary>
        /// <value>The type of the identity.</value>
        public string OwnerIdentityType
        {
            get;
            set;
        }

        public Guid? SubCompanyId { get; set; }
        public string SubCompanyName { get; set; }
        public Guid? BrandId { get; set; }
        public string BrandName { get; set; }

    }
}
