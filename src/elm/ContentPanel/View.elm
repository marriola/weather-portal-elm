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
      search parentModel model

    UpdateConditions resp ->
      updateConditions parentModel model resp

    SelectCity zmw ->
      ({ model |
        conditions = Nothing,
        results = Nothing,
        status = Loading
      }, getConditions zmw)

    LoadCity coordinates ->
      let
        conditions = findConditions (byLocation coordinates) model.places
      in
        case conditions of
          Just c ->
            ({ model | conditions = conditions }, Cmd.none)
          Nothing ->
            (model, Cmd.none)

updateConditions : Model -> ContentModel -> Result Http.Error WeatherResponse -> (ContentModel, Cmd Msg)
updateConditions parentModel model resp =
  case resp of
    Ok result ->
      let
        (beforeError, cmd) =
          ({ model |
            places = updatePlaces model.places result.current_observation,
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


search : Model -> ContentModel -> (ContentModel, Cmd Msg)
search parentModel model =
  let
    conditions = findConditions (byName parentModel.dashboard.search) parentModel.content.places
  in
    case conditions of
      Just c ->
        ({ model |
          conditions = conditions,
          status = Loaded
        }, Cmd.none)

      Nothing ->
        ({ model |
          conditions = Nothing,
          status = Loading
        }, getConditions parentModel.dashboard.search)


updatePlaces : List Conditions -> Maybe Conditions -> List Conditions
updatePlaces places result =
  case result of
    Just c ->
      places ++ [c]
    Nothing ->
      places

byName : String -> Conditions -> Bool
byName name location =
  String.contains name location.display_location.city

byLocation : (String, String, String) -> Conditions -> Bool
byLocation (city, state, country) location =
  let
    dl = location.display_location
  in
    (city, state, country) == (dl.city, dl.state, dl.country)

findConditions : (Conditions -> Bool) -> List Conditions -> Maybe Conditions
findConditions predicate places =
  let
    match = places
      |> List.filter predicate
      |> List.take 1
  in
    case match of
      x::_ ->
        Just x
      [] ->
        Nothing

getConditions : String -> Cmd Msg
getConditions place =
  let
    url = Weather.query "conditions" place
  in
    Http.send (TagContentMsg << UpdateConditions) (Http.get url weatherResponse)
