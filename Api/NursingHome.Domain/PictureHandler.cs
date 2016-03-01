using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Windows.Media.Imaging;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Configuration;


namespace NursingHome.Domain
{
	class Parts
	{
		public string Guid, Extension;
		public int? Width;
		public static Parts From(string pathOrName)
		{
			Parts p = new Parts();
			var split = Path.GetFileName(pathOrName).Split('.');
			p.Guid = split[0].ToLower();
			p.Width = null;
			int w;
			if (int.TryParse(split[1], out w))
				p.Width = w;
			else p.Width = null;
			p.Extension = split.Last();
			return p;
		}
		public static Parts From(FileInfo file)
		{
			return From(file.FullName);
		}
		public string Combined { get { return Guid.ToLower() + "." + (Width.HasValue ? Width.Value.ToString() + "." : "") + Extension.ToLower(); } }
	}

    public interface IPictureLoadable
    {
        string ParentDirectoryName { get; }
        string FileName { get; set; }
        byte[] Content { get; set; }
        string ContentUrl { get; set; }
    }
    public enum LoadOptions { OnlyURL, All }
	public enum PictureFormFactor { iPhone = 960, iPad = 960, Thumbnail = 200 }
	public static class PictureHandler
	{
		public static string PICTURE_PATH { get { return ConfigurationManager.AppSettings["PicturePath"]; } }
		public static string PICTURE_URL { get { return ConfigurationManager.AppSettings["PictureUrl"]; } }
		// % Range around targetPixelWidth that a picture is considered satisfactory size.  
		public static double TARGET_WINDOW_SIZE { get { return double.Parse(ConfigurationManager.AppSettings["TargetWindowSize"]); } } 


		/// <summary>
		/// Adds new picture in homeid folder named with random guid in name:  guid.width.extension
		/// </summary>
		/// <param name="content"></param>
		/// <param name="homeID"></param>
		/// <returns>Filename (guid.ext without width in name)</returns>
		public static string Create(byte[] content, string homeID)
		{
			string g = Guid.NewGuid().ToString();
			string updatedName;
			Save(content, g + "." + Extension(content), homeID, out updatedName);
			return updatedName;
		}

        public static void DeletePictures(this Picture picture)
        {
            DirectoryInfo dir = PictureDirectory(picture.HomeID);
			if (!dir.Exists) return;
            Parts p = Parts.From(picture.FileName);
            foreach (FileInfo f in dir.GetFiles().Where(file => file.Name.StartsWith(p.Guid,StringComparison.OrdinalIgnoreCase)))
            {
                f.Delete();
            }
            if (dir.GetFiles().Count() == 0)
                dir.Delete();
        }

		/// <summary>
		/// Updates or creates a picture in the correct nursinghomeID directory firstly removing other pictures with same guid in name.  Only does so if the picture actually has changed based on the byte size.
		/// </summary>
		/// <param name="content">Must be the bytes representation of the image in the picture format specified by the filename extension. (png, jpg)</param>
		/// <param name="fileName">GUID.extension as stored in database</param>
		public static bool Save(byte[] content, string fileName, string homeID, out string updatedName)
		{
			DirectoryInfo dir = PictureDirectory(homeID);
			if (!dir.Exists) dir.Create();
			fileName = fileName.ToLower();
			Parts p = Parts.From(fileName);
			bool updated = false;
			if (NeedsUpdated(content, fileName, homeID))
			{
				dir.GetFiles().Where(e => e.Name.StartsWith(p.Guid, StringComparison.OrdinalIgnoreCase)).ToList().ForEach(e => e.Delete());
				string path = Path.Combine(dir.FullName, fileName);
				path = AddWidthToFile(path, data: content);
				MemoryStream original = new MemoryStream(content);
				using (FileStream f = new FileStream(path, FileMode.Create))
				{
					original.WriteTo(f);
				}
                string savePath;
				ResizeAndSave(path, (int)PictureFormFactor.Thumbnail, out savePath);
				updated = true;
			}

			updatedName = p.Guid + "." + p.Extension;
			return updated;
		}

		private static DirectoryInfo PictureDirectory(string nursingHomeID)
		{
			DirectoryInfo d = new DirectoryInfo(Path.Combine(PICTURE_PATH, nursingHomeID.ToUpper()));
			//if (!d.Exists)
			//	d.Create();
			return d;
		}

		private static bool NeedsUpdated(byte[] content, string filename, string homeID)
		{
			string path = FindOriginalPicturePath(filename, homeID);
			if (path == null)
				return true;
			// compare size as naive check for now
			return (new FileInfo(path)).Length != content.Length;
		}

        private static string ToURL(string fileNameOrPath, string parentDirectory)
        {
            return Path.Combine(PICTURE_URL, parentDirectory, Path.GetFileName(fileNameOrPath)).Replace('\\','/'); // VERY IMPORTANT to make sure url is properly formated with '/' separators.
        }

