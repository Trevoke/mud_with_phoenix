module App exposing (..)

import Html exposing (Html, h1, text)
import Html.App

type alias Model = String

init : ( Model, Cmd Msg )
init =
  ( "Hello", Cmd.none )

type Msg =
    HelloWorld

view : Model -> Html Msg
view model =
  h1 [] [ text model ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    HelloWorld ->
      ( "Hello World!", Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

main : Program Never
main =
  Html.App.program
    {
      init = init,
      view = view,
      update = update,
      subscriptions = subscriptions
    }
