module Weather exposing (..)

query f q = "http://api.wunderground.com/api/7798a11635de8815/" ++ f ++ "/q/" ++ q ++ ".json"
