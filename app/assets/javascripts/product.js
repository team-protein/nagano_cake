$(function() {
  $(document).on('turbolinks:load', function() {
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



    $("#formreset").on("click", function(){
      $(".words").val("");
      $(".genre_id").val("");
      $(".price").val("");
      $(".min_price").val("");
      $(".max_price").val("");
      $(".is_active").val("");
    });

    $(".price").change(function(){
      var int = $(this).val();
      if (int == 1) {
        $(".min_price").val("0");
        $(".max_price").val("1000");
      }
      if (int == 2) {
        $(".min_price").val("1000");
        $(".max_price").val("3000");
      }
      if (int == 3) {
        $(".min_price").val("3000");
        $(".max_price").val("5000");
      }
      if (int == 4) {
        $(".min_price").val("5000");
        $(".max_price").val("10000");
      }
    });
  });
});