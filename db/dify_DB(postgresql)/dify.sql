/*
 Navicat Premium Dump SQL

 Source Server         : 192.168.53.133
 Source Server Type    : PostgreSQL
 Source Server Version : 150005 (150005)
 Source Host           : 192.168.53.133:5433
 Source Catalog        : dify
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 150005 (150005)
 File Encoding         : 65001

 Date: 28/08/2025 10:28:01
*/


-- ----------------------------
-- Sequence structure for invitation_codes_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."invitation_codes_id_seq";
CREATE SEQUENCE "public"."invitation_codes_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for task_id_sequence
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."task_id_sequence";
CREATE SEQUENCE "public"."task_id_sequence" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for taskset_id_sequence
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."taskset_id_sequence";
CREATE SEQUENCE "public"."taskset_id_sequence" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Table structure for account_integrates
-- ----------------------------
DROP TABLE IF EXISTS "public"."account_integrates";
CREATE TABLE "public"."account_integrates" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "account_id" uuid NOT NULL,
  "provider" varchar(16) COLLATE "pg_catalog"."default" NOT NULL,
  "open_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "encrypted_token" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for account_plugin_permissions
-- ----------------------------
DROP TABLE IF EXISTS "public"."account_plugin_permissions";
CREATE TABLE "public"."account_plugin_permissions" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "install_permission" varchar(16) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'everyone'::character varying,
  "debug_permission" varchar(16) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'noone'::character varying
)
;

-- ----------------------------
-- Table structure for accounts
-- ----------------------------
DROP TABLE IF EXISTS "public"."accounts";
CREATE TABLE "public"."accounts" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "email" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "password" varchar(255) COLLATE "pg_catalog"."default",
  "password_salt" varchar(255) COLLATE "pg_catalog"."default",
  "avatar" varchar(255) COLLATE "pg_catalog"."default",
  "interface_language" varchar(255) COLLATE "pg_catalog"."default",
  "interface_theme" varchar(255) COLLATE "pg_catalog"."default",
  "timezone" varchar(255) COLLATE "pg_catalog"."default",
  "last_login_at" timestamp(6),
  "last_login_ip" varchar(255) COLLATE "pg_catalog"."default",
  "status" varchar(16) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'active'::character varying,
  "initialized_at" timestamp(6),
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "last_active_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for alembic_version
-- ----------------------------
DROP TABLE IF EXISTS "public"."alembic_version";
CREATE TABLE "public"."alembic_version" (
  "version_num" varchar(32) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Table structure for api_based_extensions
-- ----------------------------
DROP TABLE IF EXISTS "public"."api_based_extensions";
CREATE TABLE "public"."api_based_extensions" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "api_endpoint" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "api_key" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for api_requests
-- ----------------------------
DROP TABLE IF EXISTS "public"."api_requests";
CREATE TABLE "public"."api_requests" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "api_token_id" uuid NOT NULL,
  "path" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "request" text COLLATE "pg_catalog"."default",
  "response" text COLLATE "pg_catalog"."default",
  "ip" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for api_tokens
-- ----------------------------
DROP TABLE IF EXISTS "public"."api_tokens";
CREATE TABLE "public"."api_tokens" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "app_id" uuid,
  "type" varchar(16) COLLATE "pg_catalog"."default" NOT NULL,
  "token" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "last_used_at" timestamp(6),
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "tenant_id" uuid
)
;

-- ----------------------------
-- Table structure for app_annotation_hit_histories
-- ----------------------------
DROP TABLE IF EXISTS "public"."app_annotation_hit_histories";
CREATE TABLE "public"."app_annotation_hit_histories" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "app_id" uuid NOT NULL,
  "annotation_id" uuid NOT NULL,
  "source" text COLLATE "pg_catalog"."default" NOT NULL,
  "question" text COLLATE "pg_catalog"."default" NOT NULL,
  "account_id" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "score" float8 NOT NULL DEFAULT 0,
  "message_id" uuid NOT NULL,
  "annotation_question" text COLLATE "pg_catalog"."default" NOT NULL,
  "annotation_content" text COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Table structure for app_annotation_settings
-- ----------------------------
DROP TABLE IF EXISTS "public"."app_annotation_settings";
CREATE TABLE "public"."app_annotation_settings" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "app_id" uuid NOT NULL,
  "score_threshold" float8 NOT NULL DEFAULT 0,
  "collection_binding_id" uuid NOT NULL,
  "created_user_id" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_user_id" uuid NOT NULL,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for app_dataset_joins
-- ----------------------------
DROP TABLE IF EXISTS "public"."app_dataset_joins";
CREATE TABLE "public"."app_dataset_joins" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "app_id" uuid NOT NULL,
  "dataset_id" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Table structure for app_model_configs
-- ----------------------------
DROP TABLE IF EXISTS "public"."app_model_configs";
CREATE TABLE "public"."app_model_configs" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "app_id" uuid NOT NULL,
  "provider" varchar(255) COLLATE "pg_catalog"."default",
  "model_id" varchar(255) COLLATE "pg_catalog"."default",
  "configs" json,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "opening_statement" text COLLATE "pg_catalog"."default",
  "suggested_questions" text COLLATE "pg_catalog"."default",
  "suggested_questions_after_answer" text COLLATE "pg_catalog"."default",
  "more_like_this" text COLLATE "pg_catalog"."default",
  "model" text COLLATE "pg_catalog"."default",
  "user_input_form" text COLLATE "pg_catalog"."default",
  "pre_prompt" text COLLATE "pg_catalog"."default",
  "agent_mode" text COLLATE "pg_catalog"."default",
  "speech_to_text" text COLLATE "pg_catalog"."default",
  "sensitive_word_avoidance" text COLLATE "pg_catalog"."default",
  "retriever_resource" text COLLATE "pg_catalog"."default",
  "dataset_query_variable" varchar(255) COLLATE "pg_catalog"."default",
  "prompt_type" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'simple'::character varying,
  "chat_prompt_config" text COLLATE "pg_catalog"."default",
  "completion_prompt_config" text COLLATE "pg_catalog"."default",
  "dataset_configs" text COLLATE "pg_catalog"."default",
  "external_data_tools" text COLLATE "pg_catalog"."default",
  "file_upload" text COLLATE "pg_catalog"."default",
  "text_to_speech" text COLLATE "pg_catalog"."default",
  "created_by" uuid,
  "updated_by" uuid
)
;

-- ----------------------------
-- Table structure for apps
-- ----------------------------
DROP TABLE IF EXISTS "public"."apps";
CREATE TABLE "public"."apps" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "mode" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "icon" varchar(255) COLLATE "pg_catalog"."default",
  "icon_background" varchar(255) COLLATE "pg_catalog"."default",
  "app_model_config_id" uuid,
  "status" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'normal'::character varying,
  "enable_site" bool NOT NULL,
  "enable_api" bool NOT NULL,
  "api_rpm" int4 NOT NULL DEFAULT 0,
  "api_rph" int4 NOT NULL DEFAULT 0,
  "is_demo" bool NOT NULL DEFAULT false,
  "is_public" bool NOT NULL DEFAULT false,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "is_universal" bool NOT NULL DEFAULT false,
  "workflow_id" uuid,
  "description" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT ''::character varying,
  "tracing" text COLLATE "pg_catalog"."default",
  "max_active_requests" int4,
  "icon_type" varchar(255) COLLATE "pg_catalog"."default",
  "created_by" uuid,
  "updated_by" uuid,
  "use_icon_as_answer_icon" bool NOT NULL DEFAULT false
)
;

-- ----------------------------
-- Table structure for celery_taskmeta
-- ----------------------------
DROP TABLE IF EXISTS "public"."celery_taskmeta";
CREATE TABLE "public"."celery_taskmeta" (
  "id" int4 NOT NULL DEFAULT nextval('task_id_sequence'::regclass),
  "task_id" varchar(155) COLLATE "pg_catalog"."default",
  "status" varchar(50) COLLATE "pg_catalog"."default",
  "result" bytea,
  "date_done" timestamp(6),
  "traceback" text COLLATE "pg_catalog"."default",
  "name" varchar(155) COLLATE "pg_catalog"."default",
  "args" bytea,
  "kwargs" bytea,
  "worker" varchar(155) COLLATE "pg_catalog"."default",
  "retries" int4,
  "queue" varchar(155) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for celery_tasksetmeta
-- ----------------------------
DROP TABLE IF EXISTS "public"."celery_tasksetmeta";
CREATE TABLE "public"."celery_tasksetmeta" (
  "id" int4 NOT NULL DEFAULT nextval('taskset_id_sequence'::regclass),
  "taskset_id" varchar(155) COLLATE "pg_catalog"."default",
  "result" bytea,
  "date_done" timestamp(6)
)
;

-- ----------------------------
-- Table structure for child_chunks
-- ----------------------------
DROP TABLE IF EXISTS "public"."child_chunks";
CREATE TABLE "public"."child_chunks" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "dataset_id" uuid NOT NULL,
  "document_id" uuid NOT NULL,
  "segment_id" uuid NOT NULL,
  "position" int4 NOT NULL,
  "content" text COLLATE "pg_catalog"."default" NOT NULL,
  "word_count" int4 NOT NULL,
  "index_node_id" varchar(255) COLLATE "pg_catalog"."default",
  "index_node_hash" varchar(255) COLLATE "pg_catalog"."default",
  "type" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'automatic'::character varying,
  "created_by" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_by" uuid,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "indexing_at" timestamp(6),
  "completed_at" timestamp(6),
  "error" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for conversations
-- ----------------------------
DROP TABLE IF EXISTS "public"."conversations";
CREATE TABLE "public"."conversations" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "app_id" uuid NOT NULL,
  "app_model_config_id" uuid,
  "model_provider" varchar(255) COLLATE "pg_catalog"."default",
  "override_model_configs" text COLLATE "pg_catalog"."default",
  "model_id" varchar(255) COLLATE "pg_catalog"."default",
  "mode" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "summary" text COLLATE "pg_catalog"."default",
  "inputs" json NOT NULL,
  "introduction" text COLLATE "pg_catalog"."default",
  "system_instruction" text COLLATE "pg_catalog"."default",
  "system_instruction_tokens" int4 NOT NULL DEFAULT 0,
  "status" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "from_source" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "from_end_user_id" uuid,
  "from_account_id" uuid,
  "read_at" timestamp(6),
  "read_account_id" uuid,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "is_deleted" bool NOT NULL DEFAULT false,
  "invoke_from" varchar(255) COLLATE "pg_catalog"."default",
  "dialogue_count" int4 NOT NULL DEFAULT 0
)
;

