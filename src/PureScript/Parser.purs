module PureScript.Parser where

import Prelude

import Data.Array as Data.Array
import Data.List.Types (NonEmptyList(..))
import Data.NonEmpty (NonEmpty(NonEmpty))
import Data.String as Data.String
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as Data.String.NonEmpty
import Text.Parsing.StringParser (Parser)
import Text.Parsing.StringParser.Combinators as Text.Parsing.StringParser.Combinators
import Text.Parsing.StringParser.String (alphaNum, char, string, upperCaseChar, whiteSpace)

type Module
  = {name :: NonEmptyList (ProperName ModuleName)}

newtype ProperName (name :: Name)
  = ProperName NonEmptyString

foreign import kind Name

foreign import data ModuleName ::
  Name

module' ::
  Parser Module
module' = do
  _ <- string "module"
  _ <- whiteSpace
  name <- sepBy1 properName (char '.')
  _ <- whiteSpace
  _ <- string "where"
  pure {name}

properName :: forall name. Parser (ProperName name)
properName = do
  head <- upperCaseChar
  tail <- Data.Array.many alphaNum
  pure (ProperName (Data.String.NonEmpty.cons head (Data.String.fromCharArray tail)))

sepBy1 :: forall a b. Parser a -> Parser b -> Parser (NonEmptyList a)
sepBy1 parser separator = do
  x <- parser
  xs <- Text.Parsing.StringParser.Combinators.many (separator *> parser)
  pure (NonEmptyList (NonEmpty x xs))
