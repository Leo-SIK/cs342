//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace MRPProject
{
    using System;
    using System.Collections.Generic;
    
    public partial class CustomerOrder
    {
        public int OrderID { get; set; }
        public int CustomerID { get; set; }
        public int ProductID { get; set; }
        public int Quantity { get; set; }
        public System.DateTime DateAvailable { get; set; }
        public System.DateTime OrderDate { get; set; }
        public bool SplitShipments { get; set; }
        public bool Shipped { get; set; }
    
        public virtual Customer Customer { get; set; }
        public virtual Part Part { get; set; }
    }
}