-- ----------------------------
-- Table structure for data_source_api_key_auth_bindings
-- ----------------------------
DROP TABLE IF EXISTS "public"."data_source_api_key_auth_bindings";
CREATE TABLE "public"."data_source_api_key_auth_bindings" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "category" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "provider" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "credentials" text COLLATE "pg_catalog"."default",
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "disabled" bool DEFAULT false
)
;

-- ----------------------------
-- Table structure for data_source_oauth_bindings
-- ----------------------------
DROP TABLE IF EXISTS "public"."data_source_oauth_bindings";
CREATE TABLE "public"."data_source_oauth_bindings" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "access_token" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "provider" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "source_info" jsonb NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "disabled" bool DEFAULT false
)
;

-- ----------------------------
-- Table structure for dataset_auto_disable_logs
-- ----------------------------
DROP TABLE IF EXISTS "public"."dataset_auto_disable_logs";
CREATE TABLE "public"."dataset_auto_disable_logs" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "dataset_id" uuid NOT NULL,
  "document_id" uuid NOT NULL,
  "notified" bool NOT NULL DEFAULT false,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for dataset_collection_bindings
-- ----------------------------
DROP TABLE IF EXISTS "public"."dataset_collection_bindings";
CREATE TABLE "public"."dataset_collection_bindings" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "provider_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "model_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "collection_name" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "type" varchar(40) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'dataset'::character varying
)
;

-- ----------------------------
-- Table structure for dataset_keyword_tables
-- ----------------------------
DROP TABLE IF EXISTS "public"."dataset_keyword_tables";
CREATE TABLE "public"."dataset_keyword_tables" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "dataset_id" uuid NOT NULL,
  "keyword_table" text COLLATE "pg_catalog"."default" NOT NULL,
  "data_source_type" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'database'::character varying
)
;

-- ----------------------------
-- Table structure for dataset_metadata_bindings
-- ----------------------------
DROP TABLE IF EXISTS "public"."dataset_metadata_bindings";
CREATE TABLE "public"."dataset_metadata_bindings" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "dataset_id" uuid NOT NULL,
  "metadata_id" uuid NOT NULL,
  "document_id" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "created_by" uuid NOT NULL
)
;

-- ----------------------------
-- Table structure for dataset_metadatas
-- ----------------------------
DROP TABLE IF EXISTS "public"."dataset_metadatas";
CREATE TABLE "public"."dataset_metadatas" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "dataset_id" uuid NOT NULL,
  "type" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "created_by" uuid NOT NULL,
  "updated_by" uuid
)
;

-- ----------------------------
-- Table structure for dataset_permissions
-- ----------------------------
DROP TABLE IF EXISTS "public"."dataset_permissions";
CREATE TABLE "public"."dataset_permissions" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "dataset_id" uuid NOT NULL,
  "account_id" uuid NOT NULL,
  "has_permission" bool NOT NULL DEFAULT true,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "tenant_id" uuid NOT NULL
)
;

-- ----------------------------
-- Table structure for dataset_process_rules
-- ----------------------------
DROP TABLE IF EXISTS "public"."dataset_process_rules";
CREATE TABLE "public"."dataset_process_rules" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "dataset_id" uuid NOT NULL,
  "mode" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'automatic'::character varying,
  "rules" text COLLATE "pg_catalog"."default",
  "created_by" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for dataset_queries
-- ----------------------------
DROP TABLE IF EXISTS "public"."dataset_queries";
CREATE TABLE "public"."dataset_queries" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "dataset_id" uuid NOT NULL,
  "content" text COLLATE "pg_catalog"."default" NOT NULL,
  "source" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "source_app_id" uuid,
  "created_by_role" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "created_by" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Table structure for dataset_retriever_resources
-- ----------------------------
DROP TABLE IF EXISTS "public"."dataset_retriever_resources";
CREATE TABLE "public"."dataset_retriever_resources" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "message_id" uuid NOT NULL,
  "position" int4 NOT NULL,
  "dataset_id" uuid NOT NULL,
  "dataset_name" text COLLATE "pg_catalog"."default" NOT NULL,
  "document_id" uuid,
  "document_name" text COLLATE "pg_catalog"."default" NOT NULL,
  "data_source_type" text COLLATE "pg_catalog"."default",
  "segment_id" uuid,
  "score" float8,
  "content" text COLLATE "pg_catalog"."default" NOT NULL,
  "hit_count" int4,
  "word_count" int4,
  "segment_position" int4,
  "index_node_hash" text COLLATE "pg_catalog"."default",
  "retriever_from" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_by" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Table structure for datasets
-- ----------------------------
DROP TABLE IF EXISTS "public"."datasets";
CREATE TABLE "public"."datasets" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "provider" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'vendor'::character varying,
  "permission" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'only_me'::character varying,
  "data_source_type" varchar(255) COLLATE "pg_catalog"."default",
  "indexing_technique" varchar(255) COLLATE "pg_catalog"."default",
  "index_struct" text COLLATE "pg_catalog"."default",
  "created_by" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_by" uuid,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "embedding_model" varchar(255) COLLATE "pg_catalog"."default" DEFAULT 'text-embedding-ada-002'::character varying,
  "embedding_model_provider" varchar(255) COLLATE "pg_catalog"."default" DEFAULT 'openai'::character varying,
  "collection_binding_id" uuid,
  "retrieval_model" jsonb,
  "built_in_field_enabled" bool NOT NULL DEFAULT false
)
;

-- ----------------------------
-- Table structure for dify_setups
-- ----------------------------
DROP TABLE IF EXISTS "public"."dify_setups";
CREATE TABLE "public"."dify_setups" (
  "version" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "setup_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for document_segments
-- ----------------------------
DROP TABLE IF EXISTS "public"."document_segments";
CREATE TABLE "public"."document_segments" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "dataset_id" uuid NOT NULL,
  "document_id" uuid NOT NULL,
  "position" int4 NOT NULL,
  "content" text COLLATE "pg_catalog"."default" NOT NULL,
  "word_count" int4 NOT NULL,
  "tokens" int4 NOT NULL,
  "keywords" json,
  "index_node_id" varchar(255) COLLATE "pg_catalog"."default",
  "index_node_hash" varchar(255) COLLATE "pg_catalog"."default",
  "hit_count" int4 NOT NULL,
  "enabled" bool NOT NULL DEFAULT true,
  "disabled_at" timestamp(6),
  "disabled_by" uuid,
  "status" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'waiting'::character varying,
  "created_by" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "indexing_at" timestamp(6),
  "completed_at" timestamp(6),
  "error" text COLLATE "pg_catalog"."default",
  "stopped_at" timestamp(6),
  "answer" text COLLATE "pg_catalog"."default",
  "updated_by" uuid,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for documents
-- ----------------------------
DROP TABLE IF EXISTS "public"."documents";
CREATE TABLE "public"."documents" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "dataset_id" uuid NOT NULL,
  "position" int4 NOT NULL,
  "data_source_type" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "data_source_info" text COLLATE "pg_catalog"."default",
  "dataset_process_rule_id" uuid,
  "batch" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "created_from" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "created_by" uuid NOT NULL,
  "created_api_request_id" uuid,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "processing_started_at" timestamp(6),
  "file_id" text COLLATE "pg_catalog"."default",
  "word_count" int4,
  "parsing_completed_at" timestamp(6),
  "cleaning_completed_at" timestamp(6),
  "splitting_completed_at" timestamp(6),
  "tokens" int4,
  "indexing_latency" float8,
  "completed_at" timestamp(6),
  "is_paused" bool DEFAULT false,
  "paused_by" uuid,
  "paused_at" timestamp(6),
  "error" text COLLATE "pg_catalog"."default",
  "stopped_at" timestamp(6),
  "indexing_status" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'waiting'::character varying,
  "enabled" bool NOT NULL DEFAULT true,
  "disabled_at" timestamp(6),
  "disabled_by" uuid,
  "archived" bool NOT NULL DEFAULT false,
  "archived_reason" varchar(255) COLLATE "pg_catalog"."default",
  "archived_by" uuid,
  "archived_at" timestamp(6),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "doc_type" varchar(40) COLLATE "pg_catalog"."default",
  "doc_metadata" jsonb,
  "doc_form" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'text_model'::character varying,
  "doc_language" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for embeddings
-- ----------------------------
DROP TABLE IF EXISTS "public"."embeddings";
CREATE TABLE "public"."embeddings" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "hash" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "embedding" bytea NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "model_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'text-embedding-ada-002'::character varying,
  "provider_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT ''::character varying
)
;

