﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class MRPEntities : DbContext
    {
        public MRPEntities()
            : base("name=MRPEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<Address> Addresses { get; set; }
        public virtual DbSet<BillOfMaterial> BillOfMaterials { get; set; }
        public virtual DbSet<Credit> Credits { get; set; }
        public virtual DbSet<Customer> Customers { get; set; }
        public virtual DbSet<CustomerOrder> CustomerOrders { get; set; }
        public virtual DbSet<Inventory> Inventories { get; set; }
        public virtual DbSet<JobOrder> JobOrders { get; set; }
        public virtual DbSet<Part> Parts { get; set; }
        public virtual DbSet<Resource> Resources { get; set; }
        public virtual DbSet<VendorOrder> VendorOrders { get; set; }
        public virtual DbSet<Vendor> Vendors { get; set; }
    
        public virtual int spChangePartVendor(Nullable<int> partID, Nullable<int> vendorID)
        {
            var partIDParameter = partID.HasValue ?
                new ObjectParameter("partID", partID) :
                new ObjectParameter("partID", typeof(int));
    
            var vendorIDParameter = vendorID.HasValue ?
                new ObjectParameter("vendorID", vendorID) :
                new ObjectParameter("vendorID", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("spChangePartVendor", partIDParameter, vendorIDParameter);
        }
    
        public virtual int spInsertAddress(string streetAddress, string city, string state, string country, string postalCode)
        {
            var streetAddressParameter = streetAddress != null ?
                new ObjectParameter("streetAddress", streetAddress) :
                new ObjectParameter("streetAddress", typeof(string));
    
            var cityParameter = city != null ?
                new ObjectParameter("city", city) :
                new ObjectParameter("city", typeof(string));
    
            var stateParameter = state != null ?
                new ObjectParameter("state", state) :
                new ObjectParameter("state", typeof(string));
    
            var countryParameter = country != null ?
                new ObjectParameter("country", country) :
                new ObjectParameter("country", typeof(string));
    
            var postalCodeParameter = postalCode != null ?
                new ObjectParameter("postalCode", postalCode) :
                new ObjectParameter("postalCode", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("spInsertAddress", streetAddressParameter, cityParameter, stateParameter, countryParameter, postalCodeParameter);
        }
    
        public virtual int spInsertVendor(string vendorName, string vendorContact, string vendorPhoneNumber, Nullable<int> vendorAddressID, string vendorRating)
        {
            var vendorNameParameter = vendorName != null ?
                new ObjectParameter("vendorName", vendorName) :
                new ObjectParameter("vendorName", typeof(string));
    
            var vendorContactParameter = vendorContact != null ?
                new ObjectParameter("vendorContact", vendorContact) :
                new ObjectParameter("vendorContact", typeof(string));
    
            var vendorPhoneNumberParameter = vendorPhoneNumber != null ?
                new ObjectParameter("vendorPhoneNumber", vendorPhoneNumber) :
                new ObjectParameter("vendorPhoneNumber", typeof(string));
    
            var vendorAddressIDParameter = vendorAddressID.HasValue ?
                new ObjectParameter("vendorAddressID", vendorAddressID) :
                new ObjectParameter("vendorAddressID", typeof(int));
    
            var vendorRatingParameter = vendorRating != null ?
                new ObjectParameter("vendorRating", vendorRating) :
                new ObjectParameter("vendorRating", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("spInsertVendor", vendorNameParameter, vendorContactParameter, vendorPhoneNumberParameter, vendorAddressIDParameter, vendorRatingParameter);
        }
    }
}
