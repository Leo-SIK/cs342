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
    
    public partial class Part
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Part()
        {
            this.BillOfMaterials = new HashSet<BillOfMaterial>();
            this.BillOfMaterials1 = new HashSet<BillOfMaterial>();
            this.CustomerOrders = new HashSet<CustomerOrder>();
            this.Inventories = new HashSet<Inventory>();
            this.JobOrders = new HashSet<JobOrder>();
            this.VendorOrders = new HashSet<VendorOrder>();
        }
    
        public int PartID { get; set; }
        public string PartName { get; set; }
        public string PartDescription { get; set; }
        public string PartType { get; set; }
        public decimal PartCost { get; set; }
        public Nullable<int> VendorID { get; set; }
        public Nullable<int> EconomicOrderQty { get; set; }
        public Nullable<int> SafetyStock { get; set; }
        public Nullable<int> OnHandMax { get; set; }
        public Nullable<int> OrderLeadTime { get; set; }
        public byte[] PartIllustration { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<BillOfMaterial> BillOfMaterials { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<BillOfMaterial> BillOfMaterials1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CustomerOrder> CustomerOrders { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Inventory> Inventories { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JobOrder> JobOrders { get; set; }
        public virtual Vendor Vendor { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VendorOrder> VendorOrders { get; set; }
    }
}
