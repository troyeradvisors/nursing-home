using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
using System.Xml.Linq;
using System.Data.Objects;
using System.Data.Objects.DataClasses;
using System.Threading;

namespace LocationFinder
{
	public enum GeocodeType { Google, Bing };
	class Program
	{
		public static string XMLNS = "{http://schemas.microsoft.com/search/local/ws/rest/v1}";
		public static string BING_KEY = "AoVaskJnEJsPIrC2ArWVkknMFl4hJgPJ85JfTp-4J6YKeSDxhsBy8RtRZDoOlLPk";
        public static int LIMIT = 2500;

		static void Main(string[] args)
		{
			NursingHomeEntities entities = new NursingHomeEntities();

			//List<NursingHome> process = entities.NursingHomes.ToList();
			List<Home> process = entities.Homes.Where(l => l.Latitude == null || l.Longitude == null).ToList();
			int i = 0, googleCounter = 0;
			foreach (Home n in process)
			{
				try { PopulateLocation(n, GeocodeType.Bing); }
				catch 
				{
					try
					{
						if (googleCounter < LIMIT)
						{
							PopulateLocation(n, GeocodeType.Google);
							++googleCounter;
						}
					}
					catch { }
				}

				if (n.Latitude != null && n.Longitude != null)
				{
					entities.SaveChanges();
					Console.WriteLine(++i + "/" + process.Count + ": " + n.ID + " " + n.Name + " " + n.Longitude + " " + n.Latitude);
				}
			}
			
			Console.WriteLine("All done!");
			Console.ReadKey();
		}

		public static void PopulateLocation(Home n, GeocodeType type)
		{
				string fixedstreet = FixStreet(n.Street);
				if (type == GeocodeType.Google)
				{

					HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(string.Format("https://maps.googleapis.com/maps/api/geocode/xml?address={0}&sensor=true", string.Join(" ", n.StateCode, n.ZipCode, n.City, fixedstreet)));
					XDocument doc;
					using (StreamReader reader = new StreamReader(request.GetResponse().GetResponseStream(), Encoding.UTF8))
					{
						doc = XDocument.Parse(reader.ReadToEnd());
					}
					n.Longitude = Double.Parse(doc.Root.Descendants("lng").First().Value);
					n.Latitude = Double.Parse(doc.Root.Descendants("lat").First().Value);
					Thread.Sleep(1200);
				}

				else if (type == GeocodeType.Bing)
				{
					HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(string.Format("http://dev.virtualearth.net/REST/v1/Locations/US/{0}/{1}/{2}/{3}?o=xml&key={4}", n.StateCode, n.ZipCode, n.City, fixedstreet, BING_KEY));
					XDocument doc;
					using (StreamReader reader = new StreamReader(request.GetResponse().GetResponseStream(), Encoding.UTF8))
					{
						doc = XDocument.Parse(reader.ReadToEnd());
					}
					n.Longitude = Double.Parse(doc.Root.Descendants(XMLNS + "Longitude").First().Value);
					n.Latitude = Double.Parse(doc.Root.Descendants(XMLNS + "Latitude").First().Value);
				}
		}

		public static string FixStreet(string street)
		{
			string s = street.ToLower();
			if (s.ToLower().Contains("po ") || s.ToLower().Contains("p o "))
			{
				s = s.Replace("caller", "box").Replace("firm caller", "box").Replace("bin", "box").Replace("lockbox", "box").Replace("drawer", "box");
			}
			return s.Replace("&", "").Replace("#", "");
		}
	}
}
