$(document).ready(function() {
  $('#tweeting').submit(function(e){
    e.preventDefault();
    // var url = $('#tweeting').attr('action');
    $.post('/tweet',{tweet:$("input[name='tweet']").val()},function(response){
      addNagger(response)
    })
  })
});

var resCollection = []

function addNagger(res){
  if(resCollection.length == 0){
    resCollection.push(res);
    nag();
  }else{
    resCollection.push(res)
  };
  console.log(resCollection);
};
var  nagInterval;
function nag(){
 var i = 0;
 nagInterval = setInterval(function(){
  console.log("interval set")
  makeRequest(resCollection[i], i)
  i++;
  if(i == resCollection.length){
     i = 0;
  };
 },5000);
};

function makeRequest(obj, i){
  if (obj != undefined){ // prevents ajax for tweets successfully submitted
 $.post('/nag',{jid: obj.jid},function(response){
      console.log(response);
      if(response.status == true){
      // put to view that this tweet has been successfully sent
      $('.container').append("tweet: '" + obj.tweet +"' has been sent")
      resCollection.splice(i,1); // removes at index i one item
      };
      console.log(resCollection)
    })
}
};
