[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: [
    # Allow macro-style calls without parens in tests
    assert: 1,
    assert: 2,
    refute: 1,
    refute: 2
  ]
]
