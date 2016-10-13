-- +micrate Up
CREATE TABLE checker(
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  page INT NOT NULL,
  created_at timestamp without time zone default (now() at time zone 'utc')
);

-- +micrate Down
DROP TABLE checker;