-- ----------------------------
-- Table structure for end_users
-- ----------------------------
DROP TABLE IF EXISTS "public"."end_users";
CREATE TABLE "public"."end_users" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "app_id" uuid,
  "type" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "external_user_id" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "is_anonymous" bool NOT NULL DEFAULT true,
  "session_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for external_knowledge_apis
-- ----------------------------
DROP TABLE IF EXISTS "public"."external_knowledge_apis";
CREATE TABLE "public"."external_knowledge_apis" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "description" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "tenant_id" uuid NOT NULL,
  "settings" text COLLATE "pg_catalog"."default",
  "created_by" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_by" uuid,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for external_knowledge_bindings
-- ----------------------------
DROP TABLE IF EXISTS "public"."external_knowledge_bindings";
CREATE TABLE "public"."external_knowledge_bindings" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "external_knowledge_api_id" uuid NOT NULL,
  "dataset_id" uuid NOT NULL,
  "external_knowledge_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_by" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_by" uuid,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for installed_apps
-- ----------------------------
DROP TABLE IF EXISTS "public"."installed_apps";
CREATE TABLE "public"."installed_apps" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "app_id" uuid NOT NULL,
  "app_owner_tenant_id" uuid NOT NULL,
  "position" int4 NOT NULL,
  "is_pinned" bool NOT NULL DEFAULT false,
  "last_used_at" timestamp(6),
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for invitation_codes
-- ----------------------------
DROP TABLE IF EXISTS "public"."invitation_codes";
CREATE TABLE "public"."invitation_codes" (
  "id" int4 NOT NULL DEFAULT nextval('invitation_codes_id_seq'::regclass),
  "batch" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "code" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "status" varchar(16) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'unused'::character varying,
  "used_at" timestamp(6),
  "used_by_tenant_id" uuid,
  "used_by_account_id" uuid,
  "deprecated_at" timestamp(6),
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for load_balancing_model_configs
-- ----------------------------
DROP TABLE IF EXISTS "public"."load_balancing_model_configs";
CREATE TABLE "public"."load_balancing_model_configs" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "provider_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "model_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "model_type" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "encrypted_config" text COLLATE "pg_catalog"."default",
  "enabled" bool NOT NULL DEFAULT true,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for message_agent_thoughts
-- ----------------------------
DROP TABLE IF EXISTS "public"."message_agent_thoughts";
CREATE TABLE "public"."message_agent_thoughts" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "message_id" uuid NOT NULL,
  "message_chain_id" uuid,
  "position" int4 NOT NULL,
  "thought" text COLLATE "pg_catalog"."default",
  "tool" text COLLATE "pg_catalog"."default",
  "tool_input" text COLLATE "pg_catalog"."default",
  "observation" text COLLATE "pg_catalog"."default",
  "tool_process_data" text COLLATE "pg_catalog"."default",
  "message" text COLLATE "pg_catalog"."default",
  "message_token" int4,
  "message_unit_price" numeric,
  "answer" text COLLATE "pg_catalog"."default",
  "answer_token" int4,
  "answer_unit_price" numeric,
  "tokens" int4,
  "total_price" numeric,
  "currency" varchar COLLATE "pg_catalog"."default",
  "latency" float8,
  "created_by_role" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "created_by" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "message_price_unit" numeric(10,7) NOT NULL DEFAULT 0.001,
  "answer_price_unit" numeric(10,7) NOT NULL DEFAULT 0.001,
  "message_files" text COLLATE "pg_catalog"."default",
  "tool_labels_str" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT '{}'::text,
  "tool_meta_str" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT '{}'::text
)
;

-- ----------------------------
-- Table structure for message_annotations
-- ----------------------------
DROP TABLE IF EXISTS "public"."message_annotations";
CREATE TABLE "public"."message_annotations" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "app_id" uuid NOT NULL,
  "conversation_id" uuid,
  "message_id" uuid,
  "content" text COLLATE "pg_catalog"."default" NOT NULL,
  "account_id" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "question" text COLLATE "pg_catalog"."default",
  "hit_count" int4 NOT NULL DEFAULT 0
)
;

-- ----------------------------
-- Table structure for message_chains
-- ----------------------------
DROP TABLE IF EXISTS "public"."message_chains";
CREATE TABLE "public"."message_chains" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "message_id" uuid NOT NULL,
  "type" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "input" text COLLATE "pg_catalog"."default",
  "output" text COLLATE "pg_catalog"."default",
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Table structure for message_feedbacks
-- ----------------------------
DROP TABLE IF EXISTS "public"."message_feedbacks";
CREATE TABLE "public"."message_feedbacks" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "app_id" uuid NOT NULL,
  "conversation_id" uuid NOT NULL,
  "message_id" uuid NOT NULL,
  "rating" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "content" text COLLATE "pg_catalog"."default",
  "from_source" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "from_end_user_id" uuid,
  "from_account_id" uuid,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for message_files
-- ----------------------------
DROP TABLE IF EXISTS "public"."message_files";
CREATE TABLE "public"."message_files" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "message_id" uuid NOT NULL,
  "type" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "transfer_method" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "url" text COLLATE "pg_catalog"."default",
  "upload_file_id" uuid,
  "created_by_role" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "created_by" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "belongs_to" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for messages
-- ----------------------------
DROP TABLE IF EXISTS "public"."messages";
CREATE TABLE "public"."messages" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "app_id" uuid NOT NULL,
  "model_provider" varchar(255) COLLATE "pg_catalog"."default",
  "model_id" varchar(255) COLLATE "pg_catalog"."default",
  "override_model_configs" text COLLATE "pg_catalog"."default",
  "conversation_id" uuid NOT NULL,
  "inputs" json NOT NULL,
  "query" text COLLATE "pg_catalog"."default" NOT NULL,
  "message" json NOT NULL,
  "message_tokens" int4 NOT NULL DEFAULT 0,
  "message_unit_price" numeric(10,4) NOT NULL,
  "answer" text COLLATE "pg_catalog"."default" NOT NULL,
  "answer_tokens" int4 NOT NULL DEFAULT 0,
  "answer_unit_price" numeric(10,4) NOT NULL,
  "provider_response_latency" float8 NOT NULL DEFAULT 0,
  "total_price" numeric(10,7),
  "currency" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "from_source" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "from_end_user_id" uuid,
  "from_account_id" uuid,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "agent_based" bool NOT NULL DEFAULT false,
  "message_price_unit" numeric(10,7) NOT NULL DEFAULT 0.001,
  "answer_price_unit" numeric(10,7) NOT NULL DEFAULT 0.001,
  "workflow_run_id" uuid,
  "status" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'normal'::character varying,
  "error" text COLLATE "pg_catalog"."default",
  "message_metadata" text COLLATE "pg_catalog"."default",
  "invoke_from" varchar(255) COLLATE "pg_catalog"."default",
  "parent_message_id" uuid
)
;

-- ----------------------------
-- Table structure for operation_logs
-- ----------------------------
DROP TABLE IF EXISTS "public"."operation_logs";
CREATE TABLE "public"."operation_logs" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "account_id" uuid NOT NULL,
  "action" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "content" json,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "created_ip" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for pinned_conversations
-- ----------------------------
DROP TABLE IF EXISTS "public"."pinned_conversations";
CREATE TABLE "public"."pinned_conversations" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "app_id" uuid NOT NULL,
  "conversation_id" uuid NOT NULL,
  "created_by" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "created_by_role" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'end_user'::character varying
)
;

-- ----------------------------
-- Table structure for provider_model_settings
-- ----------------------------
DROP TABLE IF EXISTS "public"."provider_model_settings";
CREATE TABLE "public"."provider_model_settings" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "provider_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "model_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "model_type" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "enabled" bool NOT NULL DEFAULT true,
  "load_balancing_enabled" bool NOT NULL DEFAULT false,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for provider_models
-- ----------------------------
DROP TABLE IF EXISTS "public"."provider_models";
CREATE TABLE "public"."provider_models" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "provider_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "model_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "model_type" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "encrypted_config" text COLLATE "pg_catalog"."default",
  "is_valid" bool NOT NULL DEFAULT false,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for provider_orders
-- ----------------------------
DROP TABLE IF EXISTS "public"."provider_orders";
CREATE TABLE "public"."provider_orders" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "provider_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "account_id" uuid NOT NULL,
  "payment_product_id" varchar(191) COLLATE "pg_catalog"."default" NOT NULL,
  "payment_id" varchar(191) COLLATE "pg_catalog"."default",
  "transaction_id" varchar(191) COLLATE "pg_catalog"."default",
  "quantity" int4 NOT NULL DEFAULT 1,
  "currency" varchar(40) COLLATE "pg_catalog"."default",
  "total_amount" int4,
  "payment_status" varchar(40) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'wait_pay'::character varying,
  "paid_at" timestamp(6),
  "pay_failed_at" timestamp(6),
  "refunded_at" timestamp(6),
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for providers
-- ----------------------------
DROP TABLE IF EXISTS "public"."providers";
CREATE TABLE "public"."providers" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "provider_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "provider_type" varchar(40) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'custom'::character varying,
  "encrypted_config" text COLLATE "pg_catalog"."default",
  "is_valid" bool NOT NULL DEFAULT false,
  "last_used" timestamp(6),
  "quota_type" varchar(40) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "quota_limit" int8,
  "quota_used" int8,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for rate_limit_logs
