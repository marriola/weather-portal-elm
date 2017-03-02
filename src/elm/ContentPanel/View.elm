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

update : Msg -> Model -> ContentModel -> (ContentModel, Cmd Msg)
update msg parentModel model =
  case msg of
    TagContentMsg Search ->
      search parentModel model

    TagContentMsg (UpdateConditions key resp) ->

      updateConditions parentModel model key resp

    TagContentMsg CloseConditions ->
      ({ model | conditions = Nothing }, Cmd.none)

    TagContentMsg (RefreshConditions key) ->
      case (findConditions (byKey key) model.places) of
        Just place ->
          ({ model | status = Loading }, refreshConditions key place.display_location.full)
        Nothing ->
          (model, Cmd.none)

    TagContentMsg (SelectCity zmw) ->
      ({ model |
        conditions = Nothing,
        results = Nothing,
        status = Loading
      }, getConditions zmw)

    TagContentMsg (LoadCity coordinates) ->
      let
        conditions = findConditions (byLocation coordinates) model.places
      in
        case conditions of
          Just c ->
            ({ model | conditions = conditions }, Cmd.none)
          Nothing ->
            (model, Cmd.none)

    _ ->
      (model, Cmd.none)


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

addKey : ContentModel -> ContentModel
addKey model =
  { model |
    nextKey = model.nextKey + 1,
    conditions = addKeyInternal model.nextKey model.conditions
  }

addKeyInternal : Int -> Maybe Conditions -> Maybe Conditions
addKeyInternal key maybeConditions =
  case maybeConditions of
    Just conditions ->
      Just { conditions | key = key }
    Nothing ->
      Nothing

updateConditions : Model -> ContentModel -> Maybe Int -> Result Http.Error WeatherResponse -> (ContentModel, Cmd Msg)
updateConditions parentModel model maybeKey resp =
  case resp of
    Ok result ->
      let
        addingNew =
          case result.current_observation of
            Just _ ->
              case maybeKey of
                Just _ ->
                  False
                Nothing ->
                  True
            Nothing ->
              False

        newPlaces =
          case result.current_observation of
            Just conditions ->
              case maybeKey of
                Just key ->
                  refreshPlace model.places key conditions
                Nothing ->
                  model.places ++ [conditions]

            Nothing ->
              model.places

        nextModel =
          { model |
              places = newPlaces,
              conditions = result.current_observation,
              results = result.response.results,
              status = Loaded,
              error = result.response.error
          }
      in
        (if addingNew then
          addKey nextModel
        else
          nextModel, Cmd.none)
    Err e ->
      ({ model |
        conditions = Nothing,
        results = Nothing,
        status = Failed (errorToString e)
      }, Cmd.none)

updatePlaces : Maybe Int -> List Conditions -> Maybe Conditions -> List Conditions
updatePlaces maybeKey places maybeResult =
  case maybeResult of
    Just conditions ->
      case maybeKey of
        Just key ->
          refreshPlace places key conditions

        Nothing ->
          places ++ [conditions]

    Nothing ->
      places

refreshPlace : List Conditions -> Int -> Conditions -> List Conditions
refreshPlace places key conditions =
  List.map (replacePlace key conditions) places

replacePlace : Int -> Conditions -> Conditions -> Conditions
replacePlace key conditions place =
    if place.key == conditions.key then
      conditions
    else
      place

byName : String -> Conditions -> Bool
byName name location =
  String.contains name location.display_location.city

byLocation : (String, String, String) -> Conditions -> Bool
byLocation (city, state, country) location =
  let
    dl = location.display_location
  in
    (city, state, country) == (dl.city, dl.state, dl.country)

byKey : Int -> Conditions -> Bool
byKey key location =
  location.key == key

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

refreshConditions : Int -> String -> Cmd Msg
refreshConditions key place =
  getConditionsInternal (TagContentMsg << UpdateConditions (Just key)) place

getConditions : String -> Cmd Msg
getConditions place =
  getConditionsInternal (TagContentMsg << UpdateConditions Nothing) place

getConditionsInternal : (Result Error WeatherResponse -> Msg) -> String -> Cmd Msg
getConditionsInternal msg place =
  let
    url = Weather.query "conditions" place
  in
    Http.send msg (Http.get url weatherResponse)
