# CrystalShards

> This is a fork of `f/crystalshards` repository, which is a fork of `zamith/crystalshards` repository.

A shard is what we call a crystal library, and this is the website that lists
them all.

# Using Locally

To use a local copy, clone the repository.  Then install necessary shards.

```bash
shards install
```

Setup the postgresql database.

```bash
export PG_URL=postgres://postgres@127.0.0.1:5432/crystalshards
```

Run the migrations

```bash
make migrate_up
```

Compile the frontend assets

```bash
make assets_compile
```

When you are finished, remember to restart your terminal or `source` your edited file.

```bash
crystal ./app.cr
```
