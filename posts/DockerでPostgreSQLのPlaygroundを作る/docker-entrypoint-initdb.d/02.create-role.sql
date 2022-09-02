-- ユーザ作成
CREATE ROLE appuser WITH LOGIN nosuperuser inherit nocreatedb nocreaterole noreplication PASSWORD 'P@ssw0rd';
-- ユーザのデフォルトスキーマ変更
ALTER ROLE appuser SET search_path TO appuser;