		private static string FindOriginalPicturePath(string fileName, string nursingHomeID)
		{
			nursingHomeID = nursingHomeID.ToUpper();
			DirectoryInfo dir = PictureDirectory(nursingHomeID);
			if (!dir.Exists) return null;
			Parts x = Parts.From(fileName);
			double maxWidth = double.NegativeInfinity;
			string largest = null;
			foreach (FileInfo f in dir.GetFiles())
			{
				if (!f.Name.StartsWith(x.Guid, StringComparison.OrdinalIgnoreCase)) continue;
				Parts p = Parts.From(f);
				string s = f.FullName;
				if (p.Width == null)
				{
					s = AddWidthToFile(f.FullName);
					p = Parts.From(s); // file name doesn't contain width, so fix!
				}
				if (p.Width > maxWidth)
				{
					maxWidth = p.Width.Value;
					largest = s;
				}
			};
			if (largest == null)
				return null;
			else return largest;
		}

		public static void LoadPicture(this IPictureLoadable p, PictureFormFactor form, LoadOptions options = LoadOptions.All)
		{
			var pp = new IPictureLoadable[] { p };
			pp.LoadPictures(form);
		}

		/// <summary>
		/// Load all pictures in O(n) instead of O(n^2)
		/// </summary>
		/// <param name="containers">Picture objects</param>
		/// <param name="setBytes">Method that saves the loaded picture bytes to.</param>
		public static void LoadPictures(this IEnumerable<IPictureLoadable> pictures, PictureFormFactor form, LoadOptions options = LoadOptions.All)
		{
			if (pictures.Count() == 0) return;
            int targetPixelWidth = (int)form;
			foreach (var group in pictures.Where(e => e.FileName != null).GroupBy(a => a.ParentDirectoryName))
			{
				IPictureLoadable[] pics = group.OrderBy(e => e.FileName).ToArray();
				DirectoryInfo dir = PictureDirectory(pics.First().ParentDirectoryName);
				if (!dir.Exists) continue;
				FileInfo[] files = dir.GetFiles().OrderBy(e => e.FullName).ToArray();
				// Fingers
				IEnumerator<FileInfo> file = files.AsEnumerable().GetEnumerator();
				IEnumerator<IPictureLoadable> pic = pics.AsEnumerable().GetEnumerator();
				List<FileInfo> targetFiles = new List<FileInfo>();
				bool done = !file.MoveNext() || !pic.MoveNext(); // move onto first element
				while (!done)
				{
					string picName = pic.Current.FileName.Split('.')[0].ToLower();
					string fileName = file.Current.Name.Split('.')[0].ToLower();
					if (picName == fileName)
					{
						targetFiles.Add(file.Current);
						done = !file.MoveNext();
						if (done)
						{
							Load(pic.Current, targetPixelWidth, TARGET_WINDOW_SIZE, targetFiles, options); 	// We found the group we were looking for, so load the bytes!
							targetFiles.Clear();
						}
					}
					else
					{
						if (targetFiles.Count > 0)
						{
							Load(pic.Current, targetPixelWidth, TARGET_WINDOW_SIZE, targetFiles, options); 	// We found the group we were looking for, so load the bytes!
							targetFiles.Clear();
						}
						if (String.Compare(picName, fileName) < 0)
							done = !pic.MoveNext();
						else if (String.Compare(picName, fileName) > 0)
							done = !file.MoveNext();
						else throw new Exception("Strings are equal but that is impossible since that was already checked above? Something is weird..");
					}
				}
			}
		}

		public static string Extension(this byte[] bytes)
		{
			return MimeToExtension(FindMime(bytes));
		}

		public static string FindMime(this byte[] bytes)
		{
			if (bytes.Count() == 0) return "";
			switch (bytes[0])
			{
				case 0xFF:
					return @"image/jpeg";
				case 0x89:
					return @"image/png";
				case 0x47:
					return @"image/gif";
				case 0x49:
				case 0x4D:
					return @"image/tiff";
			}
			throw new InvalidCastException("Failed to find extension");
		}

		public static string MimeToExtension(string mimeType)
		{
			mimeType = mimeType.ToLower();
			if (mimeType == "image/jpeg") return "jpg";
			else if (mimeType == "image/png")
				return "png";
			else if (mimeType == "image/gif")
				return "gif";
			else if (mimeType == "image/tiff")
				return "tif";
			else throw new Exception("Unsupported image type: " + mimeType);
		}


