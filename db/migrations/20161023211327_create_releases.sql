-- +micrate Up
CREATE TABLE releases (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  github_id INT UNIQUE,
  repo_github_id INT NOT NULL,
  owner_github_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  tag_name VARCHAR(255) NOT NULL,
  body TEXT NOT NULL DEFAULT '',
  published_at TIMESTAMP NOT NULL,
  draft BOOLEAN NOT NULL,
  prerelease BOOLEAN NOT NULL,
  html_url VARCHAR(255)
);

-- +micrate Down
DROP TABLE releases;
