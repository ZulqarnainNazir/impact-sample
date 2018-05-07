$ = jQuery

$.fn.eventLocation = ->
  container = this
  locationInput = container.find('input[name*=location_id]')
  businessRadio = container.find('.radio[data-type="business"]')
  customRadio = container.find('.radio[data-type="custom"]')
  mapContainer = this.find('.js-event-location-map')
  searchInput = this.find('input[type="text"]')

  locationLookup = new Bloodhound
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('text')
    queryTokenizer: Bloodhound.tokenizers.whitespace
    minLength: 2
    remote:
      url: if businessRadio.length > 0 then "/locations?location_id=#{businessRadio.data('id')}&query=%QUERY" else '/locations?query=%QUERY'

  locationLookup.initialize()

  typeaheadOptions =
    highlight: true
    hint: false
  typeaheadLocationLookupOptions =
    name: 'location-lookup'
    displayKey: 'searchResultText'
    source: locationLookup.ttAdapter()
    templates:
      empty: '<div class="tt-template"><p>No results found.</p></div>'

  searchInput.typeahead typeaheadOptions, typeaheadLocationLookupOptions
  searchInput.closest('.twitter-typeahead').css('width', '100%').css('top', '2px');
  searchInput.closest('.twitter-typeahead').find('.tt-dropdown-menu').css('right', '0');

  updateMap = ->
    checked = container.find('input[type="radio"]:checked')
    update = false

    if checked.length > 0
      name = checked.closest('.radio').data('name')
      latitude = checked.closest('.radio').data('latitude')
      longitude = checked.closest('.radio').data('longitude')

      if name and name.length > 0 and latitude and longitude
        update = true

    if update
      mapContainer.show()
      map = new google.maps.Map mapContainer.get(0),
        center:
          lat: latitude
          lng: longitude
        zoom: 14
        disableDefaultUI: true
        draggable: false
      marker = new google.maps.Marker
        position:
          lat: latitude
          lng: longitude
        map: map
        animation: google.maps.Animation.DROP
        title: name
    else
      mapContainer.empty().hide()

  container.on 'change', 'input[type="radio"]', ->
    locationInput.val($(this).closest('.radio').data('id'))
    updateMap()

  selectCustomLocation = (data) ->
    searchInput.val('')
    locationInput.val(data['id'])
    customRadio.removeClass('hide')
    customRadio.data('name', data['name'])
    customRadio.data('latitude', data['latitude'])
    customRadio.data('longitude', data['longitude'])
    customRadio.find('.text-muted').text(data['fullAddress'])
    customRadio.find('input[type="radio"]').prop('checked', true)
    updateMap()

  searchInput.on 'typeahead:selected', (event, selection, dataset) ->
    selectCustomLocation(selection)

  searchInput.on 'blur', () ->
    searchInput.val('')

  searchInput.keypress (e) ->
    if e.which is 13
      e.preventDefault()

  container.on 'click', '.js-event-location-new a', (e) ->
    $('#js-event-location-new-modal .modal-content').load $(this).attr('href'), ->
      modal = $('#js-event-location-new-modal')
      modal.off 'submit'
      modal.on 'submit', 'form', (e) ->
        e.preventDefault()
        jqxhr = $.ajax
          type: 'POST'
          url: $(this).attr('action')
          beforeSend: (xhr) ->
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
          cache: false
          data: $(this).serialize()
          dataType: 'html'
        jqxhr.done (data) ->
          $('#js-event-location-new-modal').modal('hide')
          selectCustomLocation JSON.parse(data)
        jqxhr.fail (response) ->
          $('#js-event-location-new-modal .modal-content').html(response.responseText);

  updateMap()
