module Util exposing (..)

import MainTypes
import Http exposing (..)
import Maybe exposing (..)
import List
import String

joinClasses : List (Maybe String) -> String
joinClasses list =
  list
    |> List.filter isNotEmpty
    |> List.map giveDefault
    |> String.join " "

giveDefault : Maybe String -> String
giveDefault x =
  case x of
    Just s -> s
    Nothing -> ""

isNotEmpty : Maybe String -> Bool
isNotEmpty s =
  case s of
    Just _ -> True
    Nothing -> False

getMessage : Http.Response String -> String
getMessage resp =
  let
    { code, message } = resp.status
  in
    message

errorToString : Error -> String
errorToString err =
  case err of
    Timeout ->
      "Timeout"
    NetworkError ->
      "Network error"
    BadPayload msg resp ->
      msg
    BadStatus resp ->
      getMessage resp
    BadUrl msg ->
      msg

selectScale : MainTypes.Scale -> (MainTypes.Scale -> String) -> String -> String -> String
selectScale scale indicator metric us =
  (case scale of
    MainTypes.Metric ->
      metric
    MainTypes.US ->
      us
  ) ++ indicator scale
