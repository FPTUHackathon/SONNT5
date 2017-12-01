function loadMessage(id){
  var item = document.getElementById(id);
  var chatbox = item.getElementsByClassName('chatbox-messages');
  //DEMO get message from array
  var stringHTML = "<ul>";

  var messages = [
    {userID:001,message:'Hello'},
    {userID:001,message:'Are you there'},
    {userID:002,message:'Hello'},
    {userID:002,message:'I am here'},
    {userID:001,message:'How are you today?'},
    {userID:002,message:'I am fine, Thankyou'}
  ];

  for (var i = 0; i < messages.length; i++) {
    stringHTML+='<li>'
    if (messages[i].userID==001) {
      stringHTML+='<span class="left">'+messages[i].message+'</span><div class="clear"></div></li>';
    } else {
      stringHTML+='<span class="right">'+messages[i].message+'</span><div class="clear"></div></li>';
    }
  }
  chatbox[0].innerHTML = stringHTML;
}

function addMessage(message, type, roomId) {
    $("#1 .chatbox-messages ul").append($('<li><span class="left">' + message + '</span><div class="clear"></div></li>'));
}


//this function can remove a array element.
Array.remove = function(array, from, to) {
  var rest = array.slice((to || from) + 1 || array.length);
  array.length = from < 0 ? array.length + from : from;
  return array.push.apply(array, rest);
};

//this variable represents the total number of popups can be displayed according to the viewport width
var total_popups = 0;

//arrays of popups ids
var popups = [];

//this is used to close a popup
function close_popup(id)
{
  for(var iii = 0; iii < popups.length; iii++)
  {
    if(id == popups[iii])
    {
      Array.remove(popups, iii);

      document.getElementById(id).style.display = "none";

      calculate_popups();

      return;
    }
  }
}

//displays the popups. Displays based on the maximum number of popups that can be displayed on the current viewport width
function display_popups()
{
  var right = 220;
  var iii = 0;
  for(iii; iii < total_popups; iii++)
  {
    if(popups[iii] != undefined)
    {
      var element = document.getElementById(popups[iii]);
      element.style.right = right + "px";
      right = right + 320;
      element.style.display = "block";
    }
  }

  for(var jjj = iii; jjj < popups.length; jjj++)
  {
    var element = document.getElementById(popups[jjj]);
    element.style.display = "none";
  }
}

//creates markup for a new popup. Adds the id to popups array.
function register_popup(id, name) {

  for(var iii = 0; iii < popups.length; iii++)
  {
    //already registered. Bring it to front.
    if(id == popups[iii])
    {
      Array.remove(popups, iii);

      popups.unshift(id);

      calculate_popups();
      return;
    }
  }

  var element = '<div class="popup-box chat-popup" id="'+ id +'">';
  element = element + '<div class="popup-head">';
  element = element + '<div class="popup-head-left">'+ name +'</div>';
  element = element + '<div class="popup-head-right"><a href="javascript:close_popup(\''+ id +'\');">&#10005;</a></div>';
  element = element + '<div style="clear: both"></div></div>';
  element = element + '<div class="chatbox-messages"></div><div class="input-box"><textarea placeholder="Enter message" onkeypress="chatKeyPress(event, \'' + id + '\')"></textarea></div></div>';
  $("body").append($(element));

  popups.unshift(id);

  calculate_popups();
  loadMessage(id);
}

function chatKeyPress(event, id) {
    if (event.charCode == 13) {
        signalr.sendMessage($(event.target).val(), 0, id);
        $(event.target).val("");
    }
}

//calculate the total number of popups suitable and then populate the toatal_popups variable.
function calculate_popups()
{
  var width = window.innerWidth;
  if(width < 540)
  {
    total_popups = 0;
  }
  else
  {
    width = width - 200;
    //320 is width of a single popup box
    total_popups = parseInt(width/320);
  }

  display_popups();

}

//recalculate when window is loaded and also when window is resized.
window.addEventListener("resize", calculate_popups);
window.addEventListener("load", calculate_popups);