-- ----------------------------
DROP TABLE IF EXISTS "public"."rate_limit_logs";
CREATE TABLE "public"."rate_limit_logs" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "subscription_plan" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "operation" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for recommended_apps
-- ----------------------------
DROP TABLE IF EXISTS "public"."recommended_apps";
CREATE TABLE "public"."recommended_apps" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "app_id" uuid NOT NULL,
  "description" json NOT NULL,
  "copyright" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "privacy_policy" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "category" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "position" int4 NOT NULL,
  "is_listed" bool NOT NULL,
  "install_count" int4 NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "language" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'en-US'::character varying,
  "custom_disclaimer" text COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Table structure for saved_messages
-- ----------------------------
DROP TABLE IF EXISTS "public"."saved_messages";
CREATE TABLE "public"."saved_messages" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "app_id" uuid NOT NULL,
  "message_id" uuid NOT NULL,
  "created_by" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "created_by_role" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'end_user'::character varying
)
;

-- ----------------------------
-- Table structure for sites
-- ----------------------------
DROP TABLE IF EXISTS "public"."sites";
CREATE TABLE "public"."sites" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "app_id" uuid NOT NULL,
  "title" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "icon" varchar(255) COLLATE "pg_catalog"."default",
  "icon_background" varchar(255) COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "default_language" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "copyright" varchar(255) COLLATE "pg_catalog"."default",
  "privacy_policy" varchar(255) COLLATE "pg_catalog"."default",
  "customize_domain" varchar(255) COLLATE "pg_catalog"."default",
  "customize_token_strategy" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "prompt_public" bool NOT NULL DEFAULT false,
  "status" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'normal'::character varying,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "custom_disclaimer" text COLLATE "pg_catalog"."default" NOT NULL,
  "show_workflow_steps" bool NOT NULL DEFAULT true,
  "chat_color_theme" varchar(255) COLLATE "pg_catalog"."default",
  "chat_color_theme_inverted" bool NOT NULL DEFAULT false,
  "icon_type" varchar(255) COLLATE "pg_catalog"."default",
  "created_by" uuid,
  "updated_by" uuid,
  "use_icon_as_answer_icon" bool NOT NULL DEFAULT false
)
;

-- ----------------------------
-- Table structure for tag_bindings
-- ----------------------------
DROP TABLE IF EXISTS "public"."tag_bindings";
CREATE TABLE "public"."tag_bindings" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid,
  "tag_id" uuid,
  "target_id" uuid,
  "created_by" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for tags
-- ----------------------------
DROP TABLE IF EXISTS "public"."tags";
CREATE TABLE "public"."tags" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid,
  "type" varchar(16) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "created_by" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for tenant_account_joins
-- ----------------------------
DROP TABLE IF EXISTS "public"."tenant_account_joins";
CREATE TABLE "public"."tenant_account_joins" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "account_id" uuid NOT NULL,
  "role" varchar(16) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'normal'::character varying,
  "invited_by" uuid,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "current" bool NOT NULL DEFAULT false
)
;

-- ----------------------------
-- Table structure for tenant_default_models
-- ----------------------------
DROP TABLE IF EXISTS "public"."tenant_default_models";
CREATE TABLE "public"."tenant_default_models" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "provider_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "model_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "model_type" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for tenant_preferred_model_providers
-- ----------------------------
DROP TABLE IF EXISTS "public"."tenant_preferred_model_providers";
CREATE TABLE "public"."tenant_preferred_model_providers" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "provider_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "preferred_provider_type" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for tenants
-- ----------------------------
DROP TABLE IF EXISTS "public"."tenants";
CREATE TABLE "public"."tenants" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "encrypt_public_key" text COLLATE "pg_catalog"."default",
  "plan" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'basic'::character varying,
  "status" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'normal'::character varying,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "custom_config" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for tidb_auth_bindings
-- ----------------------------
DROP TABLE IF EXISTS "public"."tidb_auth_bindings";
CREATE TABLE "public"."tidb_auth_bindings" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid,
  "cluster_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "cluster_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "active" bool NOT NULL DEFAULT false,
  "status" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'CREATING'::character varying,
  "account" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "password" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for tool_api_providers
-- ----------------------------
DROP TABLE IF EXISTS "public"."tool_api_providers";
CREATE TABLE "public"."tool_api_providers" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "schema" text COLLATE "pg_catalog"."default" NOT NULL,
  "schema_type_str" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" uuid NOT NULL,
  "tenant_id" uuid NOT NULL,
  "tools_str" text COLLATE "pg_catalog"."default" NOT NULL,
  "icon" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "credentials_str" text COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "privacy_policy" varchar(255) COLLATE "pg_catalog"."default",
  "custom_disclaimer" text COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Table structure for tool_builtin_providers
-- ----------------------------
DROP TABLE IF EXISTS "public"."tool_builtin_providers";
CREATE TABLE "public"."tool_builtin_providers" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid,
  "user_id" uuid NOT NULL,
  "provider" varchar(256) COLLATE "pg_catalog"."default" NOT NULL,
  "encrypted_credentials" text COLLATE "pg_catalog"."default",
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for tool_conversation_variables
-- ----------------------------
DROP TABLE IF EXISTS "public"."tool_conversation_variables";
CREATE TABLE "public"."tool_conversation_variables" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "user_id" uuid NOT NULL,
  "tenant_id" uuid NOT NULL,
  "conversation_id" uuid NOT NULL,
  "variables_str" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for tool_files
-- ----------------------------
DROP TABLE IF EXISTS "public"."tool_files";
CREATE TABLE "public"."tool_files" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "user_id" uuid NOT NULL,
  "tenant_id" uuid NOT NULL,
  "conversation_id" uuid,
  "file_key" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "mimetype" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "original_url" varchar(2048) COLLATE "pg_catalog"."default",
  "name" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "size" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tool_label_bindings
-- ----------------------------
DROP TABLE IF EXISTS "public"."tool_label_bindings";
CREATE TABLE "public"."tool_label_bindings" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tool_id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "tool_type" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "label_name" varchar(40) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Table structure for tool_model_invokes
-- ----------------------------
DROP TABLE IF EXISTS "public"."tool_model_invokes";
CREATE TABLE "public"."tool_model_invokes" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "user_id" uuid NOT NULL,
  "tenant_id" uuid NOT NULL,
  "provider" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "tool_type" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "tool_name" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "model_parameters" text COLLATE "pg_catalog"."default" NOT NULL,
  "prompt_messages" text COLLATE "pg_catalog"."default" NOT NULL,
  "model_response" text COLLATE "pg_catalog"."default" NOT NULL,
  "prompt_tokens" int4 NOT NULL DEFAULT 0,
  "answer_tokens" int4 NOT NULL DEFAULT 0,
  "answer_unit_price" numeric(10,4) NOT NULL,
  "answer_price_unit" numeric(10,7) NOT NULL DEFAULT 0.001,
  "provider_response_latency" float8 NOT NULL DEFAULT 0,
  "total_price" numeric(10,7),
  "currency" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for tool_published_apps
-- ----------------------------
DROP TABLE IF EXISTS "public"."tool_published_apps";
CREATE TABLE "public"."tool_published_apps" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "app_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "description" text COLLATE "pg_catalog"."default" NOT NULL,
  "llm_description" text COLLATE "pg_catalog"."default" NOT NULL,
  "query_description" text COLLATE "pg_catalog"."default" NOT NULL,
  "query_name" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "tool_name" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "author" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for tool_workflow_providers
-- ----------------------------
DROP TABLE IF EXISTS "public"."tool_workflow_providers";
CREATE TABLE "public"."tool_workflow_providers" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "icon" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "app_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "tenant_id" uuid NOT NULL,
  "description" text COLLATE "pg_catalog"."default" NOT NULL,
  "parameter_configuration" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT '[]'::text,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "privacy_policy" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "version" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT ''::character varying,
  "label" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT ''::character varying
)
;

-- ----------------------------
-- Table structure for trace_app_config
-- ----------------------------
DROP TABLE IF EXISTS "public"."trace_app_config";
CREATE TABLE "public"."trace_app_config" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "app_id" uuid NOT NULL,
  "tracing_provider" varchar(255) COLLATE "pg_catalog"."default",
  "tracing_config" json,
  "created_at" timestamp(6) NOT NULL DEFAULT now(),
  "updated_at" timestamp(6) NOT NULL DEFAULT now(),
  "is_active" bool NOT NULL DEFAULT true
)
;

