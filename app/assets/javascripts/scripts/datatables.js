$(document).ready(function(){
  if (!$.fn.dataTable.isDataTable('table.datatable')) {
    var table = $('table.datatable').DataTable({
      aaSorting: [],
      pageLength: 25,
      responsive: true,
      dom: '<"html5buttons"B>lTfgitp',
      buttons: [
        {extend: 'copy'},
        {extend: 'csv'},
        {extend: 'excel', title: 'Export'},
        {extend: 'pdf', title: 'Export'},
        {extend: 'print', customize: function (win) {
          $(win.document.body).addClass('white-bg');
          $(win.document.body).css('font-size', '10px');
          $(win.document.body).find('table')
                              .addClass('compact')
                              .css('font-size', 'inherit');
          }
        }
      ]
    });
  };

  if (!$.fn.dataTable.isDataTable('table.ajax-datatable')) {
    var tables = $('table.ajax-datatable');
    $.map(tables, function(table){
      $(table).DataTable({
        aaSorting: [],
        pageLength: 25,
        responsive: true,
        dom: '<"html5buttons"B>lTfgitp',
        sAjaxDataProp: "",
        ajax: $(table).data('url'),
        columns: $(table).data('columns'),
        buttons: [
          {extend: 'copy'},
          {extend: 'csv'},
          {extend: 'excel', title: 'Export'},
          {extend: 'pdf', title: 'Export'},
          {extend: 'print', customize: function (win) {
            $(win.document.body).addClass('white-bg');
            $(win.document.body).css('font-size', '10px');
            $(win.document.body).find('table')
                                .addClass('compact')
                                .css('font-size', 'inherit');
            }
          }
        ]
      });
    });
  };
});
