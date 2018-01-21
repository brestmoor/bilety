function getRows(id) {
    $.ajax({
            url: "/rows.json?event_id=" + id, success: function (result) {
                //build table
            }
        }
    )
}

function insertPriceLowAndHigh(param) {
    var priceLow = document.querySelector("select option[value='" + param.value + "']").attributes['data-price-low'].value;
    var priceHigh = document.querySelector("select option[value='" + param.value + "']").attributes['data-price-high'].value;

    document.querySelector("label[for='ticket_price']").innerHTML =
        document.querySelector("label[for='ticket_price']").innerHTML.split(' ')[0] + ' (min. price: ' + priceLow + ' max. price: ' + priceHigh + ')'
}