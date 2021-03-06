﻿//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.ComponentModel;
using System.Data.EntityClient;
using System.Data.Objects;
using System.Data.Objects.DataClasses;
using System.Linq;
using System.Runtime.Serialization;
using System.Xml.Serialization;

[assembly: EdmSchemaAttribute()]
namespace LocationFinder
{
    #region Contexts
    
    /// <summary>
    /// No Metadata Documentation available.
    /// </summary>
    public partial class NursingHomeEntities : ObjectContext
    {
        #region Constructors
    
        /// <summary>
        /// Initializes a new NursingHomeEntities object using the connection string found in the 'NursingHomeEntities' section of the application configuration file.
        /// </summary>
        public NursingHomeEntities() : base("name=NursingHomeEntities", "NursingHomeEntities")
        {
            this.ContextOptions.LazyLoadingEnabled = true;
            OnContextCreated();
        }
    
        /// <summary>
        /// Initialize a new NursingHomeEntities object.
        /// </summary>
        public NursingHomeEntities(string connectionString) : base(connectionString, "NursingHomeEntities")
        {
            this.ContextOptions.LazyLoadingEnabled = true;
            OnContextCreated();
        }
    
        /// <summary>
        /// Initialize a new NursingHomeEntities object.
        /// </summary>
        public NursingHomeEntities(EntityConnection connection) : base(connection, "NursingHomeEntities")
        {
            this.ContextOptions.LazyLoadingEnabled = true;
            OnContextCreated();
        }
    
        #endregion
    
        #region Partial Methods
    
        partial void OnContextCreated();
    
        #endregion
    
        #region ObjectSet Properties
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        public ObjectSet<Home> Homes
        {
            get
            {
                if ((_Homes == null))
                {
                    _Homes = base.CreateObjectSet<Home>("Homes");
                }
                return _Homes;
            }
        }
        private ObjectSet<Home> _Homes;

        #endregion

        #region AddTo Methods
    
        /// <summary>
        /// Deprecated Method for adding a new object to the Homes EntitySet. Consider using the .Add method of the associated ObjectSet&lt;T&gt; property instead.
        /// </summary>
        public void AddToHomes(Home home)
        {
            base.AddObject("Homes", home);
        }

        #endregion

    }

    #endregion

    #region Entities
    
    /// <summary>
    /// No Metadata Documentation available.
    /// </summary>
    [EdmEntityTypeAttribute(NamespaceName="NursingHomeModel", Name="Home")]
    [Serializable()]
    [DataContractAttribute(IsReference=true)]
    public partial class Home : EntityObject
    {
        #region Factory Method
    
        /// <summary>
        /// Create a new Home object.
        /// </summary>
        /// <param name="id">Initial value of the ID property.</param>
        /// <param name="name">Initial value of the Name property.</param>
        /// <param name="street">Initial value of the Street property.</param>
        /// <param name="city">Initial value of the City property.</param>
        /// <param name="stateCode">Initial value of the StateCode property.</param>
        /// <param name="zipCode">Initial value of the ZipCode property.</param>
        /// <param name="phoneNumber">Initial value of the PhoneNumber property.</param>
        /// <param name="categoryType">Initial value of the CategoryType property.</param>
        /// <param name="ownershipType">Initial value of the OwnershipType property.</param>
        /// <param name="healthSurveyDate">Initial value of the HealthSurveyDate property.</param>
        /// <param name="fireSurveyDate">Initial value of the FireSurveyDate property.</param>
        /// <param name="certifiedBedCount">Initial value of the CertifiedBedCount property.</param>
        /// <param name="residentCount">Initial value of the ResidentCount property.</param>
        /// <param name="sprinklerStatus">Initial value of the SprinklerStatus property.</param>
        /// <param name="isInHospital">Initial value of the IsInHospital property.</param>
        /// <param name="isMultipleNursingHomeOwnership">Initial value of the IsMultipleNursingHomeOwnership property.</param>
        /// <param name="councilType">Initial value of the CouncilType property.</param>
        /// <param name="isInContinuingCareRetirementCommunity">Initial value of the IsInContinuingCareRetirementCommunity property.</param>
        /// <param name="hasQualitySurvey">Initial value of the HasQualitySurvey property.</param>
        /// <param name="isSpecialFocusFacility">Initial value of the IsSpecialFocusFacility property.</param>
        public static Home CreateHome(global::System.String id, global::System.String name, global::System.String street, global::System.String city, global::System.String stateCode, global::System.Int32 zipCode, global::System.Int64 phoneNumber, global::System.String categoryType, global::System.String ownershipType, global::System.DateTime healthSurveyDate, global::System.DateTime fireSurveyDate, global::System.Int32 certifiedBedCount, global::System.Int32 residentCount, global::System.String sprinklerStatus, global::System.Boolean isInHospital, global::System.Boolean isMultipleNursingHomeOwnership, global::System.String councilType, global::System.Boolean isInContinuingCareRetirementCommunity, global::System.Boolean hasQualitySurvey, global::System.Boolean isSpecialFocusFacility)
        {
            Home home = new Home();
            home.ID = id;
            home.Name = name;
            home.Street = street;
            home.City = city;
            home.StateCode = stateCode;
            home.ZipCode = zipCode;
            home.PhoneNumber = phoneNumber;
            home.CategoryType = categoryType;
            home.OwnershipType = ownershipType;
            home.HealthSurveyDate = healthSurveyDate;
            home.FireSurveyDate = fireSurveyDate;
            home.CertifiedBedCount = certifiedBedCount;
            home.ResidentCount = residentCount;
            home.SprinklerStatus = sprinklerStatus;
            home.IsInHospital = isInHospital;
            home.IsMultipleNursingHomeOwnership = isMultipleNursingHomeOwnership;
            home.CouncilType = councilType;
            home.IsInContinuingCareRetirementCommunity = isInContinuingCareRetirementCommunity;
            home.HasQualitySurvey = hasQualitySurvey;
            home.IsSpecialFocusFacility = isSpecialFocusFacility;
            return home;
        }

