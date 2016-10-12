-- +micrate Up
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE shards(
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  github_id INT UNIQUE,
  name VARCHAR(255) NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  watchers_count INT NOT NULL,
  stargazers_count INT NOT NULL,
  url VARCHAR(255) NOT NULL,
  homepage VARCHAR(255) NOT NULL DEFAULT ''
);

-- +micrate Down
DROP TABLE shards;
