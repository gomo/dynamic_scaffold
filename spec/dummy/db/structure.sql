CREATE TABLE "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "countries" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "sequence" integer NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "states" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "sequence" integer NOT NULL, "country_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, CONSTRAINT "fk_rails_40bd891262"
FOREIGN KEY ("country_id")
  REFERENCES "countries" ("id")
);
CREATE INDEX "index_states_on_country_id" ON "states" ("country_id");
CREATE TABLE "categories" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "sequence" integer NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "shops" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "memo" text, "category_id" integer, "status" integer(1) DEFAULT 0 NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, CONSTRAINT "fk_rails_7c2349e03e"
FOREIGN KEY ("category_id")
  REFERENCES "categories" ("id")
);
CREATE INDEX "index_shops_on_category_id" ON "shops" ("category_id");
CREATE TABLE "shop_states" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "shop_id" integer NOT NULL, "state_id" integer NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, CONSTRAINT "fk_rails_0437f3dc16"
FOREIGN KEY ("shop_id")
  REFERENCES "shops" ("id")
, CONSTRAINT "fk_rails_04949e66a6"
FOREIGN KEY ("state_id")
  REFERENCES "states" ("id")
);
CREATE INDEX "index_shop_states_on_shop_id" ON "shop_states" ("shop_id");
CREATE INDEX "index_shop_states_on_state_id" ON "shop_states" ("state_id");
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar NOT NULL, "encrypted_password" varchar NOT NULL, "role" integer(2) NOT NULL, "sequence" integer NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
INSERT INTO "schema_migrations" (version) VALUES
('20171124081557'),
('20171124081606'),
('20171129083914'),
('20171129083921'),
('20171129083931'),
('20171207055523');


