function openLoginModal() {
    $("#loginModal").addClass("fade").modal("show");
}

function openRegisterModal() {
    $("#registerModal").addClass("fade").modal("show");
}

// In your Javascript (external .js resource or <script> tag)
$(document).ready(function() {
    $('.movie-genres-select').select2();
    $('.movie-persons-select').select2();
    $('.series-genres-select').select2();
    $('.series-persons-select').select2();
    $('.person-role-select').select2();
});



$('#confirm-film-delete').on('show.bs.modal', function(e) {
    console.log('hi');
    $(this).find('.btn-ok').attr('href', $(e.relatedTarget).data('href'));
});