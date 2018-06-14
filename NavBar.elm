module NavBar exposing (..)

import Html exposing (Html, div, ul, li, text)




-- MODEL


type alias Model = 
  { tabs : List String }
  
init : List String -> Model
init tabs = 
  { tabs = tabs }
  
-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update message model = 
  case message of
    _ ->
      ( model, Cmd.none )




-- MESSAGE


type Msg =
  None




-- VIEW


view : Model -> Html Msg
view model = 
  div []
    [ ul [] (List.map navBarTab model.tabs)
    ]

navBarTab : String -> Html Msg
navBarTab tab =
  li []
    [ text tab
    ]