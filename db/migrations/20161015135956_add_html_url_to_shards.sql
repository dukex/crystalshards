-- +micrate Up
ALTER TABLE shards
  ADD COLUMN html_url VARCHAR(255) NOT NULL DEFAULT '';

-- +micrate Down
ALTER TABLE shards
  DROP COLUMN html_url;
