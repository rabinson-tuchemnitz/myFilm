function openLoginModal() {
    $("#loginModal").addClass("fade").modal("show");
}

function openRegisterModal() {
    $("#registerModal").addClass("fade").modal("show");
}

// In your Javascript (external .js resource or <script> tag)
$(document).ready(function() {
    $('.genre-select').select2();
    $('.crew-select').select2();

    $('#film_type').on('change', function() {
        if($(this).val == "series") {
            $('#subordinate').prop('disabled', 'disabled')
        } else {
            $('#subordinate').prop('disabled', false)
        }
    })
});
