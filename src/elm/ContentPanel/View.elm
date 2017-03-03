module ContentPanel.View exposing (view, update)

import ContentPanel.ViewMain

import Weather
import MainTypes exposing (..)
import Decoders.Conditions exposing (WeatherResponse, Conditions, weatherResponse)
import Util exposing (..)

import Http exposing (..)
import Html exposing (Html, Attribute, label, text, div, input, button, ul, li, a, tr)


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


addKey : ContentModel -> Maybe Conditions -> (ContentModel, Maybe Conditions)
addKey model maybeConditions =
  let
    conditionsWithKey = 
      case maybeConditions of
        Just conditions ->
          Just { conditions | key = model.nextKey }
        Nothing ->
          maybeConditions

    modelWithKey =
      case maybeConditions of
        Just _ -> { model | nextKey = model.nextKey + 1 }
        Nothing -> model
    
  in
    (modelWithKey, conditionsWithKey)

updateConditions : Model -> ContentModel -> Maybe Int -> Result Http.Error WeatherResponse -> (ContentModel, Cmd Msg)
updateConditions parentModel model maybeKey resp =
  case resp of
    Ok result ->
      let
        (modelWithKey, conditionsWithKey) = addKey model result.current_observation

        newPlaces =
          case conditionsWithKey of
            Just conditions ->
              case maybeKey of
                Just key -> refreshPlace model.places key conditions
                Nothing -> model.places ++ [conditions]
            Nothing ->
              model.places

        nextModel =
          { modelWithKey |
              places = newPlaces,
              conditions = conditionsWithKey,
              results = result.response.results,
              status = Loaded,
              error = result.response.error
          }

      in
        (nextModel, Cmd.none)

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
  List.map (choosePlace key conditions) places


choosePlace : Int -> Conditions -> Conditions -> Conditions
choosePlace key conditions place =
    if place.key == key then
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
