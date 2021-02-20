$ ->
  $("#postcode-form").jpostal({
    postcode : [ "#postcode-form" ],
    address  : {
                  "#address-form" : "%3%4%5",
                }
  });