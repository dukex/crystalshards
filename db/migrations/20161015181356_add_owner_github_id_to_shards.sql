-- +micrate Up
ALTER TABLE shards
  ADD COLUMN owner_github_id INT NOT NULL;

-- +micrate Down
ALTER TABLE shards
  DROP COLUMN owner_github_id;
