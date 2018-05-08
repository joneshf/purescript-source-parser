module Test.Main where

import Prelude

import Control.Monad.Eff
  ( Eff
  )
import Data.Either
  ( Either(Right, Left)
  )
import Node.Encoding
  ( Encoding(..)
  )
import Node.FS
  ( FS
  )
import Node.FS.Aff
  ( readTextFile
  )
import Test.Spec
  ( describe
  , it
  )
import Test.Spec.Assertions
  ( fail
  )
import Test.Spec.Reporter.Spec
  ( specReporter
  )
import Test.Spec.Runner
  ( RunnerEffects
  , run
  )
import Text.Parsing.StringParser
  ( ParseError(..)
  , runParser
  )

import PureScript.Parser as PureScript.Parser

main ::
  Eff (RunnerEffects (fs :: FS)) Unit
main = run [ specReporter
           ] do
    describe "PureScript" do
      describe "Parser" do
        describe "module'" do
          it "parses the PureScript.Parser module" do
            contents <- readTextFile UTF8 "src/PureScript/Parser.purs"
            case runParser PureScript.Parser.module' contents of
              Left (ParseError str) -> fail str
              Right _ -> pure unit
