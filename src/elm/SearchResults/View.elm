module SearchResults.View exposing (view, update)

import SearchResults.ViewMain
import Html exposing (Html, Attribute, label, text, div, input, button, ul, li, a)
import MainTypes exposing (..)

view : Model -> Html Msg
view model = SearchResults.ViewMain.view model

update : Model -> Msg -> (Model, Cmd Msg)
update model msg = (model, Cmd.none)
