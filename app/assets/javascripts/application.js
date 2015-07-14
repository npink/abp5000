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

function load_url() {
	location.load(url);
}

$(function() {
	/* test code here */
	
	$("#add_task_button").click( function() {
		$('#add_task_form').modal('show');
		
		$('.new_task').submit( function(event) {
			validate_task(this);
		});
		
	});
	
	$(".initials_field").click(function() {
		$(this).val("");
	});
	
	// Update task when 'enter' key is pressed
	$(".initials_updater").bind('keypress', function(e) {
		if (e.keyCode == 13) {
			var task_object = { 
				task_id: $(this).data("task-id"),
				attribute: $(this).data("attribute"),
				value: $(this).val()
		   };
	
			$.post("initial", task_object);
		}
	});
	
	$(".task_row").click(function(event) {
		if ( !$(event.target).hasClass('initials_field') && !$(event.target).hasClass('headshot') ) {
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
	
	$(".headshot").click(function() {
		$(this).effect({
			effect: "puff", 
			percent: 2000,
			duration: 1500,
			complete: function() {
				location.assign(location.pathname + "?user=" + $(this).attr("alt") );
			}
		});
		//
	});
	
});

/*
	Explosion animation, use for something else cool!
				$("#page").effect({
					effect: "explode", 
					duration: 2100,
					pieces: 30,
					easing: 'easeInExpo',
					complete: function() {
						$.post("initial", task_object)
					}
				});

*/