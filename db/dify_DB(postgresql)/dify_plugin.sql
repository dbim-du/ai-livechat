/*
 Navicat Premium Dump SQL

 Source Server         : 192.168.53.133
 Source Server Type    : PostgreSQL
 Source Server Version : 150005 (150005)
 Source Host           : 192.168.53.133:5433
 Source Catalog        : dify_plugin
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 150005 (150005)
 File Encoding         : 65001

 Date: 28/08/2025 10:29:31
*/


-- ----------------------------
-- Table structure for agent_strategy_installations
-- ----------------------------
DROP TABLE IF EXISTS "public"."agent_strategy_installations";
CREATE TABLE "public"."agent_strategy_installations" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "created_at" timestamptz(6),
  "updated_at" timestamptz(6),
  "tenant_id" uuid NOT NULL,
  "provider" varchar(127) COLLATE "pg_catalog"."default" NOT NULL,
  "plugin_unique_identifier" varchar(255) COLLATE "pg_catalog"."default",
  "plugin_id" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for ai_model_installations
-- ----------------------------
DROP TABLE IF EXISTS "public"."ai_model_installations";
CREATE TABLE "public"."ai_model_installations" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "created_at" timestamptz(6),
  "updated_at" timestamptz(6),
  "provider" varchar(127) COLLATE "pg_catalog"."default" NOT NULL,
  "tenant_id" uuid NOT NULL,
  "plugin_unique_identifier" varchar(255) COLLATE "pg_catalog"."default",
  "plugin_id" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for endpoints
-- ----------------------------
DROP TABLE IF EXISTS "public"."endpoints";
CREATE TABLE "public"."endpoints" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "created_at" timestamptz(6),
  "updated_at" timestamptz(6),
  "name" varchar(127) COLLATE "pg_catalog"."default" DEFAULT 'default'::character varying,
  "hook_id" varchar(127) COLLATE "pg_catalog"."default",
  "tenant_id" varchar(64) COLLATE "pg_catalog"."default",
  "user_id" varchar(64) COLLATE "pg_catalog"."default",
  "plugin_id" varchar(64) COLLATE "pg_catalog"."default",
  "expired_at" timestamptz(6),
  "enabled" bool,
  "settings" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for install_tasks
-- ----------------------------
DROP TABLE IF EXISTS "public"."install_tasks";
CREATE TABLE "public"."install_tasks" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "created_at" timestamptz(6),
  "updated_at" timestamptz(6),
  "status" text COLLATE "pg_catalog"."default" NOT NULL,
  "tenant_id" uuid NOT NULL,
  "total_plugins" int8 NOT NULL,
  "completed_plugins" int8 NOT NULL,
  "plugins" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for plugin_declarations
-- ----------------------------
DROP TABLE IF EXISTS "public"."plugin_declarations";
CREATE TABLE "public"."plugin_declarations" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "created_at" timestamptz(6),
  "updated_at" timestamptz(6),
  "plugin_unique_identifier" varchar(255) COLLATE "pg_catalog"."default",
  "plugin_id" varchar(255) COLLATE "pg_catalog"."default",
  "declaration" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for plugin_installations
-- ----------------------------
DROP TABLE IF EXISTS "public"."plugin_installations";
CREATE TABLE "public"."plugin_installations" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "created_at" timestamptz(6),
  "updated_at" timestamptz(6),
  "tenant_id" uuid,
  "plugin_id" varchar(255) COLLATE "pg_catalog"."default",
  "plugin_unique_identifier" varchar(255) COLLATE "pg_catalog"."default",
  "runtime_type" varchar(127) COLLATE "pg_catalog"."default",
  "endpoints_setups" int8,
  "endpoints_active" int8,
  "source" varchar(63) COLLATE "pg_catalog"."default",
  "meta" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for plugins
-- ----------------------------
DROP TABLE IF EXISTS "public"."plugins";
CREATE TABLE "public"."plugins" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "created_at" timestamptz(6),
  "updated_at" timestamptz(6),
  "plugin_unique_identifier" varchar(255) COLLATE "pg_catalog"."default",
  "plugin_id" varchar(255) COLLATE "pg_catalog"."default",
  "refers" int8 DEFAULT 0,
  "install_type" varchar(127) COLLATE "pg_catalog"."default",
  "manifest_type" varchar(127) COLLATE "pg_catalog"."default",
  "remote_declaration" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for serverless_runtimes
