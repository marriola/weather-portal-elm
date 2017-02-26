module ContentPanel.View exposing (view, update)

import ContentPanel.ViewMain

import Weather
import MainTypes exposing (..)
import Decoders.Conditions exposing (WeatherResponse, Conditions, weatherResponse)
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

    UpdateConditions resp ->
      case resp of
        Ok result ->
          let
            (beforeError, cmd) =
              ({ model |
                conditions = result.current_observation,
                results = result.response.results,
                status = Loaded,
                error = Nothing
              }, Cmd.none)
          in
            case result.response.error of
              Just err ->
                ({ beforeError | error = Just err }, cmd)
              Nothing ->
                (beforeError, cmd)
        Err e ->
          ({ model |
            conditions = Nothing,
            results = Nothing,
            status = Failed (errorToString e)
          }, Cmd.none)

    SelectCity zmw ->
      ({ model |
        conditions = Nothing,
        results = Nothing,
        status = Loading
      }, getConditions zmw)

getConditions : String -> Cmd Msg
getConditions place =
  let
    url = Weather.query "conditions" place
  in
    Http.send (TagContentMsg << UpdateConditions) (Http.get url weatherResponse)
