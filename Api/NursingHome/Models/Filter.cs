using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using NursingHome.Domain;
using System.Data.Objects.SqlClient;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using System.IO;
using System.Runtime.Serialization;
using System.Linq.Expressions;

namespace NursingHome.Models
{
    public class Filter
    {
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public double Radius { get; set; }
        public bool IsMedicaid {get;set;}
        public bool IsMedicare { get; set;}
        public bool IsInHospital {get;set;}
        public bool IsInRetirementCommunity {get;set;}
        public bool IsForProfit {get;set;}
        public bool IsNonProfit {get;set;}
        public bool IsGovernment {get;set;}
        public bool ForProfitIndividualOwned {get;set;}
        public bool NonProfitFaithBased {get;set;}
        public bool IncludeChainOwned {get;set;}
        public bool IncludeSpecialFocus {get;set;}
        public bool IncludeCountyOwned {get;set;}

		public Filter() { IncludeChainOwned = IncludeSpecialFocus = IncludeCountyOwned = true; }
		
		public Expression<Func<Summary, bool>> Query
		{ 
			get
			{
				//Flag Surface Formula - http://en.wikipedia.org/wiki/Geographical_distance
				double earthRadius = 3958.761; // statute miles
				double lessThan = Math.Pow(Radius/earthRadius,2);
				return s => (Math.Pow((s.Latitude - Latitude) * Math.PI / 180, 2) + Math.Pow(SqlFunctions.Cos((double?)((s.Latitude + Latitude) / 2 * Math.PI / 180)).Value * (s.Longitude - Longitude) * Math.PI / 180, 2) < lessThan)
					&& (!IsMedicare&&!IsMedicaid || IsMedicare&&s.CategoryType.ToLower().Contains("medicare") || (IsMedicare||IsMedicaid)&&s.CategoryType.ToLower().Contains("both") || IsMedicaid && s.CategoryType.ToLower().Contains("medicaid"))
					&& (!IsInHospital&&!IsInRetirementCommunity || IsInHospital&&s.IsInHospital || IsInRetirementCommunity && s.IsInContinuingCareRetirementCommunity)
					&& (!IsForProfit&&!IsNonProfit&&!IsGovernment&&!ForProfitIndividualOwned&&!NonProfitFaithBased || IsForProfit&&s.OwnershipType.ToLower().Contains("for profit") || IsNonProfit&&s.OwnershipType.ToLower().Contains("non profit") || IsGovernment&&s.OwnershipType.ToLower().Contains("government") || ForProfitIndividualOwned&&s.OwnershipType.ToLower().Contains("individual") || NonProfitFaithBased&&s.OwnershipType.ToLower().Contains("church"))
					&& (IncludeChainOwned || !s.IsMultipleNursingHomeOwnership)
					&& (IncludeSpecialFocus || !s.IsSpecialFocusFacility)
					&& (IncludeCountyOwned || !s.OwnershipType.ToLower().Contains("county"));
			}
		}
    }
}