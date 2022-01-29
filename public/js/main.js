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

    console.log('hi')
    // Hide/Show add season/episode in film create
    $('#add_season_checkbox').change(function() {
        hideShowDiv('#add_season_checkbox', '#season_form')
    }) 
    $('#add_episode_checkbox').change(function() {
        hideShowDiv('#add_episode_checkbox', '#episode_form')
    })   
});

function hideShowDiv(actionElementId, contentElementId) {
    if($(actionElementId).is(":checked")) {
        console.log('checked');
        $(contentElementId).removeAttr('hidden');
    } else {
        console.log('unchecked');
        $(contentElementId).attr('hidden', true);
    }
}

