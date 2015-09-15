<!DOCTYPE html>
<meta charset="utf-8" />
<html>
<head>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"> </script>
<script language="javascript" type="text/javascript">
  $(function() {
      var conn = null;
      function log(msg) {
          var control = $('#log');
          control.html(control.html() + msg + '<br/>');
          control.scrollTop(control.scrollTop() + 1000);
      }


      function connect() {
          disconnect();
          var uri = (window.location.protocol=='https:'&&'wss://'||'ws://')+window.location.host +':6677/wsh';
          console.log(['uri', uri]);
          conn = new WebSocket(uri);

          log('Connecting...');
          conn.onopen = function() {
              log('Connected.');
              update_ui();
          };
          conn.onmessage = function(e) {
              log('Received: ' + e.data);
          };
          conn.onclose = function() {
              log('Disconnected.');
              conn = null;
              update_ui();
          };
      }
      function disconnect() {
        if (conn != null) {
          log('Disconnecting...');
          conn.close();
          conn = null;
          update_ui();
        }
      }

      function update_ui() {
          var msg = '';
          if (conn == null) {
              $('#status').text('disconnected');
              $('#connect').html('Connect');
          } else {
              $('#status').text('connected (' + conn.protocol + ')');
              $('#connect').html('Disconnect');
          }
      }

      $('#connect').click(function() {
        if (conn == null) connect();
        else disconnect();
        update_ui();
        return false;
      });
      $('#send').click(function() {
        var text = $('#text').val();
        log('Sending: ' + text);
        conn.send(text);
        $('#text').val('').focus();
        return false;
      });
      $('#text').keyup(function(e) {
        if (e.keyCode === 13) {
          $('#send').click();
          return false;
        }
      });
    });
</script>
</head>

<body>
<h3>Chat!</h3>
<div>    <button id="connect">Connect</button>&nbsp;|&nbsp;Status:    <span id="status">disconnected</span>   </div>
<div id="log" style="width:20em;height:15em;overflow:auto;border:1px solid black"> </div>
<form id="chatform" onsubmit="return false;">
    <input id="text" type="text" />
    <input id="send" type="button" value="Send" />
</form>
</body>
</html>