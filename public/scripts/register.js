$(document).ready(function() {
  // Slack OAuth
  var code = $.url('?code')
  var state = $.url('?state')

  if (code) {
    console.log('Working to register...')
    $('#register').hide();
    $.ajax({
      type: "POST",
      url: "/workspaces",
      data: {
        code: code,
        state: state
      },
      success: function(data) {
        console.log('SUCCESS!')
      },
      error: function(xhr, opts, thrownError) {
        var msg = JSON.parse(xhr.responseText)["error"];
        
        console.log('ERROR!')
        console.log(msg);
      }
    });
  }
});
