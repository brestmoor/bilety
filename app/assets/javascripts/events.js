
var seats = [];

function yo(obj) {
    if (obj.classList.contains('active')) {
        obj.classList.remove('active');
        obj.classList.remove('btn-success');
        obj.classList.add('btn-primary');
        seats.splice(seats.indexOf(obj.value), 1)
    } else {
        obj.classList.add('active');
        obj.classList.remove('btn-primary');
        obj.classList.add('btn-success');
        seats.push(obj.value)
    }

    console.log(seats);
}



function setSeatsAsFormParam() {
    var obj = document.getElementById('seat_id_seq');
    obj.value = seats.join(', ');
    console.log(obj)
}