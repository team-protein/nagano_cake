$(function() {
  $("#down-button").on("click", function() {
    $(".product-search-form").addClass("active");
    $(this).hide();
    $("#up-button").show();
  });

  $(document).on('click',function(e) {
    if(!$(e.target).closest('#down-button, .product-search-form').length) {
      $(".product-search-form").removeClass("active");
      $("#down-button").show();
      $("#up-button").hide();
    }
  });

  var products = $(".products_name").val();
  $('#suggest').autocomplete({
    source: products.split(","),
    delay: 300, // 入力してからサジェストが動くまでの時間(ms)
    minLength: 1 // 2文字入力しないとサジェストが動かない
  });
});