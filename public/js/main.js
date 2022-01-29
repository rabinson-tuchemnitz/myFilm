function openLoginModal() {
    $("#loginModal").addClass("fade").modal("show");
}

function openRegisterModal() {
    $("#registerModal").addClass("fade").modal("show");
}

// In your Javascript (external .js resource or <script> tag)
$(document).ready(function() {
    $('.movie-genre-select').select2();
    $('.movie-crew-select').select2();
    $('.series-genre-select').select2();
    $('.series-crew-select').select2();
    $('.person-role-select').select2();
});