		public static void Load(IPictureLoadable picture, int targetPixelWidth, double targetWindowSize = -1, List<FileInfo> targetFiles = null, LoadOptions options = LoadOptions.All)
		{
			if (targetWindowSize == -1) targetWindowSize = TARGET_WINDOW_SIZE;
			Parts x = Parts.From(picture.FileName);
			DirectoryInfo dir = PictureDirectory(picture.ParentDirectoryName);
			if (!dir.Exists)
			{
				//dir.Create();
				picture.Content = null;
                picture.ContentUrl = null;
                return;
			}
			FileInfo desiredTarget = new FileInfo(Path.Combine(dir.FullName, x.Guid + "." + targetPixelWidth + "." + x.Extension));
			double actual = targetWindowSize / 2.0 * targetPixelWidth;
			double targetMin = targetPixelWidth - actual;
			double targetMax = targetPixelWidth + actual;
			double maxWidth = double.NegativeInfinity;
			string largestPath = null;
			targetFiles = targetFiles ?? dir.GetFiles().ToList();
			string targetPath = null;
			foreach (FileInfo f in targetFiles)
			{
				if (!f.Name.StartsWith(x.Guid, StringComparison.OrdinalIgnoreCase)) continue;
				Parts p = Parts.From(f);
				string sPath = f.FullName;
				if (p.Width == null)
				{
					sPath = AddWidthToFile(f.FullName);
					p = Parts.From(sPath); // file name doesn't contain width, so fix!
				}
				if (p.Width > maxWidth)
				{
					maxWidth = p.Width.Value;
					largestPath = sPath;
				}
				if (p.Width >= targetMin && p.Width <= targetMax)
				{
					targetPath = sPath;
					break;
				}
			};
            if (largestPath == null)
                picture.Content = null;
            else if (targetPath != null)
            {
                picture.ContentUrl = ToURL(targetPath, picture.ParentDirectoryName);
                if (options == LoadOptions.All)
                    picture.Content = File.ReadAllBytes(targetPath);
            }
            else if (maxWidth <= targetPixelWidth)
            {
                picture.ContentUrl = ToURL(largestPath, picture.ParentDirectoryName);
                if (options == LoadOptions.All)
                    picture.Content = File.ReadAllBytes(largestPath); // Never resize greater than the largest image because this is the original image and best quality.  
            }
            else
            {
                string path;
                picture.Content = ResizeAndSave(largestPath, targetPixelWidth, out path);
                picture.ContentUrl = ToURL(path, picture.ParentDirectoryName);
            }
		}

		private static string AddWidthToFile(string file, int width = 0, byte[] data = null)
		{
			Parts p = Parts.From(file);

			bool exists = File.Exists(file);

			if (width != 0) 
				p.Width = width;
			else if (data != null)
			{
				Image im = Image.FromStream(new MemoryStream(data));
				p.Width = im.Width;
			}
			else if (exists)
			{
				using (Image im = Image.FromFile(file)) // must dispose all image references from lock on file!
					p.Width = im.Width;
			}


			string path = Path.Combine(Path.GetDirectoryName(file), p.Combined);
			
			if (width == 0 && data == null && exists && !file.Equals(path, StringComparison.OrdinalIgnoreCase))
				File.Move(file, path);
			return path;
		}

		/// <summary>
		/// Resize source image, saves to file system, and returns jpg or png byte stream (not bitmap!!).  
		/// </summary>
		private static byte[] ResizeAndSave(string source, double targetWidth, out string savedPath)
		{
			if (!File.Exists(source)) throw new ArgumentException("File doesn't exists: " + source);

			/*BitmapImage resizedImage = new BitmapImage
			{
				// StreamSource = new ByteStream(bytes)
				  StreamSource = source.OpenRead(),
				  CreateOptions = BitmapCreateOptions.IgnoreColorProfile,
				  DecodePixelHeight = target.Height,
				  DecodePixelWidth = target.Width
			};
			resizedImage.BeginInit();  // Needed only so we can call EndInit()
			resizedImage.EndInit();    // This does the actual loading and resizing
			return resizedImage;*/
			MemoryStream original = new MemoryStream(System.IO.File.ReadAllBytes(source));
			Image image = Image.FromStream(original);
			Size s = image.Size;
			original.Close(); // be careful to release all streams!!!
			double resize = (double)targetWidth / s.Width;
			if (resize >= 1) throw new ArgumentException("Cannot resize bigger than original picture.");
			if (1 - resize <= TARGET_WINDOW_SIZE / 2.0) 
            {
                savedPath = source;
                return File.ReadAllBytes(source); // within target window size, so return original source image. 
            }
			Size target = new Size((int)Math.Round(resize * s.Width), (int)Math.Round(resize * s.Height));
			Image thumbnail = new Bitmap(target.Width, target.Height);
			Graphics graphics = Graphics.FromImage(thumbnail);

			graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
			graphics.SmoothingMode = SmoothingMode.HighQuality;
			graphics.PixelOffsetMode = PixelOffsetMode.HighQuality;
			graphics.CompositingQuality = CompositingQuality.HighQuality;

			graphics.DrawImage(image, 0, 0, target.Width, target.Height);

			EncoderParameters encoderParameters;
			encoderParameters = new EncoderParameters(1);
			encoderParameters.Param[0] = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, 100L);

			MemoryStream result = new MemoryStream();
			ImageCodecInfo[] info = ImageCodecInfo.GetImageEncoders();
			thumbnail.Save(result, info[1], encoderParameters);

			result.Position = 0;

			string path = AddWidthToFile(source, target.Width);
			using (FileStream f = new FileStream(path, FileMode.Create))
			{
				result.WriteTo(f);
			}
			byte[] array = result.ToArray();
			result.Close();
			savedPath = path;
            return array;
		}

	}
}
