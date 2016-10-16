-- +micrate Up
CREATE TABLE owners (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  github_id INT UNIQUE,
  login VARCHAR(255) NOT NULL,
  avatar_url VARCHAR(255) NOT NULL,
  html_url VARCHAR(255) NOT NULL,
  type VARCHAR(255) NOT NULL
);

-- +micrate Down
DROP TABLE owners;
