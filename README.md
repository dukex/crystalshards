# CrystalShards

> This is a fork of `zamith/crystalshards` repository.

A shard is what we call a crystal library, and this is the website that lists
them all.

# Deploying to Heroku

To experiment with this, you can post this to your own heroku site.

You can read about [Deploying to Heroku] or just follow these steps:

```bash
NAME=crystal-shards
heroku create $NAME --buildpack https://github.com/crystal-lang/heroku-buildpack-crystal
git push heroku master
```

[Deploying to Heroku]: https://subvisual.co/blog/posts/63-deploying-a-crystal-application-to-heroku

# Using Locally

To use a local copy, clone the repository.  Then install necessary shards.

```bash
shards install
```

You will need to set two enviornment variables: `GITHUB_USER` and `GITHUB_KEY`.  CrystalShards uses basic auth, so an example `~/.*rc` might look like this:

```bash
export GITHUB_USER="myGithubUsername"
export GITHUB_KEY="myGithubPassword"
```
When you are finished, remember to restart your terminal or `source` your edited file. 

```bash
# starting a server
crystal ./app.cr
```