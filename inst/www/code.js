$( document ).on( "DOMNodeInserted", function() {
	if ($( "#currenteditablecontent" ).children().last().children()[0].tagName == "PRE") {
	  addp();
	}
});

function blockpre(){
  var x = document.getElementsByTagName("pre");
  for (i = 0; i < x.length; i++) {
    var element = x[i];
    var parent = element.parentNode;
    var wrapper = document.createElement("div");
    wrapper.setAttribute("contentEditable","false");
    parent.replaceChild(wrapper, element);
    wrapper.appendChild(element);
  }
}

function addp(){
  $('#currenteditablecontent').append('<br>');
}

var where = $('#wholetoolbar').offset()["top"]

function myFunction() {
  if (window.pageYOffset > where) {
    $('#wholetoolbar').attr("id", "wholetoolbarscrolled");
  } else {
    $('#wholetoolbarscrolled').attr("id", "wholetoolbar");
  }
}

window.onscroll = function() {myFunction()};


articles = document.getElementsByTagName('button');
for (var i = 0; i < articles.length; i++) {
    articles[i].addEventListener('click',addStuffs,false);

}


function addStuffs(){

  var parent = window.getSelection().anchorNode.parentElement;
  var parentparent = window.getSelection().anchorNode.parentNode.parentNode.id
  var command = this.dataset.command;
  if (parent.tagName == "CODE" | parent.tagName == "PRE"){
    if (command == 'p') {
      document.execCommand('formatBlock', false, command);
      }
    if (command == 'div') {
      document.execCommand('formatBlock', false, command);
      }
    if (parentparent != "currenteditablecontentrmd") {
      console.log("You can't format a code block content");
    }
  } else {
    var command = this.dataset.command;
    if (
      command == 'div'||
      command == 'h1'||
      command == 'h2'||
      command == 'h3'||
      command == 'h4'||
      command == 'h5'||
      command == 'h6'||
      command == 'p'||
      command == 'blockquote') {
      document.execCommand('formatBlock', false, command);
      }
      else if (
          command == 'createlink' ||
          command == 'insertimage') {
              url = prompt('Enter the link here: ', 'http:\/\/');
              document.execCommand(command, false, url);
                 } else {
                  document.execCommand(command, false, null);
                 }
  if (command == 'pre'){
    var a = document.getSelection().toString();
    var lgg = prompt('Enter the language here: (default is R)', 'r');
    if ( a== ""){
      var a = "Insert code";
    }
    document.execCommand('insertHTML',
    false, '<pre><code class="'+ lgg +'">'+ a +'</code></pre>');
    blockpre();
  }
  }
}
