function undo()
{
    document.execCommand("undo", false, null);
}

function redo()
{
    document.execCommand("redo", false, null);
}

function bold()
{
    document.execCommand("bold", false, null);
}

function italic()
{
    document.execCommand("italic", false, null);
}

function underline()
{
    document.execCommand("underline", false, null);
}

function indent()
{
    document.execCommand("indent", false, null);
}

function outdent()
{
    document.execCommand("outdent", false, null);
}

function insertUnorderedList()
{
    document.execCommand("insertUnorderedList", false, null);
}

function insertOrderedList()
{
    document.execCommand("insertOrderedList", false, null);
}

function h1()
{
    document.execCommand("formatBlock", false, "h1");
}
function h2()
{
    document.execCommand("formatBlock", false, "h2");
}
function h3()
{
    document.execCommand("formatBlock", false, "h3");
}
function h4()
{
    document.execCommand("formatBlock", false, "h4");
}
function h5()
{
    document.execCommand("formatBlock", false, "h5");
}
function h6()
{
    document.execCommand("formatBlock", false, "h6");
}
function p()
{
    document.execCommand("formatBlock", false, "p");
}

function createlink()
{
    var url = prompt("Enter the URL");
    document.execCommand("createLink", false, url);
}
function unlink()
{
    document.execCommand("unlink", false, null);
}

function insertimage()
{
    var url = prompt("Enter the URL of the image");
    document.execCommand("insertimage", false, url);
}

function blockquote()
{
    document.execCommand("formatBlock", false, "blockquote");
}

function pre()
{
    document.execCommand("formatBlock", false, "pre");
}

