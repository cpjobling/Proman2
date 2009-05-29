// EasyNavigation requires jQuery
$(document).ready(function(){
		$('li.tab.drop').hover(
			function() { $('ul', this).css('display', 'block'); },
			function() { $('ul', this).css('display', 'none'); });
	});
