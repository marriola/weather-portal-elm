module ContentPanel.View exposing (view, update)

import ContentPanel.ViewMain

import Weather
import MainTypes exposing (..)
import Decoders.Conditions exposing (Conditions, decodeConditions)
import Util exposing (..)

import Http exposing (..)
import Html exposing (Html, Attribute, label, text, div, input, button, ul, li, a, tr)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)

view : Model -> Html Msg
view model = ContentPanel.ViewMain.view model

update : ContentMsg -> Model -> ContentModel -> (ContentModel, Cmd Msg)
update msg parentModel model =
  case msg of
    Search ->
      ({ model |
        place = parentModel.dashboard.search,
        conditions = Nothing,
        status = Loading
      }, getConditions parentModel.dashboard.search)

    UpdateConditions c ->
      case c of
        Ok result ->
          ({ model | conditions = Just result, status = Loaded }, Cmd.none)
        Err e ->
          ({ model |
            conditions = Nothing,
            status = Failed (errorToString e)
          }, Cmd.none)

getConditions : String -> Cmd Msg
getConditions place =
  let
    url = Weather.query "conditions" place
  in
    Http.send (TagContentMsg << UpdateConditions) (Http.get url decodeConditions)
