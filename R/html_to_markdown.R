html_to_markdown <- function(res){
  # plop <- res
  # res <- plop
  #browser()
  res <- gsub("<script>.*</script>", "", res)
  res <- gsub("</*p>", "", res)
  # parse lists
  res <- gsub("</li>", "", res)
  while (grepl("<ol>\n?<li>[^<li>]*<li>", res)) {
    res <- gsub("(<ol>\n?<li>[^<li>]*)(<li>)", "\\1<ol>\\2", res)
  }
  while (grepl("<ul>\n?<li>[^<li>]*<li>", res)) {
    res <- gsub("(<ul>\n?<li>[^<li>]*)(<li>)", "\\1<ul>\\2", res)
  }
  res <- gsub("</ul>", "", res)
  res <- gsub("</ol>", "", res)
  res <- gsub("<ul>\n?<li>", "+ ", res)
  res <- gsub("<ol>\n?<li>", "1. ", res)
  res <- gsub("\n  ", "", res)
  res <- gsub("&nbsp;", " ", res)
  res <- gsub("</*div[^>]*>", "\n", res)
  res <- gsub("</*span[^>]*>", "", res)
  res <- gsub("<br>", "\n", res)
  res <- gsub("</*strong>", "**", res)
  res <- gsub("</*b>", "**", res)
  res <- gsub("</*em>", "*", res)
  res <- gsub("</*i>", "*", res)
  res <- gsub('<a href="([^"]*)">([^>]*)<\\/a>', "[\\2](\\1)", res)
  res <- gsub("<h1>", "# ", res)
  res <- gsub("</h1>", "\n\n", res)
  res <- gsub("<h2>", "## ", res)
  res <- gsub("</h2>", "\n\n", res)
  res <- gsub("<h3>", "### ", res)
  res <- gsub("</h3>", "\n\n", res)
  res <- gsub("<h4>", "#### ", res)
  res <- gsub("</h4>", "\n\n", res)
  res <- gsub("<h5>", "##### ", res)
  res <- gsub("</h5>", "\n\n", res)
  res <- gsub("<h6>", "###### ", res)
  res <- gsub("</h6>", "\n\n", res)
  res <- gsub('(<pre[^>]*>)(<span[^>]*>)(.[^<]*)(<\\/span>)(<\\/pre>)', "\\2\\1\\3\\5\\4", res)
  res <- gsub('<pre><code class="">', "\n\n```{\\1}\n", res)
  res <- gsub('<pre><code class="([^"]*)">', "\n```{\\1}\n", res)
  res <- gsub('<pre>', "\n```{r}\n", res)
  res <- gsub("</code></pre>", "\n```\n", res)
  res <- gsub("</*code>", "`", res)
  res <- gsub("\n{2,}", "\n\n", res)
  res
}
