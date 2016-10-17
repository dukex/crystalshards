-- +micrate Up
ALTER TABLE shards
  ADD FOREIGN KEY (owner_github_id) REFERENCES owners (github_id)


-- +micrate Down
ALTER TABLE shards
  DROP FOREIGN KEY (owner_github_id) REFERENCES owners (github_id)
