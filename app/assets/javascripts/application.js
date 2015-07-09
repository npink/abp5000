// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap.min
//= require_tree .
	
function validate_task(task_form) {
	var form = $(task_form);
	
	if (form.find("#task_client_name").val().trim().length === 0) {
		event.preventDefault();
	}
}

$(function() {
	/* test */
	//alert(location);
	
	$("#add_task_button").click( function() {
		$('#add_task_form').modal('show');
		
		$('.new_task').submit( function(event) {
			validate_task(this);
		});
		
	});
	
	$(".initials_field").click(function() {
		$(this).val("");
	});
	
	$(".initials_updater").bind('keypress', function(e) {
		if (e.keyCode == 13) {
			var task_object = { 
				task_id: $(this).data("task-id"),
				attribute: $(this).data("attribute"),
				value: $(this).val()
		   };
		
			$.post("initial", task_object , function(url) {
				location.load(url);
			});
		}

	});
	
	
	$(".task_row").click(function(event) {
		if ( !$(event.target).hasClass('initials_field') ) {
			$.get( $(this).data("task-id") + "/edit", function(data) {
			
				$('#edit_task_form').html(data);
				$('#edit_task_form').modal('show');
			
				$('.edit_task').submit( function(e) {
					validate_task(this);
				});
				
				$(".delete_task_button").click(function(event){
					if ( confirm("Are you sure you want to delete this task?") ) {
						$.post("destroy", {task_id: $(this).data("task-id")}, function() {
							location.reload(true);
						});
					}
				});
			
			});
		}
	});
	
});