-- ----------------------------
DROP TABLE IF EXISTS "public"."serverless_runtimes";
CREATE TABLE "public"."serverless_runtimes" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "created_at" timestamptz(6),
  "updated_at" timestamptz(6),
  "plugin_unique_identifier" varchar(255) COLLATE "pg_catalog"."default",
  "function_url" varchar(255) COLLATE "pg_catalog"."default",
  "function_name" varchar(127) COLLATE "pg_catalog"."default",
  "type" varchar(127) COLLATE "pg_catalog"."default",
  "checksum" varchar(127) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for tenant_storages
-- ----------------------------
DROP TABLE IF EXISTS "public"."tenant_storages";
CREATE TABLE "public"."tenant_storages" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "created_at" timestamptz(6),
  "updated_at" timestamptz(6),
  "tenant_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "plugin_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "size" int8 NOT NULL
)
;

-- ----------------------------
-- Table structure for tool_installations
-- ----------------------------
DROP TABLE IF EXISTS "public"."tool_installations";
CREATE TABLE "public"."tool_installations" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "created_at" timestamptz(6),
  "updated_at" timestamptz(6),
  "tenant_id" uuid NOT NULL,
  "provider" varchar(127) COLLATE "pg_catalog"."default" NOT NULL,
  "plugin_unique_identifier" varchar(255) COLLATE "pg_catalog"."default",
  "plugin_id" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Function structure for uuid_generate_v1
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v1"();
CREATE FUNCTION "public"."uuid_generate_v1"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v1'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v1mc
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v1mc"();
CREATE FUNCTION "public"."uuid_generate_v1mc"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v1mc'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v3
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v3"("namespace" uuid, "name" text);
CREATE FUNCTION "public"."uuid_generate_v3"("namespace" uuid, "name" text)
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v3'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v4
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v4"();
CREATE FUNCTION "public"."uuid_generate_v4"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v4'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v5
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v5"("namespace" uuid, "name" text);
CREATE FUNCTION "public"."uuid_generate_v5"("namespace" uuid, "name" text)
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v5'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_nil
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_nil"();
CREATE FUNCTION "public"."uuid_nil"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_nil'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_dns
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_dns"();
CREATE FUNCTION "public"."uuid_ns_dns"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_dns'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_oid
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_oid"();
CREATE FUNCTION "public"."uuid_ns_oid"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_oid'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_url
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_url"();
CREATE FUNCTION "public"."uuid_ns_url"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_url'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_x500
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_x500"();
CREATE FUNCTION "public"."uuid_ns_x500"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_x500'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Indexes structure for table agent_strategy_installations
-- ----------------------------
CREATE INDEX "idx_agent_strategy_installations_plugin_id" ON "public"."agent_strategy_installations" USING btree (
  "plugin_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_agent_strategy_installations_plugin_unique_identifier" ON "public"."agent_strategy_installations" USING btree (
  "plugin_unique_identifier" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_agent_strategy_installations_provider" ON "public"."agent_strategy_installations" USING btree (
  "provider" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_agent_strategy_installations_tenant_id" ON "public"."agent_strategy_installations" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table agent_strategy_installations
-- ----------------------------
ALTER TABLE "public"."agent_strategy_installations" ADD CONSTRAINT "agent_strategy_installations_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table ai_model_installations
-- ----------------------------
CREATE INDEX "idx_ai_model_installations_plugin_id" ON "public"."ai_model_installations" USING btree (
  "plugin_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_ai_model_installations_plugin_unique_identifier" ON "public"."ai_model_installations" USING btree (
  "plugin_unique_identifier" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_ai_model_installations_provider" ON "public"."ai_model_installations" USING btree (
  "provider" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_ai_model_installations_tenant_id" ON "public"."ai_model_installations" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table ai_model_installations
-- ----------------------------
ALTER TABLE "public"."ai_model_installations" ADD CONSTRAINT "ai_model_installations_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table endpoints
-- ----------------------------
CREATE INDEX "idx_endpoints_plugin_id" ON "public"."endpoints" USING btree (
  "plugin_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_endpoints_tenant_id" ON "public"."endpoints" USING btree (
  "tenant_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_endpoints_user_id" ON "public"."endpoints" USING btree (
  "user_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table endpoints
-- ----------------------------
ALTER TABLE "public"."endpoints" ADD CONSTRAINT "uni_endpoints_hook_id" UNIQUE ("hook_id");

-- ----------------------------
-- Primary Key structure for table endpoints
-- ----------------------------
ALTER TABLE "public"."endpoints" ADD CONSTRAINT "endpoints_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table install_tasks
-- ----------------------------
ALTER TABLE "public"."install_tasks" ADD CONSTRAINT "install_tasks_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table plugin_declarations
-- ----------------------------
CREATE INDEX "idx_plugin_declarations_plugin_id" ON "public"."plugin_declarations" USING btree (
  "plugin_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table plugin_declarations
-- ----------------------------
ALTER TABLE "public"."plugin_declarations" ADD CONSTRAINT "uni_plugin_declarations_plugin_unique_identifier" UNIQUE ("plugin_unique_identifier");

-- ----------------------------
-- Primary Key structure for table plugin_declarations
-- ----------------------------
ALTER TABLE "public"."plugin_declarations" ADD CONSTRAINT "plugin_declarations_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table plugin_installations
-- ----------------------------
CREATE INDEX "idx_plugin_installations_plugin_id" ON "public"."plugin_installations" USING btree (
  "plugin_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_plugin_installations_plugin_unique_identifier" ON "public"."plugin_installations" USING btree (
  "plugin_unique_identifier" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_plugin_installations_tenant_id" ON "public"."plugin_installations" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table plugin_installations
-- ----------------------------
ALTER TABLE "public"."plugin_installations" ADD CONSTRAINT "plugin_installations_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table plugins
-- ----------------------------
CREATE INDEX "idx_plugins_install_type" ON "public"."plugins" USING btree (
  "install_type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_plugins_plugin_id" ON "public"."plugins" USING btree (
  "plugin_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_plugins_plugin_unique_identifier" ON "public"."plugins" USING btree (
  "plugin_unique_identifier" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table plugins
-- ----------------------------
ALTER TABLE "public"."plugins" ADD CONSTRAINT "plugins_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table serverless_runtimes
-- ----------------------------
CREATE INDEX "idx_serverless_runtimes_checksum" ON "public"."serverless_runtimes" USING btree (
  "checksum" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table serverless_runtimes
-- ----------------------------
ALTER TABLE "public"."serverless_runtimes" ADD CONSTRAINT "uni_serverless_runtimes_plugin_unique_identifier" UNIQUE ("plugin_unique_identifier");

-- ----------------------------
-- Primary Key structure for table serverless_runtimes
-- ----------------------------
ALTER TABLE "public"."serverless_runtimes" ADD CONSTRAINT "serverless_runtimes_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table tenant_storages
-- ----------------------------
CREATE INDEX "idx_tenant_storages_plugin_id" ON "public"."tenant_storages" USING btree (
  "plugin_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_tenant_storages_tenant_id" ON "public"."tenant_storages" USING btree (
  "tenant_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tenant_storages
-- ----------------------------
ALTER TABLE "public"."tenant_storages" ADD CONSTRAINT "tenant_storages_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table tool_installations
-- ----------------------------
CREATE INDEX "idx_tool_installations_plugin_id" ON "public"."tool_installations" USING btree (
  "plugin_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_tool_installations_plugin_unique_identifier" ON "public"."tool_installations" USING btree (
  "plugin_unique_identifier" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_tool_installations_provider" ON "public"."tool_installations" USING btree (
  "provider" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_tool_installations_tenant_id" ON "public"."tool_installations" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tool_installations
-- ----------------------------
ALTER TABLE "public"."tool_installations" ADD CONSTRAINT "tool_installations_pkey" PRIMARY KEY ("id");
