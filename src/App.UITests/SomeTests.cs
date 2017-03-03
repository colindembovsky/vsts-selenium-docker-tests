using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Remote;
using System.Drawing;
using System.IO;
using System.Diagnostics;

namespace App.UITests
{
	[TestClass]
	public class HomePageTest
	{
		public string BaseUrl { get; set; } = "http://google.com";

		public string HubUrl { get; set; } = "http://localhost:4444/wd/hub";

		public TestContext TestContext { get; set; }

		[TestInitialize]
		public void TestInit()
		{
			if (TestContext.Properties["BaseUrl"] != null)
			{
				BaseUrl = TestContext.Properties["BaseUrl"].ToString();
			}

			if (TestContext.Properties["HubUrl"] != null)
			{
				HubUrl = TestContext.Properties["HubUrl"].ToString();
			}

			Trace.WriteLine($"BaseUrl: {BaseUrl}");
			Trace.WriteLine($"HubUrl: {HubUrl}");
		}

		private void Test(ICapabilities capabilities)
		{
			var driver = new RemoteWebDriver(new Uri(HubUrl), capabilities);
			driver.Navigate().GoToUrl(BaseUrl);
			// other test steps here
		}

		[TestMethod]
		public void HomePage()
		{
			Test(DesiredCapabilities.Chrome());
			Test(DesiredCapabilities.Firefox());
		}
	}
}
