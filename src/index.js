require('./sass/index.scss')

var Elm = require('./elm/Main.elm')
Elm.Main.embed(document.querySelector('[elm-app]'))
