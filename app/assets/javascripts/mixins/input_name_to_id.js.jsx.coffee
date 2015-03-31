InputNameToID =
  inputNameToID: (name) ->
    name.replace(/\[\]/, '-').replace(/\A\-/, '').replace(/\-\z/, '')

window.InputNameToID = InputNameToID
