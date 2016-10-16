-- +micrate Up
ALTER TABLE shards
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT now(),
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT now();

-- +micrate Down
ALTER TABLE shards
  DROP COLUMN created_at,
  DROP COLUMN updated_at;

