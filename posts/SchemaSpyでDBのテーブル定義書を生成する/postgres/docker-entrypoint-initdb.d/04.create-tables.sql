CREATE TABLE appuser.account (
  id text not null,
  name text not null,
  email text not null,
  password text not null,
  state text not null,
  user_id text
);

-- userは予約後で作成できないためusers
CREATE TABLE appuser.users (
  id text not null,
  account_id text not null,
  first_name text,
  last_name text,
  address1 text,
  address2 text
);

CREATE TABLE appuser.todo (
  text text not null,
  state text not null
);