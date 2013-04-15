<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RssPage.aspx.cs" Inherits="RssPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>RssPage</title>
</head>
<body>
    <form id="form1" runat="server">
        <div id="error"></div>
        <div id="content"></div>

        <div style="width: 1200px;">
         <div style="float: left; width: 400px;" id="rsslist1">
            <img src="img/ajax-loader.gif" id="ajaxloader1" />
         </div>
         <div style="float: left; width: 400px;"  id="rsslist2">
         <img src="img/ajax-loader.gif" id="ajaxloader2" />
         </div>
         <div style="float: left; width: 400px;" id="rsslist3">
         <img src="img/ajax-loader.gif" id="ajaxloader3" />
         </div>
         <br style="clear: left;" />
        </div>
    </form>

    <script type="text/javascript" src="scripts/jquery-1.9.1.min.js"></script>
        <script type="text/javascript">

            $(document).ready(function () {
                getUrls();
            });

            //Call the C#-method asynchronously, to get list of rss feeds
            function getUrls() {
                $.ajax({
                    url: 'RssPage.aspx/GetRssItems',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: 'json',
                    success: function (response) {
                        downloadRssFromUrls(response.d);
                    },
                    error: function (e) {
                        displayError(e, -1);
                    }
                });
            }
            //For each rss-url, download the Rss data async
            function downloadRssFromUrls(rssurl) {
                var arr = $.parseJSON(rssurl);

                $.each(arr, function (i) {
                    downloadOneRssAsync(this.Title, this.Url, i);
                });
            }

            //Call the C#-method asynchronously, to download one rss feed.
            function downloadOneRssAsync(title, rssurl, i) {

                jQuery.ajax({
                    url: 'RssPage.aspx/DownloadRssFeed',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    data: "{'inputUrl':'" + rssurl + "' }",
                    dataType: "json",
                    success: function (data) {
                        displayRssFeed(title, data.d, i);
                    },
                    error: function (result) {
                        displayError(result, i);
                    },
                    async: true
                });
            }

            function displayRssFeed(title, json, i) {
                $('#ajaxloader' + (i + 1)).hide();
                var arr = $.parseJSON(json);

                $('#content').append('<div class="rsslist' + i + '"></div>');

                var idvar = "#rsslist" + (i+1);
                $(idvar).append("<h2>" + title + "</h2>");

                $.each(arr, function () {
                    $(idvar).append('<ul>' +
                    '<a href ="' + this.Url + '">' +
                    '<li>' + this.Title + '</li>' +
                    '</a>' +
                    '</ul>');
                });
            }

            function displayError(result, i) {
                var arr = $.parseJSON(result.responseText);

                $('#error').append('<div class="rssError' + i + '"></div>');
                var idvar = ".rssError" + i;

                $(idvar).append("Feilmelding: " + arr["Message"]).hide().fadeIn(500, "easeInOutBounce");

                $.each(arr, function (key, value) {
                    $(idvar).append('<p style="display:none">' + key + ' : ' + value + '</p>');
                });
            }
    </script>
</body>
</html>