-- ----------------------------
-- Table structure for upload_files
-- ----------------------------
DROP TABLE IF EXISTS "public"."upload_files";
CREATE TABLE "public"."upload_files" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "storage_type" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "key" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "size" int4 NOT NULL,
  "extension" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "mime_type" varchar(255) COLLATE "pg_catalog"."default",
  "created_by" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "used" bool NOT NULL DEFAULT false,
  "used_by" uuid,
  "used_at" timestamp(6),
  "hash" varchar(255) COLLATE "pg_catalog"."default",
  "created_by_role" varchar(255) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'account'::character varying,
  "source_url" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT ''::character varying
)
;

-- ----------------------------
-- Table structure for whitelists
-- ----------------------------
DROP TABLE IF EXISTS "public"."whitelists";
CREATE TABLE "public"."whitelists" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid,
  "category" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for workflow_app_logs
-- ----------------------------
DROP TABLE IF EXISTS "public"."workflow_app_logs";
CREATE TABLE "public"."workflow_app_logs" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "app_id" uuid NOT NULL,
  "workflow_id" uuid NOT NULL,
  "workflow_run_id" uuid NOT NULL,
  "created_from" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "created_by_role" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "created_by" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
)
;

-- ----------------------------
-- Table structure for workflow_conversation_variables
-- ----------------------------
DROP TABLE IF EXISTS "public"."workflow_conversation_variables";
CREATE TABLE "public"."workflow_conversation_variables" (
  "id" uuid NOT NULL,
  "conversation_id" uuid NOT NULL,
  "app_id" uuid NOT NULL,
  "data" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Table structure for workflow_draft_variables
-- ----------------------------
DROP TABLE IF EXISTS "public"."workflow_draft_variables";
CREATE TABLE "public"."workflow_draft_variables" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "app_id" uuid NOT NULL,
  "last_edited_at" timestamp(6),
  "node_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "description" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "selector" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "value_type" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "value" text COLLATE "pg_catalog"."default" NOT NULL,
  "visible" bool NOT NULL,
  "editable" bool NOT NULL,
  "node_execution_id" uuid
)
;

-- ----------------------------
-- Table structure for workflow_node_executions
-- ----------------------------
DROP TABLE IF EXISTS "public"."workflow_node_executions";
CREATE TABLE "public"."workflow_node_executions" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "app_id" uuid NOT NULL,
  "workflow_id" uuid NOT NULL,
  "triggered_from" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "workflow_run_id" uuid,
  "index" int4 NOT NULL,
  "predecessor_node_id" varchar(255) COLLATE "pg_catalog"."default",
  "node_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "node_type" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "title" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "inputs" text COLLATE "pg_catalog"."default",
  "process_data" text COLLATE "pg_catalog"."default",
  "outputs" text COLLATE "pg_catalog"."default",
  "status" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "error" text COLLATE "pg_catalog"."default",
  "elapsed_time" float8 NOT NULL DEFAULT 0,
  "execution_metadata" text COLLATE "pg_catalog"."default",
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "created_by_role" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "created_by" uuid NOT NULL,
  "finished_at" timestamp(6),
  "node_execution_id" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for workflow_runs
-- ----------------------------
DROP TABLE IF EXISTS "public"."workflow_runs";
CREATE TABLE "public"."workflow_runs" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "app_id" uuid NOT NULL,
  "workflow_id" uuid NOT NULL,
  "type" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "triggered_from" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "version" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "graph" text COLLATE "pg_catalog"."default",
  "inputs" text COLLATE "pg_catalog"."default",
  "status" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "outputs" text COLLATE "pg_catalog"."default",
  "error" text COLLATE "pg_catalog"."default",
  "elapsed_time" float8 NOT NULL DEFAULT 0,
  "total_tokens" int8 NOT NULL DEFAULT 0,
  "total_steps" int4 DEFAULT 0,
  "created_by_role" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "created_by" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "finished_at" timestamp(6),
  "exceptions_count" int4 DEFAULT 0
)
;

