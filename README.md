# Info

NFL Rushing statistics, using PETAL stack:

- Phoenix
- Elixir
- TailwindCSS
- AlpineJS
- LiveView

DB: Postgres

### Installation and running

Clone:

```
$ git clone git@github.com:devato/petal-stack-example.git
```

Setup (OSX)

```
$ bin/setup
```

Import `rushing.json` data:

```
$ mix app.import.rushing "rushing.json"
```

Start:

```
$ bin/start
```

Test:

```
$ bin/test
```
