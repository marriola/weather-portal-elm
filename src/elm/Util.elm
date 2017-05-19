module Util exposing (..)

import MainTypes exposing (..)
import Http exposing (..)
import Maybe exposing (..)
import List
import String
import Task

joinClasses : List (Maybe String) -> String
joinClasses list =
  list
    |> List.filter isNotEmpty
    |> List.map giveDefault
    |> String.join " "

takeNonEmpty : List String -> List String
takeNonEmpty list =
  List.filter (\x -> (String.length x) >= 1) list

giveDefault : Maybe String -> String
giveDefault x =
  case x of
    Just s -> s
    Nothing -> ""

isEmpty : Maybe a -> Bool
isEmpty s =
  case s of
    Just _ -> False
    Nothing -> True

isNotEmpty : Maybe a -> Bool
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

selectScaleOrDefault : Scale -> (Scale -> String) -> Maybe Float -> Maybe Float -> String
selectScaleOrDefault scale indicator metric us =
  (case scale of
    Metric ->
      floatOrNA metric
    US ->
      floatOrNA us
  ) ++ " " ++ indicator scale

floatOrNA : Maybe Float -> String
floatOrNA maybeF =
  case maybeF of
    Just f -> toString f
    Nothing -> "NA"

selectScale : Scale -> (Scale -> String) -> String -> String -> String
selectScale scale indicator metric us =
  (case scale of
    Metric ->
      metric
    US ->
      us
  ) ++ " " ++ indicator scale

choose : Bool -> String -> String
choose condition s =
  if condition then "" else s

orNothing : Bool -> String -> Maybe String
orNothing condition s =
  if condition then Nothing else Just s

send : msg -> Cmd msg
send msg =
  Task.succeed msg
  |> Task.perform identity