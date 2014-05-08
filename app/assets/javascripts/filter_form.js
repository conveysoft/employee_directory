// Only display the department dropdown when the department view option is selected
$(document).ready(function(){
    $("input[name$='[user_filter_type]'").change(function(){
        var radio = $(this).val();
        if(radio==="dep") {
            $(".dept-list").show("fast");
            $('select option:first-child').attr("selected", "selected");
        } else {
            $(".dept-list").hide("fast");
        };
    });
});

