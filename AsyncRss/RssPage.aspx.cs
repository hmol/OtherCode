using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
using System.Configuration;
using System.IO;
using System.Net;
using System.Web.Script.Serialization;
using System.Xml.Linq;

public partial class RssPage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string DownloadRssFeed(string inputUrl)
    {
        if (string.IsNullOrWhiteSpace(inputUrl))
            return string.Empty;

        var rssUrl = inputUrl;
        if (string.IsNullOrWhiteSpace(rssUrl))
            return string.Empty;

        try
        {
            var webRequest = (HttpWebRequest)WebRequest.Create(rssUrl);

            using (var webResponse = (HttpWebResponse)webRequest.GetResponse())
            {
                using (var streamReader = new StreamReader(webResponse.GetResponseStream()))
                {
                    var feed = XDocument.Load(new StringReader(streamReader.ReadToEnd()));

                    var rssDeclaration = feed.Descendants("rss");

                    var rssFeedResult = new List<RssFeedItem>();

                    foreach (var item in feed.Descendants("item"))
                    {
                        if (item == null) continue;
                        var title = item.Element("title");
                        if (title == null || string.IsNullOrWhiteSpace(title.Value)) continue;
                        var url = item.Element("link");
                        if (url == null || string.IsNullOrWhiteSpace(url.Value)) continue;

                        rssFeedResult.Add(new RssFeedItem()
                        {
                            Title = title.Value,
                            Url = url.Value
                        });
                    }

                    return new JavaScriptSerializer().Serialize(rssFeedResult);
                }
            }
        }
        catch (Exception e)
        {
            throw new Exception(e.Message);
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetRssItems()
    {
        var feedList = new List<RssFeedItem>();


        feedList.Add(new RssFeedItem(){ 
                        Title="Le Monde" ,
                        Url = "http://rss.lemonde.fr/c/205/f/3061/index.rss"
        });
        feedList.Add(new RssFeedItem()
        {
            Title = "New York Times",
            Url = "http://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"
        });
            
        feedList.Add(new RssFeedItem()
        {
            Title = "Shanghai daily",
            Url = "http://rss.shanghaidaily.com/Portal/mainSite/handler.ashx?template=template&filename=latestnews&foldername=mainSite&sid=id"
        });


        return new JavaScriptSerializer().Serialize(feedList);
    }

    private class RssFeedItem
    {
        public string Url { get; set; }
        public string Title { get; set; }
    }
}