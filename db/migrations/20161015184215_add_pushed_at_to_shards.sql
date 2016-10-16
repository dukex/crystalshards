-- +micrate Up
ALTER TABLE shards
  ADD COLUMN pushed_at TIMESTAMP NOT NULL;

-- +micrate Down
ALTER TABLE shards
  DROP COLUMN pushed_at;
