using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using System.IO;
using System.Runtime.Serialization;

namespace NursingHome.Domain
{

	[MetadataType(typeof(Comment.Metadata))]
	public partial class Comment
	{
		class Metadata { }
		[DataMember]
		public bool? MyVote { get; set; }
	}

	[MetadataType(typeof(Picture.Metadata))]
	public partial class Picture : IPictureLoadable
	{
		class Metadata { }

		public string ParentDirectoryName { get { return HomeID; } }
		[DataMember]
		public byte[] Content { get; set; }
		[DataMember]
		public string ContentUrl { get; set; }
		[DataMember]
		public bool? MyVote { get; set; }
	}


	[MetadataType(typeof(Summary.Metadata))]
	public partial class Summary : IPictureLoadable
	{
		class Metadata
		{
			[IgnoreDataMember]
			private bool CategoryType { get; set; }
			[IgnoreDataMember]
			private bool OwnershipType { get; set; }
			[IgnoreDataMember]
			private bool IsInHospital { get; set; }
			[IgnoreDataMember]
			private bool IsMultipleNursingHomeOwnership { get; set; }
			[IgnoreDataMember]
			private bool IsInContinuingCareRetirementCommunity { get; set; }
			[IgnoreDataMember]
			private bool IsSpecialFocusFacility { get; set; }
		}

		public string ParentDirectoryName { get { return HomeID; } }
		public string FileName { get { return PictureName; } set { PictureName = value; } }
		[DataMember]
		public byte[] Content { get; set; }
		[DataMember]
		public string ContentUrl { get; set; }
	}
}
