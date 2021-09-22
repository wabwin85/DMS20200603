/**********************************************
 *
 * NameSpace   : DMS.Common 
 * ClassName   : DMSException
 * Created Time: 2009-7 
 * Author      : Donson
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Common
{
    using Grapecity.Exceptions;

    /// <summary>
    /// DMSException 异常类型
    /// </summary>
    public class DMSException : GrapecityException
    {
        /// <summary>
        /// ExceptionCode默认异常代码 3000
        /// </summary>
        public const int DMSExceptionCode = 3000;

        /// <summary>
        /// Initializes a new instance of the <see cref="DMSException"/> class.
        /// </summary>
        /// <param name="message">The message.</param>
        public DMSException(string message) : base(message, DMSExceptionCode) 
        {
 
        }


        /// <summary>
        /// Initializes a new instance of the <see cref="DMSException"/> class.
        /// </summary>
        public DMSException() : this("DMS Application Exception.") { }

        /// <summary>
        /// Initializes a new instance of the <see cref="DMSException"/> class.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="inner">The inner.</param>
        public DMSException(string message, Exception inner)
            : base(message, DMSExceptionCode, inner) { }

        /// <summary>
        /// Initializes a new instance of the <see cref="DMSException"/> class.
        /// </summary>
        /// <param name="ex">The ex.</param>
        public DMSException(Exception ex)
            : this("DMS Application Exception", ex) { }

    }
}
