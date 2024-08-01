# This file contains the configuration for Credo and you are probably reading
# this after creating it with `mix credo.gen.config`.
#
# If you find anything wrong or unclear in this file, please report an
# issue on GitHub: https://github.com/rrrene/credo/issues
#
%{
  #
  # You can have as many configs as you like in the `configs:` field.
  configs: [
    %{
      #
      # Run any config using `mix credo -C <name>`. If no config name is given
      # "default" is used.
      name: "default",
      #
      # these are the files included in the analysis
      files: %{
        #
        # you can give explicit globs or simply directories
        # in the latter case `**/*.{ex,exs}` will be used
        included: ["lib/", "src/", "test/", "web/", "apps/"],
        excluded: [~r"/_build/", ~r"/deps/", ~r"/node_modules/"]
      },
      #
      # If you create your own checks, you must specify the source files for
      # them here, so they can be loaded by Credo before running the analysis.
      requires: [],
      #
      # Credo automatically checks for updates, like e.g. Hex does.
      # You can disable this behaviour below:
      check_for_updates: true,
      #
      # If you want to enforce a style guide and need a more traditional linting
      # experience, you can change `strict` to `true` below:
      strict: true,
      #
      # If you want to use uncolored output by default, you can change `color`
      # to `false` below:
      color: true,
      #
      # You can customize the parameters of any check by adding a second element
      # to the tuple.
      #
      # To disable a check put `false` as second element:
      #
      #     {Credo.Check.Design.DuplicatedCode, false}
      #
      checks: [
        {Credo.Check.Consistency.ExceptionNames},
        {Credo.Check.Consistency.LineEndings},
        {Credo.Check.Consistency.MultiAliasImportRequireUse},
        {Credo.Check.Consistency.ParameterPatternMatching},
        {Credo.Check.Consistency.SpaceAroundOperators},
        {Credo.Check.Consistency.SpaceInParentheses},
        {Credo.Check.Consistency.TabsOrSpaces},

        # For some checks, like AliasUsage, you can only customize the priority
        # Priority values are: `low, normal, high, higher`
        {Credo.Check.Design.AliasUsage, if_called_more_often_than: 2, priority: :low},

        # For others you can set parameters

        # If you don't want the `setup` and `test` macro calls in ExUnit tests
        # or the `schema` macro in Ecto schemas to trigger DuplicatedCode, just
        # set the `excluded_macros` parameter to `[:schema, :setup, :test]`.
        {Credo.Check.Design.DuplicatedCode, excluded_macros: [], exit_status: 0},

        # You can also customize the exit_status of each check.
        # If you don't want TODO comments to cause `mix credo` to fail, just
        # set this value to 0 (zero).
        {Credo.Check.Design.TagTODO, exit_status: 2},
        {Credo.Check.Design.TagFIXME},
        {Credo.Check.Readability.AliasOrder},
        {Credo.Check.Readability.FunctionNames},
        {Credo.Check.Readability.LargeNumbers},
        {Credo.Check.Readability.MaxLineLength, max_length: 120},
        {Credo.Check.Readability.ModuleAttributeNames},
        {Credo.Check.Readability.ModuleDoc},
        {Credo.Check.Readability.ModuleNames},
        # Unfortunately there is a bug in the NestedFunctionCalls check I wrote
        # so it must be disabled for now. Enable it next year after the fix has
        # been merged.
        {Credo.Check.Readability.NestedFunctionCalls, false},
        {Credo.Check.Readability.ParenthesesInCondition, false},
        {Credo.Check.Readability.ParenthesesOnZeroArityDefs},
        {Credo.Check.Readability.PredicateFunctionNames},
        {Credo.Check.Readability.PreferImplicitTry, exit_status: 0},
        {Credo.Check.Readability.RedundantBlankLines},
        {Credo.Check.Readability.Semicolons},
        {Credo.Check.Readability.SinglePipe},
        {Credo.Check.Readability.SpaceAfterCommas},
        {Credo.Check.Readability.Specs},
        {Credo.Check.Readability.StrictModuleLayout,
         order:
           ~w/shortdoc moduledoc behaviour use import require alias module_attribute defstruct type typep callback macrocallback optional_callbacks/a},
        {Credo.Check.Readability.StringSigils, false},
        {Credo.Check.Readability.TrailingBlankLine},
        {Credo.Check.Readability.TrailingWhiteSpace},
        {Credo.Check.Readability.VariableNames},
        {Credo.Check.Readability.WithSingleClause},
        {Credo.Check.Refactor.ABCSize},
        {Credo.Check.Refactor.AppendSingleItem, exit_status: 0},
        {Credo.Check.Refactor.CaseTrivialMatches, false},
        {Credo.Check.Refactor.CondStatements, false},
        {Credo.Check.Refactor.CyclomaticComplexity},
        {Credo.Check.Refactor.DoubleBooleanNegation},
        {Credo.Check.Refactor.FilterFilter},
        {Credo.Check.Refactor.FilterReject},
        {Credo.Check.Refactor.FunctionArity, max_arity: 6},
        {Credo.Check.Refactor.LongQuoteBlocks, false},
        {Credo.Check.Refactor.MapInto, false},
        {Credo.Check.Refactor.MapJoin},
        {Credo.Check.Refactor.MapMap},
        {Credo.Check.Refactor.MatchInCondition},
        {Credo.Check.Refactor.NegatedConditionsInUnless},
        {Credo.Check.Refactor.NegatedConditionsWithElse},
        {Credo.Check.Refactor.Nesting},
        {Credo.Check.Refactor.PerceivedComplexity, false},
        {Credo.Check.Refactor.PipeChainStart,
         excluded_argument_types: [:atom, :binary, :fn, :keyword], excluded_functions: []},
        {Credo.Check.Refactor.RedundantWithClauseResult},
        {Credo.Check.Refactor.RejectFilter},
        {Credo.Check.Refactor.RejectReject},
        {Credo.Check.Refactor.VariableRebinding},
        {Credo.Check.Refactor.UnlessWithElse},
        {Credo.Check.Refactor.WithClauses},
        {Credo.Check.Warning.ApplicationConfigInModuleAttribute},
        {Credo.Check.Warning.BoolOperationOnSameValues},
        {Credo.Check.Warning.ExpensiveEmptyEnumCheck},
        {Credo.Check.Warning.IExPry},
        {Credo.Check.Warning.IoInspect},
        {Credo.Check.Warning.LazyLogging, false},
        {Credo.Check.Warning.LeakyEnvironment},
        {Credo.Check.Warning.MapGetUnsafePass},
        {Credo.Check.Warning.MixEnv},
        {Credo.Check.Warning.OperationOnSameValues},
        {Credo.Check.Warning.OperationWithConstantResult},
        {Credo.Check.Warning.RaiseInsideRescue},
        {Credo.Check.Warning.SpecWithStruct},
        {Credo.Check.Warning.UnsafeExec},
        {Credo.Check.Warning.UnsafeToAtom},
        {Credo.Check.Warning.UnusedEnumOperation},
        {Credo.Check.Warning.UnusedFileOperation},
        {Credo.Check.Warning.UnusedKeywordOperation},
        {Credo.Check.Warning.UnusedListOperation},
        {Credo.Check.Warning.UnusedPathOperation},
        {Credo.Check.Warning.UnusedRegexOperation},
        {Credo.Check.Warning.UnusedStringOperation},
        {Credo.Check.Warning.UnusedTupleOperation},
        {Credo.Check.Warning.WrongTestFileExtension}

        # Custom checks can be created using `mix credo.gen.check`.
        #
      ]
    }
  ]
}
