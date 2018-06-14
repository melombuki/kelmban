module Dashboard exposing (..)

import Html exposing (Html, button, div, text, br)
import Html.Events exposing (onClick)




-- MODEL


type alias Model = 
  { count: Int }

initialModel : Model
initialModel =
  { count = 0 }
  



-- MESSAGES


type Msg
  = Increase
  | Decrease
  
  
  
  
-- VIEW


view : Model -> Html Msg
view model = 
  div []
    [ button [ onClick Increase ] [ text "Increase" ]
    , div [] [ text (toString model.count) ]
    , button [ onClick Decrease ] [ text "Decrease" ]
    ]
  
  
  
    
-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update message model = 
  case message of
    Increase ->
      ( { model | count = model.count + 1 }, Cmd.none )
      
    Decrease ->
      ( { model | count = model.count - 1 }, Cmd.none )