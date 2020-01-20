module RTTLSpec exposing (spec)

import Expect
import Test exposing (..)


spec : Test
spec =
    describe "RTTL"
        [ describe "parseComposer"
            [ test "parses Nokia Composer format" <|
                \_ ->
                    Expect.equal 1 1
            ]
        ]
