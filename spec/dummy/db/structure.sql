CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE IF NOT EXISTS "countries" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "sequence" integer NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS "states" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "sequence" integer NOT NULL, "country_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, CONSTRAINT "fk_rails_40bd891262"
FOREIGN KEY ("country_id")
  REFERENCES "countries" ("id")
);
CREATE INDEX "index_states_on_country_id" ON "states" ("country_id");
CREATE TABLE IF NOT EXISTS "categories" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "sequence" integer NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE IF NOT EXISTS "shop_states" ("shop_id" integer NOT NULL, "state_id" integer NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, PRIMARY KEY ("shop_id", "state_id"), CONSTRAINT "fk_rails_0437f3dc16"
FOREIGN KEY ("shop_id")
  REFERENCES "shops" ("id")
, CONSTRAINT "fk_rails_04949e66a6"
FOREIGN KEY ("state_id")
  REFERENCES "states" ("id")
);
CREATE INDEX "index_shop_states_on_shop_id" ON "shop_states" ("shop_id");
CREATE INDEX "index_shop_states_on_state_id" ON "shop_states" ("state_id");
CREATE TABLE IF NOT EXISTS "users" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar NOT NULL, "encrypted_password" varchar NOT NULL, "role" integer(2) NOT NULL, "sequence" integer NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE IF NOT EXISTS "shop_translations" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "shop_id" integer NOT NULL, "locale" varchar NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "desc" text, "keyword" varchar);
CREATE TABLE IF NOT EXISTS "shops" ("id" integer NOT NULL PRIMARY KEY, "name" varchar NOT NULL, "memo" text DEFAULT NULL, "category_id" integer DEFAULT NULL, "status" integer(1) DEFAULT 0 NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "image" varchar DEFAULT NULL, "foo_date" date, "bar_date" date, "quz_datetime" datetime);
CREATE INDEX "index_shops_on_category_id" ON "shops" ("category_id");
CREATE INDEX "index_shop_translations_on_shop_id" ON "shop_translations" ("shop_id");
CREATE INDEX "index_shop_translations_on_locale" ON "shop_translations" ("locale");
CREATE TABLE IF NOT EXISTS "shop_memos" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "shop_id" integer NOT NULL, "title" varchar NOT NULL, "body" text NOT NULL, CONSTRAINT "fk_rails_78646e32a6"
FOREIGN KEY ("shop_id")
  REFERENCES "shops" ("id")
);
CREATE INDEX "index_shop_memos_on_shop_id" ON "shop_memos" ("shop_id");
INSERT INTO "schema_migrations" (version) VALUES
('20171124081557'),
('20171124081606'),
('20171129083914'),
('20171129083921'),
('20171129083931'),
('20171207055523'),
('20180522060727'),
('20180731051454'),
('20190122032620'),
('20190416013444'),
('20191015090652');


