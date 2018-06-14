module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Dashboard
import NavBar
import Navigation


main =
  Navigation.program UrlChange
    { init = init 
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }




-- MODEL

type Content = NavbarModel NavBar.Model
             | DashboardModel Dashboard.Model

type alias AppModel =
  { navbarModel : NavBar.Model
  , content     : Content
  , history     : List Navigation.Location
  }

initialModel : AppModel
initialModel =
  { navbarModel = NavBar.init tabs
  , content     = DashboardModel Dashboard.initialModel
  , history     = []
  }

init : Navigation.Location -> ( AppModel, Cmd Msg )
init location = 
  ( initialModel 
  , Cmd.none 
  )

tabs = [ "dashboard", "navbar", "create-task" ]


-- MESSAGES


type Msg
  = DashboardMsg Dashboard.Msg
  | NavbarMsg NavBar.Msg
  | UrlChange Navigation.Location
    
    
    
    
-- VIEW


view : AppModel -> Html Msg
view model =
  div []
    [ div []
        [ ul [ style navUlStyle ] (List.map viewLink model.navbarModel.tabs)
        , h1 [] [ text "History" ]
        , ul [] (List.map viewLocation model.history)
        ]
    , div []
        [ content model.content ]
    ]
  

viewLink : String -> Html Msg
viewLink name = 
  li [ style navLiStyle ] [ a [ style navLiAStyle, href ("#" ++ name) ] [ text name ] ]


viewLocation : Navigation.Location -> Html msg
viewLocation location = 
  li [] [ text (location.hash) ]


content : Content -> Html Msg
content model =
  case model of
    NavbarModel submodel ->
      Html.map NavbarMsg ( NavBar.view submodel )
      
    DashboardModel submodel -> 
      Html.map DashboardMsg ( Dashboard.view submodel )




-- STYLES


navUlStyle =
  [ ( "list-style-type", "none" )
  , ( "margin", "0" )
  , ( "padding", "0" )
  , ( "overflow", "hidden" )
  , ( "background-color", "#333" )
  ]
  
navLiStyle =
  [ ( "float", "left" )
  ]
  
navLiAStyle =
  [ ( "display", "block" )
  , ( "color", "white" )
  , ( "text-align", "center" )
  , ( "padding", "14px 16px" )
  , ( "text-decoration", "none")
  ]

-- UPDATE


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update message model =
  let 
    content = model.content
    currentHash = 
      case (List.head model.history) of
        Just a ->
          a.hash
        _ ->
        ""
  in
  case (message, content) of
    (UrlChange location, _) ->
      case location.hash of
          
        "#dashboard" ->
          if currentHash == "#dashboard" then
            ( model, Cmd.none )
          else
            ( { model | history = location :: model.history, content = DashboardModel Dashboard.initialModel }
            , Cmd.none 
            )
          
        "#navbar" ->
          if currentHash == "#navbar" then
              ( model, Cmd.none )
          else
            ( { model | history = location :: model.history, content = NavbarModel (NavBar.init tabs) }
            , Cmd.none 
            )
          
        "#create-task" ->
--          if currentHash == "#create-task" then
            ( model, Cmd.none )
--          else
--            ( { model | history = location :: model.history }
--            , Cmd.none 
--            )
          

      
    (DashboardMsg subMsg, DashboardModel subModel ) ->
      let
        ( updatedDashboardModel, dashboardCmd ) = 
          Dashboard.update subMsg subModel
      in
      ( { model | content = DashboardModel updatedDashboardModel }
      , Cmd.map DashboardMsg dashboardCmd 
      )
        
    (NavbarMsg subMsg, NavbarModel subModel) ->
      let
        ( updatedNavbarModel , navbarCmd ) 
          = NavBar.update subMsg subModel
      in
        ( { model | content = NavbarModel updatedNavbarModel }
        , Cmd.map NavbarMsg navbarCmd 
        )
        
    ( _, _ ) ->
      ( model, Cmd.none )

        