[
  import_deps: [:phoenix, :plug],
  inputs: [
    ".formatter.exs",
    "mix.exs",
    "{config,lib,test}/**/*.{ex,exs}"
  ],
  locals_without_parens: [
    # Ex
    defguardp: 2,

    # Ecto
    add: 2,
    add: 3,
    belongs_to: 2,
    create: 1,
    create_if_not_exists: 1,
    drop: 1,
    drop_if_exists: 1,
    field: 2,
    from: 2,
    has_many: 2,
    has_one: 2,
    modify: 2,
    modify: 3,
    remove: 1,
    rename: 3,

    # EctoEnum
    defenum: 2,
    defenum: 3,

    # Phoenix
    action_fallback: 1,
    assert_broadcast: 2,
    assert_reply: 2,
    channel: 2,
    pipe_through: 1,
    resources: 3,
    transport: 2,
    transport: 3,

    # JaSerializer
    attributes: 1,
    location: 1
  ]
]
