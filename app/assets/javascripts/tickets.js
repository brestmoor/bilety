function getRows(id) {
    $.ajax({
            url: "/rows.json?event_id=" + id, success: function (result) {
                //build table
            }
        }
    )
}