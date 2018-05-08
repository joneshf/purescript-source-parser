module PureScript.Parser where

import Prelude

import Text.Parsing.StringParser
  ( Parser
  )

type Module
  = {}

module' ::
  Parser Module
module' = pure {}
