$(document).on('turbolinks:load', function(){
  $('.vote').on('ajax:success', function(e) {
    var score = e.detail[0]['score'];
    var itemName = e.detail[0]['item_name'];
    var itemId = e.detail[0]['item_id'];
    document.getElementById('score_vote_' + itemName + '_id_' + itemId).textContent = 'Rating ' + score;
    })
  }
)