        #endregion

        #region Primitive Properties
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=true, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.String ID
        {
            get
            {
                return _ID;
            }
            set
            {
                if (_ID != value)
                {
                    OnIDChanging(value);
                    ReportPropertyChanging("ID");
                    _ID = StructuralObject.SetValidValue(value, false);
                    ReportPropertyChanged("ID");
                    OnIDChanged();
                }
            }
        }
        private global::System.String _ID;
        partial void OnIDChanging(global::System.String value);
        partial void OnIDChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.String Name
        {
            get
            {
                return _Name;
            }
            set
            {
                OnNameChanging(value);
                ReportPropertyChanging("Name");
                _Name = StructuralObject.SetValidValue(value, false);
                ReportPropertyChanged("Name");
                OnNameChanged();
            }
        }
        private global::System.String _Name;
        partial void OnNameChanging(global::System.String value);
        partial void OnNameChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.String Street
        {
            get
            {
                return _Street;
            }
            set
            {
                OnStreetChanging(value);
                ReportPropertyChanging("Street");
                _Street = StructuralObject.SetValidValue(value, false);
                ReportPropertyChanged("Street");
                OnStreetChanged();
            }
        }
        private global::System.String _Street;
        partial void OnStreetChanging(global::System.String value);
        partial void OnStreetChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.String City
        {
            get
            {
                return _City;
            }
            set
            {
                OnCityChanging(value);
                ReportPropertyChanging("City");
                _City = StructuralObject.SetValidValue(value, false);
                ReportPropertyChanged("City");
                OnCityChanged();
            }
        }
        private global::System.String _City;
        partial void OnCityChanging(global::System.String value);
        partial void OnCityChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=true)]
        [DataMemberAttribute()]
        public Nullable<global::System.Int32> CountyCode
        {
            get
            {
                return _CountyCode;
            }
            set
            {
                OnCountyCodeChanging(value);
                ReportPropertyChanging("CountyCode");
                _CountyCode = StructuralObject.SetValidValue(value);
                ReportPropertyChanged("CountyCode");
                OnCountyCodeChanged();
            }
        }
        private Nullable<global::System.Int32> _CountyCode;
        partial void OnCountyCodeChanging(Nullable<global::System.Int32> value);
        partial void OnCountyCodeChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=true)]
        [DataMemberAttribute()]
        public global::System.String CountyName
        {
            get
            {
                return _CountyName;
            }
            set
            {
                OnCountyNameChanging(value);
                ReportPropertyChanging("CountyName");
                _CountyName = StructuralObject.SetValidValue(value, true);
                ReportPropertyChanged("CountyName");
                OnCountyNameChanged();
            }
        }
        private global::System.String _CountyName;
        partial void OnCountyNameChanging(global::System.String value);
        partial void OnCountyNameChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.String StateCode
        {
            get
            {
                return _StateCode;
            }
            set
            {
                OnStateCodeChanging(value);
                ReportPropertyChanging("StateCode");
                _StateCode = StructuralObject.SetValidValue(value, false);
                ReportPropertyChanged("StateCode");
                OnStateCodeChanged();
            }
        }
        private global::System.String _StateCode;
        partial void OnStateCodeChanging(global::System.String value);
        partial void OnStateCodeChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.Int32 ZipCode
        {
            get
            {
                return _ZipCode;
            }
            set
            {
                OnZipCodeChanging(value);
                ReportPropertyChanging("ZipCode");
                _ZipCode = StructuralObject.SetValidValue(value);
                ReportPropertyChanged("ZipCode");
                OnZipCodeChanged();
            }
        }
        private global::System.Int32 _ZipCode;
        partial void OnZipCodeChanging(global::System.Int32 value);
        partial void OnZipCodeChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.Int64 PhoneNumber
        {
            get
            {
                return _PhoneNumber;
            }
            set
            {
                OnPhoneNumberChanging(value);
                ReportPropertyChanging("PhoneNumber");
                _PhoneNumber = StructuralObject.SetValidValue(value);
                ReportPropertyChanged("PhoneNumber");
                OnPhoneNumberChanged();
            }
        }
        private global::System.Int64 _PhoneNumber;
        partial void OnPhoneNumberChanging(global::System.Int64 value);
        partial void OnPhoneNumberChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=true)]
        [DataMemberAttribute()]
        public Nullable<global::System.Double> Latitude
        {
            get
            {
                return _Latitude;
            }
            set
            {
                OnLatitudeChanging(value);
                ReportPropertyChanging("Latitude");
                _Latitude = StructuralObject.SetValidValue(value);
                ReportPropertyChanged("Latitude");
                OnLatitudeChanged();
            }
        }
        private Nullable<global::System.Double> _Latitude;
        partial void OnLatitudeChanging(Nullable<global::System.Double> value);
        partial void OnLatitudeChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=true)]
        [DataMemberAttribute()]
        public Nullable<global::System.Double> Longitude
        {
            get
            {
                return _Longitude;
            }
            set
            {
                OnLongitudeChanging(value);
                ReportPropertyChanging("Longitude");
                _Longitude = StructuralObject.SetValidValue(value);
                ReportPropertyChanged("Longitude");
                OnLongitudeChanged();
            }
        }
        private Nullable<global::System.Double> _Longitude;
        partial void OnLongitudeChanging(Nullable<global::System.Double> value);
        partial void OnLongitudeChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.String CategoryType
        {
            get
            {
                return _CategoryType;
            }
            set
            {
                OnCategoryTypeChanging(value);
                ReportPropertyChanging("CategoryType");
                _CategoryType = StructuralObject.SetValidValue(value, false);
                ReportPropertyChanged("CategoryType");
                OnCategoryTypeChanged();
            }
        }
        private global::System.String _CategoryType;
        partial void OnCategoryTypeChanging(global::System.String value);
        partial void OnCategoryTypeChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.String OwnershipType
        {
            get
            {
                return _OwnershipType;
            }
            set
            {
                OnOwnershipTypeChanging(value);
                ReportPropertyChanging("OwnershipType");
                _OwnershipType = StructuralObject.SetValidValue(value, false);
                ReportPropertyChanged("OwnershipType");
                OnOwnershipTypeChanged();
            }
        }
        private global::System.String _OwnershipType;
        partial void OnOwnershipTypeChanging(global::System.String value);
        partial void OnOwnershipTypeChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.DateTime HealthSurveyDate
        {
            get
            {
                return _HealthSurveyDate;
            }
            set
            {
                OnHealthSurveyDateChanging(value);
                ReportPropertyChanging("HealthSurveyDate");
                _HealthSurveyDate = StructuralObject.SetValidValue(value);
                ReportPropertyChanged("HealthSurveyDate");
                OnHealthSurveyDateChanged();
            }
        }
        private global::System.DateTime _HealthSurveyDate;
        partial void OnHealthSurveyDateChanging(global::System.DateTime value);
        partial void OnHealthSurveyDateChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.DateTime FireSurveyDate
        {
            get
            {
                return _FireSurveyDate;
            }
            set
            {
                OnFireSurveyDateChanging(value);
                ReportPropertyChanging("FireSurveyDate");
                _FireSurveyDate = StructuralObject.SetValidValue(value);
                ReportPropertyChanged("FireSurveyDate");
                OnFireSurveyDateChanged();
            }
        }
        private global::System.DateTime _FireSurveyDate;
        partial void OnFireSurveyDateChanging(global::System.DateTime value);
        partial void OnFireSurveyDateChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.Int32 CertifiedBedCount
        {
            get
            {
                return _CertifiedBedCount;
            }
            set
            {
                OnCertifiedBedCountChanging(value);
                ReportPropertyChanging("CertifiedBedCount");
                _CertifiedBedCount = StructuralObject.SetValidValue(value);
                ReportPropertyChanged("CertifiedBedCount");
                OnCertifiedBedCountChanged();
            }
        }
        private global::System.Int32 _CertifiedBedCount;
        partial void OnCertifiedBedCountChanging(global::System.Int32 value);
        partial void OnCertifiedBedCountChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.Int32 ResidentCount
        {
            get
            {
                return _ResidentCount;
            }
            set
            {
                OnResidentCountChanging(value);
                ReportPropertyChanging("ResidentCount");
                _ResidentCount = StructuralObject.SetValidValue(value);
                ReportPropertyChanged("ResidentCount");
                OnResidentCountChanged();
            }
        }
        private global::System.Int32 _ResidentCount;
        partial void OnResidentCountChanging(global::System.Int32 value);
        partial void OnResidentCountChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.String SprinklerStatus
        {
            get
            {
                return _SprinklerStatus;
            }
            set
            {
                OnSprinklerStatusChanging(value);
                ReportPropertyChanging("SprinklerStatus");
                _SprinklerStatus = StructuralObject.SetValidValue(value, false);
                ReportPropertyChanged("SprinklerStatus");
                OnSprinklerStatusChanged();
            }
        }
        private global::System.String _SprinklerStatus;
        partial void OnSprinklerStatusChanging(global::System.String value);
        partial void OnSprinklerStatusChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.Boolean IsInHospital
        {
            get
            {
                return _IsInHospital;
            }
            set
            {
                OnIsInHospitalChanging(value);
                ReportPropertyChanging("IsInHospital");
                _IsInHospital = StructuralObject.SetValidValue(value);
                ReportPropertyChanged("IsInHospital");
                OnIsInHospitalChanged();
            }
        }
        private global::System.Boolean _IsInHospital;
        partial void OnIsInHospitalChanging(global::System.Boolean value);
        partial void OnIsInHospitalChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.Boolean IsMultipleNursingHomeOwnership
        {
            get
            {
                return _IsMultipleNursingHomeOwnership;
            }
            set
            {
                OnIsMultipleNursingHomeOwnershipChanging(value);
                ReportPropertyChanging("IsMultipleNursingHomeOwnership");
                _IsMultipleNursingHomeOwnership = StructuralObject.SetValidValue(value);
                ReportPropertyChanged("IsMultipleNursingHomeOwnership");
                OnIsMultipleNursingHomeOwnershipChanged();
            }
        }
        private global::System.Boolean _IsMultipleNursingHomeOwnership;
        partial void OnIsMultipleNursingHomeOwnershipChanging(global::System.Boolean value);
        partial void OnIsMultipleNursingHomeOwnershipChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.String CouncilType
        {
            get
            {
                return _CouncilType;
            }
            set
            {
                OnCouncilTypeChanging(value);
                ReportPropertyChanging("CouncilType");
                _CouncilType = StructuralObject.SetValidValue(value, false);
                ReportPropertyChanged("CouncilType");
                OnCouncilTypeChanged();
            }
        }
        private global::System.String _CouncilType;
        partial void OnCouncilTypeChanging(global::System.String value);
        partial void OnCouncilTypeChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.Boolean IsInContinuingCareRetirementCommunity
        {
            get
            {
                return _IsInContinuingCareRetirementCommunity;
            }
            set
            {
                OnIsInContinuingCareRetirementCommunityChanging(value);
                ReportPropertyChanging("IsInContinuingCareRetirementCommunity");
                _IsInContinuingCareRetirementCommunity = StructuralObject.SetValidValue(value);
                ReportPropertyChanged("IsInContinuingCareRetirementCommunity");
                OnIsInContinuingCareRetirementCommunityChanged();
            }
        }
        private global::System.Boolean _IsInContinuingCareRetirementCommunity;
        partial void OnIsInContinuingCareRetirementCommunityChanging(global::System.Boolean value);
        partial void OnIsInContinuingCareRetirementCommunityChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.Boolean HasQualitySurvey
        {
            get
            {
                return _HasQualitySurvey;
            }
            set
            {
                OnHasQualitySurveyChanging(value);
                ReportPropertyChanging("HasQualitySurvey");
                _HasQualitySurvey = StructuralObject.SetValidValue(value);
                ReportPropertyChanged("HasQualitySurvey");
                OnHasQualitySurveyChanged();
            }
        }
        private global::System.Boolean _HasQualitySurvey;
        partial void OnHasQualitySurveyChanging(global::System.Boolean value);
        partial void OnHasQualitySurveyChanged();
    
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]
        [DataMemberAttribute()]
        public global::System.Boolean IsSpecialFocusFacility
        {
            get
            {
                return _IsSpecialFocusFacility;
            }
            set
            {
                OnIsSpecialFocusFacilityChanging(value);
                ReportPropertyChanging("IsSpecialFocusFacility");
                _IsSpecialFocusFacility = StructuralObject.SetValidValue(value);
                ReportPropertyChanged("IsSpecialFocusFacility");
                OnIsSpecialFocusFacilityChanged();
            }
        }
        private global::System.Boolean _IsSpecialFocusFacility;
        partial void OnIsSpecialFocusFacilityChanging(global::System.Boolean value);
        partial void OnIsSpecialFocusFacilityChanged();

        #endregion

    
    }

    #endregion

    
}
