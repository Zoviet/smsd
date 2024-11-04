$( document ).ready(function() {
	$('.datetimes').daterangepicker({
	    timePicker: true,
	    timePicker24Hour: true,
	    singleDatePicker: true,
	    startDate: moment(),
	    locale: {
	      format: 'YYYY-MM-DD HH:mm:ss',	     
	    }
	});
	$('input[name="SendingTimeOut"]').daterangepicker({
	    timePicker: true,
	    timePicker24Hour: true,
	    singleDatePicker: true,
	    startDate: moment().add(5, 'minutes'),
	    locale: {
	      format: 'YYYY-MM-DD HH:mm:ss',	     
	    }
	});
});
