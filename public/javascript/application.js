$(function () {
  $('input.hover').focus(function () {
    $('table').addClass('table-hover');
    $(this).addClass('table-hover');
  });
});

$(function () {
  $('input.hover').focusout(function () {
    $('table').removeClass('table-hover');
    $(this).removeClass('table-hover');
  });
});

$(function () {
  $('table').addClass('hovered');
  $('#submit').addClass('hovered');
});