-- ----------------------------
-- Table structure for workflows
-- ----------------------------
DROP TABLE IF EXISTS "public"."workflows";
CREATE TABLE "public"."workflows" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "tenant_id" uuid NOT NULL,
  "app_id" uuid NOT NULL,
  "type" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "version" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "graph" text COLLATE "pg_catalog"."default" NOT NULL,
  "features" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_by" uuid NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  "updated_by" uuid,
  "updated_at" timestamp(6) NOT NULL,
  "environment_variables" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT '{}'::text,
  "conversation_variables" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT '{}'::text,
  "marked_name" varchar COLLATE "pg_catalog"."default" NOT NULL DEFAULT ''::character varying,
  "marked_comment" varchar COLLATE "pg_catalog"."default" NOT NULL DEFAULT ''::character varying
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
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."invitation_codes_id_seq"
OWNED BY "public"."invitation_codes"."id";
SELECT setval('"public"."invitation_codes_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
SELECT setval('"public"."task_id_sequence"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
SELECT setval('"public"."taskset_id_sequence"', 1, false);

-- ----------------------------
-- Uniques structure for table account_integrates
-- ----------------------------
ALTER TABLE "public"."account_integrates" ADD CONSTRAINT "unique_account_provider" UNIQUE ("account_id", "provider");
ALTER TABLE "public"."account_integrates" ADD CONSTRAINT "unique_provider_open_id" UNIQUE ("provider", "open_id");

-- ----------------------------
-- Primary Key structure for table account_integrates
-- ----------------------------
ALTER TABLE "public"."account_integrates" ADD CONSTRAINT "account_integrate_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table account_plugin_permissions
-- ----------------------------
ALTER TABLE "public"."account_plugin_permissions" ADD CONSTRAINT "unique_tenant_plugin" UNIQUE ("tenant_id");

-- ----------------------------
-- Primary Key structure for table account_plugin_permissions
-- ----------------------------
ALTER TABLE "public"."account_plugin_permissions" ADD CONSTRAINT "account_plugin_permission_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table accounts
-- ----------------------------
CREATE INDEX "account_email_idx_copy1_copy1" ON "public"."accounts" USING btree (
  "email" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table accounts
-- ----------------------------
ALTER TABLE "public"."accounts" ADD CONSTRAINT "accounts_copy1_pkey1" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table alembic_version
-- ----------------------------
ALTER TABLE "public"."alembic_version" ADD CONSTRAINT "alembic_version_pkc" PRIMARY KEY ("version_num");

-- ----------------------------
-- Indexes structure for table api_based_extensions
-- ----------------------------
CREATE INDEX "api_based_extension_tenant_idx" ON "public"."api_based_extensions" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table api_based_extensions
-- ----------------------------
ALTER TABLE "public"."api_based_extensions" ADD CONSTRAINT "api_based_extension_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table api_requests
-- ----------------------------
CREATE INDEX "api_request_token_idx" ON "public"."api_requests" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "api_token_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table api_requests
-- ----------------------------
ALTER TABLE "public"."api_requests" ADD CONSTRAINT "api_request_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table api_tokens
-- ----------------------------
CREATE INDEX "api_token_app_id_type_idx" ON "public"."api_tokens" USING btree (
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "api_token_tenant_idx" ON "public"."api_tokens" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "api_token_token_idx" ON "public"."api_tokens" USING btree (
  "token" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table api_tokens
-- ----------------------------
ALTER TABLE "public"."api_tokens" ADD CONSTRAINT "api_token_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table app_annotation_hit_histories
-- ----------------------------
CREATE INDEX "app_annotation_hit_histories_account_idx" ON "public"."app_annotation_hit_histories" USING btree (
  "account_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "app_annotation_hit_histories_annotation_idx" ON "public"."app_annotation_hit_histories" USING btree (
  "annotation_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "app_annotation_hit_histories_app_idx" ON "public"."app_annotation_hit_histories" USING btree (
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "app_annotation_hit_histories_message_idx" ON "public"."app_annotation_hit_histories" USING btree (
  "message_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table app_annotation_hit_histories
-- ----------------------------
ALTER TABLE "public"."app_annotation_hit_histories" ADD CONSTRAINT "app_annotation_hit_histories_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table app_annotation_settings
-- ----------------------------
CREATE INDEX "app_annotation_settings_app_idx" ON "public"."app_annotation_settings" USING btree (
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table app_annotation_settings
-- ----------------------------
ALTER TABLE "public"."app_annotation_settings" ADD CONSTRAINT "app_annotation_settings_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table app_dataset_joins
-- ----------------------------
CREATE INDEX "app_dataset_join_app_dataset_idx" ON "public"."app_dataset_joins" USING btree (
  "dataset_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table app_dataset_joins
-- ----------------------------
ALTER TABLE "public"."app_dataset_joins" ADD CONSTRAINT "app_dataset_join_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table app_model_configs
-- ----------------------------
CREATE INDEX "app_app_id_idx" ON "public"."app_model_configs" USING btree (
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table app_model_configs
-- ----------------------------
ALTER TABLE "public"."app_model_configs" ADD CONSTRAINT "app_model_config_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table apps
-- ----------------------------
CREATE INDEX "app_tenant_id_idx" ON "public"."apps" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table apps
-- ----------------------------
ALTER TABLE "public"."apps" ADD CONSTRAINT "app_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table celery_taskmeta
-- ----------------------------
ALTER TABLE "public"."celery_taskmeta" ADD CONSTRAINT "celery_taskmeta_task_id_key" UNIQUE ("task_id");

-- ----------------------------
-- Primary Key structure for table celery_taskmeta
-- ----------------------------
ALTER TABLE "public"."celery_taskmeta" ADD CONSTRAINT "celery_taskmeta_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table celery_tasksetmeta
-- ----------------------------
ALTER TABLE "public"."celery_tasksetmeta" ADD CONSTRAINT "celery_tasksetmeta_taskset_id_key" UNIQUE ("taskset_id");

-- ----------------------------
-- Primary Key structure for table celery_tasksetmeta
-- ----------------------------
ALTER TABLE "public"."celery_tasksetmeta" ADD CONSTRAINT "celery_tasksetmeta_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table child_chunks
-- ----------------------------
CREATE INDEX "child_chunk_dataset_id_idx" ON "public"."child_chunks" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "dataset_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "document_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "segment_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "index_node_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "child_chunks_node_idx" ON "public"."child_chunks" USING btree (
  "index_node_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "dataset_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "child_chunks_segment_idx" ON "public"."child_chunks" USING btree (
  "segment_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table child_chunks
-- ----------------------------
ALTER TABLE "public"."child_chunks" ADD CONSTRAINT "child_chunk_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table conversations
-- ----------------------------
CREATE INDEX "conversation_app_from_user_idx" ON "public"."conversations" USING btree (
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "from_source" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "from_end_user_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table conversations
-- ----------------------------
ALTER TABLE "public"."conversations" ADD CONSTRAINT "conversation_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table data_source_api_key_auth_bindings
-- ----------------------------
CREATE INDEX "data_source_api_key_auth_binding_provider_idx" ON "public"."data_source_api_key_auth_bindings" USING btree (
  "provider" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "data_source_api_key_auth_binding_tenant_id_idx" ON "public"."data_source_api_key_auth_bindings" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table data_source_api_key_auth_bindings
-- ----------------------------
ALTER TABLE "public"."data_source_api_key_auth_bindings" ADD CONSTRAINT "data_source_api_key_auth_binding_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table data_source_oauth_bindings
-- ----------------------------
CREATE INDEX "source_binding_tenant_id_idx" ON "public"."data_source_oauth_bindings" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "source_info_idx" ON "public"."data_source_oauth_bindings" USING gin (
  "source_info" "pg_catalog"."jsonb_ops"
);

-- ----------------------------
-- Primary Key structure for table data_source_oauth_bindings
-- ----------------------------
ALTER TABLE "public"."data_source_oauth_bindings" ADD CONSTRAINT "source_binding_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table dataset_auto_disable_logs
-- ----------------------------
CREATE INDEX "dataset_auto_disable_log_created_atx" ON "public"."dataset_auto_disable_logs" USING btree (
  "created_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "dataset_auto_disable_log_dataset_idx" ON "public"."dataset_auto_disable_logs" USING btree (
  "dataset_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "dataset_auto_disable_log_tenant_idx" ON "public"."dataset_auto_disable_logs" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table dataset_auto_disable_logs
-- ----------------------------
ALTER TABLE "public"."dataset_auto_disable_logs" ADD CONSTRAINT "dataset_auto_disable_log_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table dataset_collection_bindings
-- ----------------------------
CREATE INDEX "provider_model_name_idx" ON "public"."dataset_collection_bindings" USING btree (
  "provider_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "model_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table dataset_collection_bindings
-- ----------------------------
ALTER TABLE "public"."dataset_collection_bindings" ADD CONSTRAINT "dataset_collection_bindings_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table dataset_keyword_tables
-- ----------------------------
CREATE INDEX "dataset_keyword_table_dataset_id_idx" ON "public"."dataset_keyword_tables" USING btree (
  "dataset_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table dataset_keyword_tables
-- ----------------------------
ALTER TABLE "public"."dataset_keyword_tables" ADD CONSTRAINT "dataset_keyword_tables_dataset_id_key" UNIQUE ("dataset_id");

-- ----------------------------
-- Primary Key structure for table dataset_keyword_tables
-- ----------------------------
ALTER TABLE "public"."dataset_keyword_tables" ADD CONSTRAINT "dataset_keyword_table_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table dataset_metadata_bindings
-- ----------------------------
CREATE INDEX "dataset_metadata_binding_dataset_idx" ON "public"."dataset_metadata_bindings" USING btree (
  "dataset_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "dataset_metadata_binding_document_idx" ON "public"."dataset_metadata_bindings" USING btree (
  "document_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "dataset_metadata_binding_metadata_idx" ON "public"."dataset_metadata_bindings" USING btree (
  "metadata_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "dataset_metadata_binding_tenant_idx" ON "public"."dataset_metadata_bindings" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table dataset_metadata_bindings
-- ----------------------------
ALTER TABLE "public"."dataset_metadata_bindings" ADD CONSTRAINT "dataset_metadata_binding_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table dataset_metadatas
-- ----------------------------
CREATE INDEX "dataset_metadata_dataset_idx" ON "public"."dataset_metadatas" USING btree (
  "dataset_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "dataset_metadata_tenant_idx" ON "public"."dataset_metadatas" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table dataset_metadatas
-- ----------------------------
ALTER TABLE "public"."dataset_metadatas" ADD CONSTRAINT "dataset_metadata_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table dataset_permissions
-- ----------------------------
CREATE INDEX "idx_dataset_permissions_account_id" ON "public"."dataset_permissions" USING btree (
  "account_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "idx_dataset_permissions_dataset_id" ON "public"."dataset_permissions" USING btree (
  "dataset_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "idx_dataset_permissions_tenant_id" ON "public"."dataset_permissions" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table dataset_permissions
-- ----------------------------
ALTER TABLE "public"."dataset_permissions" ADD CONSTRAINT "dataset_permission_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table dataset_process_rules
-- ----------------------------
CREATE INDEX "dataset_process_rule_dataset_id_idx" ON "public"."dataset_process_rules" USING btree (
  "dataset_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table dataset_process_rules
-- ----------------------------
ALTER TABLE "public"."dataset_process_rules" ADD CONSTRAINT "dataset_process_rule_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table dataset_queries
-- ----------------------------
CREATE INDEX "dataset_query_dataset_id_idx" ON "public"."dataset_queries" USING btree (
  "dataset_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table dataset_queries
-- ----------------------------
ALTER TABLE "public"."dataset_queries" ADD CONSTRAINT "dataset_query_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table dataset_retriever_resources
-- ----------------------------
CREATE INDEX "dataset_retriever_resource_message_id_idx" ON "public"."dataset_retriever_resources" USING btree (
  "message_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table dataset_retriever_resources
-- ----------------------------
ALTER TABLE "public"."dataset_retriever_resources" ADD CONSTRAINT "dataset_retriever_resource_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table datasets
-- ----------------------------
CREATE INDEX "dataset_tenant_idx" ON "public"."datasets" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "retrieval_model_idx" ON "public"."datasets" USING gin (
  "retrieval_model" "pg_catalog"."jsonb_ops"
);

-- ----------------------------
-- Primary Key structure for table datasets
-- ----------------------------
ALTER TABLE "public"."datasets" ADD CONSTRAINT "dataset_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table dify_setups
-- ----------------------------
ALTER TABLE "public"."dify_setups" ADD CONSTRAINT "dify_setup_pkey" PRIMARY KEY ("version");

-- ----------------------------
-- Indexes structure for table document_segments
-- ----------------------------
CREATE INDEX "document_segment_dataset_id_idx" ON "public"."document_segments" USING btree (
  "dataset_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "document_segment_document_id_idx" ON "public"."document_segments" USING btree (
  "document_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "document_segment_node_dataset_idx" ON "public"."document_segments" USING btree (
  "index_node_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "dataset_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "document_segment_tenant_dataset_idx" ON "public"."document_segments" USING btree (
  "dataset_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "document_segment_tenant_document_idx" ON "public"."document_segments" USING btree (
  "document_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "document_segment_tenant_idx" ON "public"."document_segments" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table document_segments
-- ----------------------------
ALTER TABLE "public"."document_segments" ADD CONSTRAINT "document_segment_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table documents
-- ----------------------------
CREATE INDEX "document_dataset_id_idx" ON "public"."documents" USING btree (
  "dataset_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "document_is_paused_idx" ON "public"."documents" USING btree (
  "is_paused" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "document_metadata_idx" ON "public"."documents" USING gin (
  "doc_metadata" "pg_catalog"."jsonb_ops"
);
CREATE INDEX "document_tenant_idx" ON "public"."documents" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table documents
-- ----------------------------
ALTER TABLE "public"."documents" ADD CONSTRAINT "document_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table embeddings
-- ----------------------------
CREATE INDEX "created_at_idx" ON "public"."embeddings" USING btree (
  "created_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table embeddings
-- ----------------------------
ALTER TABLE "public"."embeddings" ADD CONSTRAINT "embedding_hash_idx" UNIQUE ("model_name", "hash", "provider_name");

-- ----------------------------
-- Primary Key structure for table embeddings
-- ----------------------------
ALTER TABLE "public"."embeddings" ADD CONSTRAINT "embedding_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table end_users
-- ----------------------------
CREATE INDEX "end_user_session_id_idx" ON "public"."end_users" USING btree (
  "session_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "end_user_tenant_session_id_idx" ON "public"."end_users" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "session_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table end_users
-- ----------------------------
ALTER TABLE "public"."end_users" ADD CONSTRAINT "end_user_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table external_knowledge_apis
-- ----------------------------
CREATE INDEX "external_knowledge_apis_name_idx" ON "public"."external_knowledge_apis" USING btree (
  "name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "external_knowledge_apis_tenant_idx" ON "public"."external_knowledge_apis" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table external_knowledge_apis
-- ----------------------------
ALTER TABLE "public"."external_knowledge_apis" ADD CONSTRAINT "external_knowledge_apis_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table external_knowledge_bindings
-- ----------------------------
CREATE INDEX "external_knowledge_bindings_dataset_idx" ON "public"."external_knowledge_bindings" USING btree (
  "dataset_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "external_knowledge_bindings_external_knowledge_api_idx" ON "public"."external_knowledge_bindings" USING btree (
  "external_knowledge_api_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "external_knowledge_bindings_external_knowledge_idx" ON "public"."external_knowledge_bindings" USING btree (
  "external_knowledge_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "external_knowledge_bindings_tenant_idx" ON "public"."external_knowledge_bindings" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table external_knowledge_bindings
-- ----------------------------
ALTER TABLE "public"."external_knowledge_bindings" ADD CONSTRAINT "external_knowledge_bindings_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table installed_apps
-- ----------------------------
CREATE INDEX "installed_app_app_id_idx" ON "public"."installed_apps" USING btree (
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "installed_app_tenant_id_idx" ON "public"."installed_apps" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table installed_apps
-- ----------------------------
ALTER TABLE "public"."installed_apps" ADD CONSTRAINT "unique_tenant_app" UNIQUE ("tenant_id", "app_id");

-- ----------------------------
-- Primary Key structure for table installed_apps
-- ----------------------------
ALTER TABLE "public"."installed_apps" ADD CONSTRAINT "installed_app_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table invitation_codes
-- ----------------------------
CREATE INDEX "invitation_codes_batch_idx" ON "public"."invitation_codes" USING btree (
  "batch" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "invitation_codes_code_idx" ON "public"."invitation_codes" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table invitation_codes
-- ----------------------------
ALTER TABLE "public"."invitation_codes" ADD CONSTRAINT "invitation_code_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table load_balancing_model_configs
-- ----------------------------
CREATE INDEX "load_balancing_model_config_tenant_provider_model_idx" ON "public"."load_balancing_model_configs" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "provider_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "model_type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table load_balancing_model_configs
-- ----------------------------
ALTER TABLE "public"."load_balancing_model_configs" ADD CONSTRAINT "load_balancing_model_config_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table message_agent_thoughts
-- ----------------------------
CREATE INDEX "message_agent_thought_message_chain_id_idx" ON "public"."message_agent_thoughts" USING btree (
  "message_chain_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "message_agent_thought_message_id_idx" ON "public"."message_agent_thoughts" USING btree (
  "message_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table message_agent_thoughts
-- ----------------------------
ALTER TABLE "public"."message_agent_thoughts" ADD CONSTRAINT "message_agent_thought_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table message_annotations
-- ----------------------------
CREATE INDEX "message_annotation_app_idx" ON "public"."message_annotations" USING btree (
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "message_annotation_conversation_idx" ON "public"."message_annotations" USING btree (
  "conversation_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "message_annotation_message_idx" ON "public"."message_annotations" USING btree (
  "message_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table message_annotations
-- ----------------------------
ALTER TABLE "public"."message_annotations" ADD CONSTRAINT "message_annotation_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table message_chains
-- ----------------------------
CREATE INDEX "message_chain_message_id_idx" ON "public"."message_chains" USING btree (
  "message_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table message_chains
-- ----------------------------
ALTER TABLE "public"."message_chains" ADD CONSTRAINT "message_chain_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table message_feedbacks
-- ----------------------------
CREATE INDEX "message_feedback_app_idx" ON "public"."message_feedbacks" USING btree (
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "message_feedback_conversation_idx" ON "public"."message_feedbacks" USING btree (
  "conversation_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "from_source" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "rating" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "message_feedback_message_idx" ON "public"."message_feedbacks" USING btree (
  "message_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "from_source" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table message_feedbacks
-- ----------------------------
ALTER TABLE "public"."message_feedbacks" ADD CONSTRAINT "message_feedback_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table message_files
-- ----------------------------
CREATE INDEX "message_file_created_by_idx" ON "public"."message_files" USING btree (
  "created_by" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "message_file_message_idx" ON "public"."message_files" USING btree (
  "message_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table message_files
-- ----------------------------
ALTER TABLE "public"."message_files" ADD CONSTRAINT "message_file_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table messages
-- ----------------------------
CREATE INDEX "message_account_idx" ON "public"."messages" USING btree (
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "from_source" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "from_account_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "message_app_id_idx" ON "public"."messages" USING btree (
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "created_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "message_conversation_id_idx" ON "public"."messages" USING btree (
  "conversation_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "message_created_at_idx" ON "public"."messages" USING btree (
  "created_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "message_end_user_idx" ON "public"."messages" USING btree (
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "from_source" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "from_end_user_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "message_workflow_run_id_idx" ON "public"."messages" USING btree (
  "conversation_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "workflow_run_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table messages
-- ----------------------------
ALTER TABLE "public"."messages" ADD CONSTRAINT "message_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table operation_logs
-- ----------------------------
CREATE INDEX "operation_log_account_action_idx" ON "public"."operation_logs" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "account_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "action" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table operation_logs
-- ----------------------------
ALTER TABLE "public"."operation_logs" ADD CONSTRAINT "operation_log_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table pinned_conversations
-- ----------------------------
CREATE INDEX "pinned_conversation_conversation_idx" ON "public"."pinned_conversations" USING btree (
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "conversation_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "created_by_role" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "created_by" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table pinned_conversations
-- ----------------------------
ALTER TABLE "public"."pinned_conversations" ADD CONSTRAINT "pinned_conversation_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table provider_model_settings
-- ----------------------------
CREATE INDEX "provider_model_setting_tenant_provider_model_idx" ON "public"."provider_model_settings" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "provider_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "model_type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table provider_model_settings
-- ----------------------------
ALTER TABLE "public"."provider_model_settings" ADD CONSTRAINT "provider_model_setting_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table provider_models
-- ----------------------------
CREATE INDEX "provider_model_tenant_id_provider_idx" ON "public"."provider_models" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "provider_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table provider_models
-- ----------------------------
ALTER TABLE "public"."provider_models" ADD CONSTRAINT "unique_provider_model_name" UNIQUE ("tenant_id", "provider_name", "model_name", "model_type");

-- ----------------------------
-- Primary Key structure for table provider_models
-- ----------------------------
ALTER TABLE "public"."provider_models" ADD CONSTRAINT "provider_model_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table provider_orders
-- ----------------------------
CREATE INDEX "provider_order_tenant_provider_idx" ON "public"."provider_orders" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "provider_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table provider_orders
-- ----------------------------
ALTER TABLE "public"."provider_orders" ADD CONSTRAINT "provider_order_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table providers
-- ----------------------------
CREATE INDEX "provider_tenant_id_provider_idx" ON "public"."providers" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "provider_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table providers
-- ----------------------------
ALTER TABLE "public"."providers" ADD CONSTRAINT "unique_provider_name_type_quota" UNIQUE ("tenant_id", "provider_name", "provider_type", "quota_type");

-- ----------------------------
-- Primary Key structure for table providers
-- ----------------------------
ALTER TABLE "public"."providers" ADD CONSTRAINT "provider_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table rate_limit_logs
-- ----------------------------
CREATE INDEX "rate_limit_log_operation_idx" ON "public"."rate_limit_logs" USING btree (
  "operation" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "rate_limit_log_tenant_idx" ON "public"."rate_limit_logs" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table rate_limit_logs
-- ----------------------------
ALTER TABLE "public"."rate_limit_logs" ADD CONSTRAINT "rate_limit_log_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table recommended_apps
-- ----------------------------
CREATE INDEX "recommended_app_app_id_idx" ON "public"."recommended_apps" USING btree (
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "recommended_app_is_listed_idx" ON "public"."recommended_apps" USING btree (
  "is_listed" "pg_catalog"."bool_ops" ASC NULLS LAST,
  "language" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table recommended_apps
-- ----------------------------
ALTER TABLE "public"."recommended_apps" ADD CONSTRAINT "recommended_app_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table saved_messages
-- ----------------------------
CREATE INDEX "saved_message_message_idx" ON "public"."saved_messages" USING btree (
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "message_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "created_by_role" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "created_by" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table saved_messages
-- ----------------------------
ALTER TABLE "public"."saved_messages" ADD CONSTRAINT "saved_message_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table sites
-- ----------------------------
CREATE INDEX "site_app_id_idx" ON "public"."sites" USING btree (
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "site_code_idx" ON "public"."sites" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table sites
-- ----------------------------
ALTER TABLE "public"."sites" ADD CONSTRAINT "site_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table tag_bindings
-- ----------------------------
CREATE INDEX "tag_bind_tag_id_idx" ON "public"."tag_bindings" USING btree (
  "tag_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "tag_bind_target_id_idx" ON "public"."tag_bindings" USING btree (
  "target_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tag_bindings
-- ----------------------------
ALTER TABLE "public"."tag_bindings" ADD CONSTRAINT "tag_binding_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table tags
-- ----------------------------
CREATE INDEX "tag_name_idx" ON "public"."tags" USING btree (
  "name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "tag_type_idx" ON "public"."tags" USING btree (
  "type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tags
-- ----------------------------
ALTER TABLE "public"."tags" ADD CONSTRAINT "tag_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table tenant_account_joins
-- ----------------------------
CREATE INDEX "tenant_account_join_account_id_idx_copy1" ON "public"."tenant_account_joins" USING btree (
  "account_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "tenant_account_join_tenant_id_idx_copy1" ON "public"."tenant_account_joins" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table tenant_account_joins
-- ----------------------------
ALTER TABLE "public"."tenant_account_joins" ADD CONSTRAINT "tenant_account_joins_copy1_tenant_id_account_id_key" UNIQUE ("tenant_id", "account_id");

-- ----------------------------
-- Primary Key structure for table tenant_account_joins
-- ----------------------------
ALTER TABLE "public"."tenant_account_joins" ADD CONSTRAINT "tenant_account_joins_copy1_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table tenant_default_models
-- ----------------------------
CREATE INDEX "tenant_default_model_tenant_id_provider_type_idx" ON "public"."tenant_default_models" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "provider_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "model_type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tenant_default_models
-- ----------------------------
ALTER TABLE "public"."tenant_default_models" ADD CONSTRAINT "tenant_default_model_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table tenant_preferred_model_providers
-- ----------------------------
CREATE INDEX "tenant_preferred_model_provider_tenant_provider_idx" ON "public"."tenant_preferred_model_providers" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "provider_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tenant_preferred_model_providers
-- ----------------------------
ALTER TABLE "public"."tenant_preferred_model_providers" ADD CONSTRAINT "tenant_preferred_model_provider_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table tenants
-- ----------------------------
ALTER TABLE "public"."tenants" ADD CONSTRAINT "tenant_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table tidb_auth_bindings
-- ----------------------------
CREATE INDEX "tidb_auth_bindings_active_idx" ON "public"."tidb_auth_bindings" USING btree (
  "active" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "tidb_auth_bindings_created_at_idx" ON "public"."tidb_auth_bindings" USING btree (
  "created_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "tidb_auth_bindings_status_idx" ON "public"."tidb_auth_bindings" USING btree (
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "tidb_auth_bindings_tenant_idx" ON "public"."tidb_auth_bindings" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tidb_auth_bindings
-- ----------------------------
ALTER TABLE "public"."tidb_auth_bindings" ADD CONSTRAINT "tidb_auth_bindings_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table tool_api_providers
-- ----------------------------
ALTER TABLE "public"."tool_api_providers" ADD CONSTRAINT "unique_api_tool_provider" UNIQUE ("name", "tenant_id");

-- ----------------------------
-- Primary Key structure for table tool_api_providers
-- ----------------------------
ALTER TABLE "public"."tool_api_providers" ADD CONSTRAINT "tool_api_provider_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table tool_builtin_providers
-- ----------------------------
ALTER TABLE "public"."tool_builtin_providers" ADD CONSTRAINT "unique_builtin_tool_provider" UNIQUE ("tenant_id", "provider");

-- ----------------------------
-- Primary Key structure for table tool_builtin_providers
-- ----------------------------
ALTER TABLE "public"."tool_builtin_providers" ADD CONSTRAINT "tool_builtin_provider_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table tool_conversation_variables
-- ----------------------------
CREATE INDEX "conversation_id_idx" ON "public"."tool_conversation_variables" USING btree (
  "conversation_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "user_id_idx" ON "public"."tool_conversation_variables" USING btree (
  "user_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tool_conversation_variables
-- ----------------------------
ALTER TABLE "public"."tool_conversation_variables" ADD CONSTRAINT "tool_conversation_variables_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table tool_files
-- ----------------------------
CREATE INDEX "tool_file_conversation_id_idx" ON "public"."tool_files" USING btree (
  "conversation_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tool_files
-- ----------------------------
ALTER TABLE "public"."tool_files" ADD CONSTRAINT "tool_file_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table tool_label_bindings
-- ----------------------------
ALTER TABLE "public"."tool_label_bindings" ADD CONSTRAINT "unique_tool_label_bind" UNIQUE ("tool_id", "label_name");

-- ----------------------------
-- Primary Key structure for table tool_label_bindings
-- ----------------------------
ALTER TABLE "public"."tool_label_bindings" ADD CONSTRAINT "tool_label_bind_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table tool_model_invokes
-- ----------------------------
ALTER TABLE "public"."tool_model_invokes" ADD CONSTRAINT "tool_model_invoke_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table tool_published_apps
-- ----------------------------
ALTER TABLE "public"."tool_published_apps" ADD CONSTRAINT "unique_published_app_tool" UNIQUE ("app_id", "user_id");

-- ----------------------------
-- Primary Key structure for table tool_published_apps
-- ----------------------------
ALTER TABLE "public"."tool_published_apps" ADD CONSTRAINT "published_app_tool_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table tool_workflow_providers
-- ----------------------------
ALTER TABLE "public"."tool_workflow_providers" ADD CONSTRAINT "unique_workflow_tool_provider_app_id" UNIQUE ("tenant_id", "app_id");
ALTER TABLE "public"."tool_workflow_providers" ADD CONSTRAINT "unique_workflow_tool_provider" UNIQUE ("name", "tenant_id");

-- ----------------------------
-- Primary Key structure for table tool_workflow_providers
-- ----------------------------
ALTER TABLE "public"."tool_workflow_providers" ADD CONSTRAINT "tool_workflow_provider_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table trace_app_config
-- ----------------------------
CREATE INDEX "trace_app_config_app_id_idx" ON "public"."trace_app_config" USING btree (
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table trace_app_config
-- ----------------------------
ALTER TABLE "public"."trace_app_config" ADD CONSTRAINT "trace_app_config_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table upload_files
-- ----------------------------
CREATE INDEX "upload_file_tenant_idx" ON "public"."upload_files" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table upload_files
-- ----------------------------
ALTER TABLE "public"."upload_files" ADD CONSTRAINT "upload_file_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table whitelists
-- ----------------------------
CREATE INDEX "whitelists_tenant_idx" ON "public"."whitelists" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table whitelists
-- ----------------------------
ALTER TABLE "public"."whitelists" ADD CONSTRAINT "whitelists_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table workflow_app_logs
-- ----------------------------
CREATE INDEX "workflow_app_log_app_idx" ON "public"."workflow_app_logs" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table workflow_app_logs
-- ----------------------------
ALTER TABLE "public"."workflow_app_logs" ADD CONSTRAINT "workflow_app_log_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table workflow_conversation_variables
-- ----------------------------
CREATE INDEX "workflow_conversation_variables_app_id_idx" ON "public"."workflow_conversation_variables" USING btree (
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "workflow_conversation_variables_conversation_id_idx" ON "public"."workflow_conversation_variables" USING btree (
  "conversation_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "workflow_conversation_variables_created_at_idx" ON "public"."workflow_conversation_variables" USING btree (
  "created_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table workflow_conversation_variables
-- ----------------------------
ALTER TABLE "public"."workflow_conversation_variables" ADD CONSTRAINT "workflow__conversation_variables_pkey" PRIMARY KEY ("id", "conversation_id");

-- ----------------------------
-- Uniques structure for table workflow_draft_variables
-- ----------------------------
ALTER TABLE "public"."workflow_draft_variables" ADD CONSTRAINT "workflow_draft_variables_app_id_key" UNIQUE ("app_id", "node_id", "name");

-- ----------------------------
-- Primary Key structure for table workflow_draft_variables
-- ----------------------------
ALTER TABLE "public"."workflow_draft_variables" ADD CONSTRAINT "workflow_draft_variables_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table workflow_node_executions
-- ----------------------------
CREATE INDEX "workflow_node_execution_id_idx" ON "public"."workflow_node_executions" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "workflow_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "triggered_from" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "node_execution_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "workflow_node_execution_node_run_idx" ON "public"."workflow_node_executions" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "workflow_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "triggered_from" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "node_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "workflow_node_execution_workflow_run_idx" ON "public"."workflow_node_executions" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "workflow_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "triggered_from" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "workflow_run_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "workflow_node_executions_tenant_id_idx" ON "public"."workflow_node_executions" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "workflow_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "node_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "created_at" "pg_catalog"."timestamp_ops" DESC NULLS FIRST
);

-- ----------------------------
-- Primary Key structure for table workflow_node_executions
-- ----------------------------
ALTER TABLE "public"."workflow_node_executions" ADD CONSTRAINT "workflow_node_execution_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table workflow_runs
-- ----------------------------
CREATE INDEX "workflow_run_triggerd_from_idx" ON "public"."workflow_runs" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "triggered_from" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table workflow_runs
-- ----------------------------
ALTER TABLE "public"."workflow_runs" ADD CONSTRAINT "workflow_run_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table workflows
-- ----------------------------
CREATE INDEX "workflow_version_idx" ON "public"."workflows" USING btree (
  "tenant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "app_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "version" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table workflows
-- ----------------------------
ALTER TABLE "public"."workflows" ADD CONSTRAINT "workflow_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Keys structure for table tool_published_apps
-- ----------------------------
ALTER TABLE "public"."tool_published_apps" ADD CONSTRAINT "tool_published_apps_app_id_fkey" FOREIGN KEY ("app_id") REFERENCES "public"."apps" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
