/*
 Navicat Premium Dump SQL

 Source Server         : 192.168.53.133_Livechat
 Source Server Type    : MySQL
 Source Server Version : 50744 (5.7.44-log)
 Source Host           : 192.168.53.133:3306
 Source Schema         : olivechat

 Target Server Type    : MySQL
 Target Server Version : 50744 (5.7.44-log)
 File Encoding         : 65001

 Date: 28/08/2025 10:35:43
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for v2_admin
-- ----------------------------
DROP TABLE IF EXISTS `v2_admin`;
CREATE TABLE `v2_admin`  (
  `admin_id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_name` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `admin_password` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '上次登录时间',
  PRIMARY KEY (`admin_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_black_list
-- ----------------------------
DROP TABLE IF EXISTS `v2_black_list`;
CREATE TABLE `v2_black_list`  (
  `list_id` int(11) NOT NULL AUTO_INCREMENT,
  `seller_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商户标识',
  `ip` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '黑名单ip',
  `oper_kefu_id` int(11) NOT NULL COMMENT '操作者id',
  `customer_name` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `customer_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `customer_real_name` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `add_time` datetime NULL DEFAULT NULL COMMENT '添加时间',
  PRIMARY KEY (`list_id`) USING BTREE,
  INDEX `seller_code,ip`(`seller_code`, `ip`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_chat_log
-- ----------------------------
DROP TABLE IF EXISTS `v2_chat_log`;
CREATE TABLE `v2_chat_log`  (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志id',
  `from_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '网页用户随机编号(仅为记录参考记录)',
  `from_name` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '发送者名称',
  `from_avatar` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '发送者头像',
  `to_id` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '接收方',
  `to_name` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '接受者名称',
  `seller_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '所属 商户标识',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '发送的内容',
  `read_flag` tinyint(1) NULL DEFAULT 1 COMMENT '是否已读 1 未读 2 已读 3 发送失败',
  `valid` tinyint(1) NULL DEFAULT 1 COMMENT '是否有效 0 无效  1 有效',
  `create_time` datetime NOT NULL COMMENT '记录时间',
  PRIMARY KEY (`log_id`) USING BTREE,
  INDEX `from_id`(`from_id`) USING BTREE,
  INDEX `to_id`(`to_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 793 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_customer
-- ----------------------------
DROP TABLE IF EXISTS `v2_customer`;
CREATE TABLE `v2_customer`  (
  `cid` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '访客id',
  `customer_name` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '访客名称',
  `customer_avatar` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '访客头像',
  `customer_ip` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '访客ip',
  `seller_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '咨询商家的标识',
  `pre_kefu_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '上次服务的客服标识',
  `client_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客户端标识',
  `online_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '0 离线 1 在线',
  `create_time` datetime NOT NULL COMMENT '访问时间',
  `protocol` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'ws' COMMENT '接入协议',
  `province` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '访客所在省份',
  `city` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '访客所在城市',
  PRIMARY KEY (`cid`) USING BTREE,
  INDEX `visiter`(`customer_id`) USING BTREE,
  INDEX `time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 477 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_customer_info
-- ----------------------------
DROP TABLE IF EXISTS `v2_customer_info`;
CREATE TABLE `v2_customer_info`  (
  `info_id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `seller_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `search_engines` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '搜索引擎',
  `from_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `real_name` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '真实名称',
  `email` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `remark` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `user_agent` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '访客的设备头信息',
  `dify_appcode` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'dify的appcode',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `customer_id`(`customer_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 477 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_customer_queue
-- ----------------------------
DROP TABLE IF EXISTS `v2_customer_queue`;
CREATE TABLE `v2_customer_queue`  (
  `qid` int(11) NOT NULL AUTO_INCREMENT COMMENT '队列id',
  `customer_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '访客id',
  `customer_name` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '访客名称',
  `customer_avatar` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '访客头像',
  `customer_ip` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '访客ip',
  `seller_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '咨询商家的标识',
  `client_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客户端标识',
  `create_time` datetime NOT NULL COMMENT '访问时间',
  PRIMARY KEY (`qid`) USING BTREE,
  UNIQUE INDEX `id`(`customer_id`) USING BTREE,
  INDEX `visiter`(`customer_id`) USING BTREE,
  INDEX `time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_customer_service_log
-- ----------------------------
DROP TABLE IF EXISTS `v2_customer_service_log`;
CREATE TABLE `v2_customer_service_log`  (
  `service_log_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '服务编号',
  `customer_id` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '访客id',
  `client_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '访客的客户端标识',
  `customer_name` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '访客名称',
  `customer_avatar` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '访客头像',
  `customer_ip` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '访客的ip',
  `kefu_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '接待的客服标识',
  `seller_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客服所属的商户标识',
  `start_time` datetime NOT NULL COMMENT '开始服务时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束服务时间',
  `protocol` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'ws' COMMENT '来自什么类型的连接',
  PRIMARY KEY (`service_log_id`) USING BTREE,
  INDEX `user_id,client_id`(`customer_id`, `client_id`) USING BTREE,
  INDEX `kf_id,start_time,end_time`(`kefu_code`, `start_time`, `end_time`) USING BTREE,
  INDEX `idx_search`(`seller_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2159 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_group
-- ----------------------------
DROP TABLE IF EXISTS `v2_group`;
CREATE TABLE `v2_group`  (
  `group_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '业务组id',
  `group_name` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '业务组名称',
  `group_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '业务组状态 0 禁用 1 激活',
  `first_service` tinyint(1) NOT NULL DEFAULT 0 COMMENT '会否前置服务组 0 不是 1 是',
  `seller_id` int(11) NOT NULL COMMENT '所属商户id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`group_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_kefu
-- ----------------------------
DROP TABLE IF EXISTS `v2_kefu`;
CREATE TABLE `v2_kefu`  (
  `kefu_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '客服id',
  `kefu_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客服唯一标识',
  `kefu_name` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客服名称',
  `kefu_avatar` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客服头像',
  `kefu_password` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客服密码',
  `seller_id` int(11) NOT NULL COMMENT '所属商家id',
  `seller_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '所属商家标识',
  `group_id` int(11) NOT NULL COMMENT '所属业务组id',
  `max_service_num` int(11) NOT NULL DEFAULT 10 COMMENT '最大服务人数',
  `kefu_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '客服状态 0 禁用 1 激活',
  `online_status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '在线状态 0 离线 1 在线',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最近登录时间',
  `kefy_type` int(2) NOT NULL DEFAULT 0 COMMENT '客服类型：0：人工，1：机器人',
  `greetings` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '机器人问候语',
  PRIMARY KEY (`kefu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_kefu_distribution
-- ----------------------------
DROP TABLE IF EXISTS `v2_kefu_distribution`;
CREATE TABLE `v2_kefu_distribution`  (
  `distribute_id` int(11) NOT NULL AUTO_INCREMENT,
  `seller_id` int(11) NOT NULL COMMENT '商户的id',
  `kefu_map` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '待分配的客服数组',
  PRIMARY KEY (`distribute_id`) USING BTREE,
  INDEX `idx_seller_id`(`seller_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_kefu_web
-- ----------------------------
DROP TABLE IF EXISTS `v2_kefu_web`;
CREATE TABLE `v2_kefu_web`  (
  `kf_web_id` int(11) NOT NULL AUTO_INCREMENT,
  `seller_id` int(11) NULL DEFAULT NULL COMMENT '站点ID',
  `kf_id` int(11) NOT NULL COMMENT '客服ID',
  `web_id` int(11) NULL DEFAULT NULL COMMENT 'WEBID',
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `dify_apps_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'dify apps表ID',
  PRIMARY KEY (`kf_web_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 127 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '客服-站点对应表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Table structure for v2_kefu_word
-- ----------------------------
DROP TABLE IF EXISTS `v2_kefu_word`;
CREATE TABLE `v2_kefu_word`  (
  `word_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '简略标题',
  `word` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '常用语内容',
  `kefu_id` int(11) NOT NULL COMMENT '所属客服的id',
  `cate_id` int(11) NOT NULL COMMENT '所属分类id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`word_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_kefu_word_cate
-- ----------------------------
DROP TABLE IF EXISTS `v2_kefu_word_cate`;
CREATE TABLE `v2_kefu_word_cate`  (
  `cate_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类id',
  `cate_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类名称',
  `kefu_id` int(11) NULL DEFAULT NULL COMMENT '所属客服的id',
  `seller_id` int(11) NULL DEFAULT NULL COMMENT '所属商户的id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`cate_id`) USING BTREE,
  INDEX `idx_kf_seller`(`kefu_id`, `seller_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_knowledge_store
-- ----------------------------
DROP TABLE IF EXISTS `v2_knowledge_store`;
CREATE TABLE `v2_knowledge_store`  (
  `knowledge_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '知识库id',
  `question` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '问题',
  `answer` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '答案',
  `cate_id` int(11) NULL DEFAULT 1 COMMENT '所属业务分类id',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态 1 启用  2 禁用',
  `seller_id` int(11) NOT NULL COMMENT '所属商户id',
  `useful_num` int(11) NULL DEFAULT 0 COMMENT '被标记有用数量',
  `useless_num` int(11) NULL DEFAULT 0 COMMENT '被标记无用次数',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`knowledge_id`) USING BTREE,
  INDEX `sellerid`(`seller_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_leave_msg
-- ----------------------------
DROP TABLE IF EXISTS `v2_leave_msg`;
CREATE TABLE `v2_leave_msg`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '留言人名称',
  `phone` char(11) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '留言人手机号',
  `content` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '留言内容',
  `seller_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '所属商户',
  `add_time` int(10) NOT NULL COMMENT '留言时间',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '留言是否已读 1 未读 2 已读',
  `update_time` datetime NULL DEFAULT NULL COMMENT '已读处理时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 94 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_login_log
-- ----------------------------
DROP TABLE IF EXISTS `v2_login_log`;
CREATE TABLE `v2_login_log`  (
  `log_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '日志id',
  `login_user` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '登录用户',
  `login_ip` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '登录ip',
  `login_area` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '登录地区',
  `login_user_agent` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '登录设备头',
  `login_time` datetime NULL DEFAULT NULL COMMENT '登录时间',
  `login_status` tinyint(1) NULL DEFAULT 1 COMMENT '登录状态 1 成功 2 失败',
  PRIMARY KEY (`log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 88 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_now_service
-- ----------------------------
DROP TABLE IF EXISTS `v2_now_service`;
CREATE TABLE `v2_now_service`  (
  `service_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `kefu_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客服标识',
  `customer_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '访客id',
  `client_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '访客的客户端id',
  `create_time` int(10) NOT NULL COMMENT '记录添加时间',
  `service_log_id` int(11) NULL DEFAULT 0 COMMENT '当前服务的日志id',
  PRIMARY KEY (`service_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 594 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_operate_log
-- ----------------------------
DROP TABLE IF EXISTS `v2_operate_log`;
CREATE TABLE `v2_operate_log`  (
  `log_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '操作日志id',
  `operator` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '操作用户',
  `operator_ip` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '操作者ip',
  `operate_method` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '操作方法',
  `operate_title` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '操作简述',
  `operate_desc` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作描述',
  `operate_time` datetime NOT NULL COMMENT '操作时间',
  PRIMARY KEY (`log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 89 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_praise
-- ----------------------------
DROP TABLE IF EXISTS `v2_praise`;
CREATE TABLE `v2_praise`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '访客标识',
  `kefu_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客服标识',
  `seller_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商户的标识',
  `service_log_id` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '本次会话标识',
  `star` int(2) NOT NULL DEFAULT 0 COMMENT '分数',
  `add_time` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `seller`(`seller_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_question
-- ----------------------------
DROP TABLE IF EXISTS `v2_question`;
CREATE TABLE `v2_question`  (
  `question_id` int(11) NOT NULL AUTO_INCREMENT,
  `seller_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '所属商户的标识',
  `question` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '常见问题',
  `answer` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '答案',
  `add_time` datetime NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`question_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_question_conf
-- ----------------------------
DROP TABLE IF EXISTS `v2_question_conf`;
CREATE TABLE `v2_question_conf`  (
  `question_conf_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '常见问题设置id',
  `question_title` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '猜您想问：' COMMENT '常见问题标题',
  `seller_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '所属商户标识',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 启动 0 禁用',
  PRIMARY KEY (`question_conf_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_seller
-- ----------------------------
DROP TABLE IF EXISTS `v2_seller`;
CREATE TABLE `v2_seller`  (
  `seller_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商户id',
  `dbim_meb_id` bigint(20) NOT NULL COMMENT 'dbim会员ID',
  `seller_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商户唯一标识',
  `seller_name` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商户名',
  `seller_email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `seller_password` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商户登录密码',
  `seller_avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商户头像',
  `seller_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '商户状态 0 禁用 1 激活',
  `access_url` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '接入域名',
  `valid_time` datetime NULL DEFAULT NULL COMMENT '有效期',
  `max_kefu_num` int(5) NULL DEFAULT 1 COMMENT '最大客服数',
  `max_group_num` int(5) NULL DEFAULT 1 COMMENT '最大分组数',
  `create_index_flag` tinyint(1) NULL DEFAULT 1 COMMENT '是否创建了 es索引 1:未创建 2:已创建',
  `goldcoinNum` float(11, 2) NOT NULL DEFAULT 0.00 COMMENT '总剩余金币数量',
  `tokensNum` bigint(20) NOT NULL DEFAULT 0 COMMENT '总剩余Tokens数量',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `merchantversion_Id` int(11) NOT NULL DEFAULT 1 COMMENT '商家角色版本ID：1、试用版、2、商业版',
  PRIMARY KEY (`seller_id`) USING BTREE,
  UNIQUE INDEX `seller_code`(`seller_code`) USING BTREE,
  UNIQUE INDEX `uk_dbim_meb_id`(`dbim_meb_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 62 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_seller_box_style
-- ----------------------------
DROP TABLE IF EXISTS `v2_seller_box_style`;
CREATE TABLE `v2_seller_box_style`  (
  `box_style_id` int(11) NOT NULL AUTO_INCREMENT,
  `style_type` tinyint(1) NULL DEFAULT 1 COMMENT '按钮样式 1 底部 2 侧边',
  `box_color` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '弹层和按钮的颜色',
  `box_icon` int(3) NULL DEFAULT 1 COMMENT '按钮图标',
  `box_title` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '按钮显示咨询字样',
  `box_margin` int(4) NULL DEFAULT NULL COMMENT '按钮边距',
  `seller_id` int(11) NULL DEFAULT NULL COMMENT '关联的商户id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建 时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`box_style_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_seller_web
-- ----------------------------
DROP TABLE IF EXISTS `v2_seller_web`;
CREATE TABLE `v2_seller_web`  (
  `web_id` int(11) NOT NULL AUTO_INCREMENT,
  `seller_id` int(11) NOT NULL COMMENT '所属商家ID',
  `web_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `web_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '站点名称',
  `web_url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '站点url',
  `app_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '应用ID',
  `app_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '应用密钥',
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `delete_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`web_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商家-站点表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Table structure for v2_sj_buy_package
-- ----------------------------
DROP TABLE IF EXISTS `v2_sj_buy_package`;
CREATE TABLE `v2_sj_buy_package`  (
  `package_id` int(11) NOT NULL AUTO_INCREMENT,
  `package_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '套餐名称',
  `specification` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '规格：01：1亿Tokens，02、5千万Tokens，03、1千万Tokens',
  `goldcoinNum` float(11, 2) NOT NULL DEFAULT 0.00 COMMENT '消耗金币数量',
  `tokensNum` bigint(20) NOT NULL DEFAULT 0 COMMENT '获得Tokens数量',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '套餐说明',
  `status` tinyint(2) NOT NULL DEFAULT 1 COMMENT '状态：-1、禁用，1、启用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`package_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Table structure for v2_sj_config
-- ----------------------------
DROP TABLE IF EXISTS `v2_sj_config`;
CREATE TABLE `v2_sj_config`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `web_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '链接地址',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Table structure for v2_sj_consumption_log
-- ----------------------------
DROP TABLE IF EXISTS `v2_sj_consumption_log`;
CREATE TABLE `v2_sj_consumption_log`  (
  `consumption_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `type` tinyint(2) NOT NULL COMMENT '消费类型：01：金币，02：Tokens，',
  `con_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '01、购买tokens，02：客服聊天消费，03：Tokens 套餐购买，04、充值，',
  `seller_id` int(11) NOT NULL COMMENT '消费商家ID',
  `consumption_num` float NOT NULL COMMENT '消费数量',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`consumption_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Table structure for v2_sj_merchant_version
-- ----------------------------
DROP TABLE IF EXISTS `v2_sj_merchant_version`;
CREATE TABLE `v2_sj_merchant_version`  (
  `merchant_id` int(11) NOT NULL AUTO_INCREMENT,
  `character` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' COMMENT '角色版本名称：01、试用版、02：商业版',
  `goldcoinNum` int(11) NOT NULL DEFAULT 0 COMMENT '开通所需消耗金币数量',
  `tokensNum` bigint(20) NOT NULL DEFAULT 0 COMMENT '赠送Tokens数量',
  `equity_statement` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '试用版、商用版：权益、限制 说明',
  `badge` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图标 徽章',
  `status` tinyint(2) NOT NULL DEFAULT 1 COMMENT '状态：-1、禁用，1、启用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`merchant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Table structure for v2_system
-- ----------------------------
DROP TABLE IF EXISTS `v2_system`;
CREATE TABLE `v2_system`  (
  `sys_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '系统设置id',
  `hello_word` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '欢迎语',
  `seller_id` int(11) NOT NULL COMMENT '所属商家',
  `seller_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商户标识',
  `hello_status` tinyint(1) NOT NULL COMMENT '是否启用欢迎语 0 不启用 1 启用',
  `relink_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否转接 0 不启用 1 启用',
  `auto_link` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否自动接待 0 否 1 是',
  `auto_link_time` int(5) NOT NULL DEFAULT 30 COMMENT '自动接待间隔 单位s',
  `robot_open` tinyint(1) NULL DEFAULT 0 COMMENT '是否开启机器人 0:关闭  1:开启',
  `pre_input` tinyint(1) NULL DEFAULT 0 COMMENT '咨询前输入个人信息 0:否 1:是',
  `auto_remark` tinyint(1) NULL DEFAULT 1 COMMENT '自动备注 0 关闭 1 打开',
  PRIMARY KEY (`sys_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 60 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_unknown_question
-- ----------------------------
DROP TABLE IF EXISTS `v2_unknown_question`;
CREATE TABLE `v2_unknown_question`  (
  `question_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '位置问题id',
  `seller_id` int(11) NOT NULL COMMENT '关联的商户id',
  `question` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '未知问题',
  `customer_name` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '提问的访客',
  `create_time` datetime NOT NULL COMMENT '提问时间',
  PRIMARY KEY (`question_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_word
-- ----------------------------
DROP TABLE IF EXISTS `v2_word`;
CREATE TABLE `v2_word`  (
  `word_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '简略标题',
  `word` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '常用语内容',
  `seller_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '所属商户的标识',
  `cate_id` int(11) NOT NULL COMMENT '所属分类id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`word_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for v2_word_cate
-- ----------------------------
DROP TABLE IF EXISTS `v2_word_cate`;
CREATE TABLE `v2_word_cate`  (
  `cate_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '问题分类id',
  `cate_name` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '问题分类名称',
  `seller_id` int(11) NOT NULL COMMENT '所属商户id',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 启用 2 禁用',
  PRIMARY KEY (`cate_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- 插入数据
-- ----------------------------
INSERT INTO `v2_question` VALUES (2, '5c6cbcb7d55ca', '接入渠道', '全渠道覆盖\n接待响应一站式\n桌面网站\nApp\n微信\n短信\n移动网站\n邮件\n微博', '2021-08-31 19:12:10');

INSERT INTO `v2_question_conf` VALUES (1, '猜你想问：', '5c6cbcb7d55ca', 0);

INSERT INTO `v2_sj_buy_package` VALUES (1, '套餐一', '1亿Tokens', 999.00, 100000000, '1亿Tokens', 1, '2025-06-25 13:20:07', '2025-06-25 13:20:07');
INSERT INTO `v2_sj_buy_package` VALUES (2, '套餐二', '5千万Tokens', 550.00, 50000000, '5千万Tokens', 1, '2025-06-25 13:20:26', '2025-06-25 13:20:26');
INSERT INTO `v2_sj_buy_package` VALUES (3, '套餐三', '1千万Tokens', 120.00, 10000000, '1千万Tokens', 1, '2025-06-26 10:03:15', '2025-06-26 10:03:15');

INSERT INTO `v2_sj_config` VALUES (1, 'http://192.168.53.133/apps?isCreatedByMe=true', '应用管理(目录菜单)');
INSERT INTO `v2_sj_config` VALUES (2, 'http://192.168.53.133/datasets', '知识库(目录菜单)');
INSERT INTO `v2_sj_config` VALUES (3, 'http://192.168.53.133/', 'dify服务器地址');

INSERT INTO `v2_sj_merchant_version` VALUES (1, '试用版', 0, 50000, '试用版用户使用本系统有以下限制:1、只能生成一个应用，并在系统内测试，不能关联客户席位。2、不可生成自己的知识库。3、免费tokens为50000个，不河购买新的tokens。建议升级商业版解锁全部功。', '/static/common/images/kefu/free.png', 1, '2025-06-25 16:31:28', '2025-06-25 16:31:28');
INSERT INTO `v2_sj_merchant_version` VALUES (2, '商用版', 999, 100000, '所有功能均无限制', '/static/common/images/kefu/shang.png', 1, '2025-06-25 17:02:17', '2025-06-25 17:02:17');

INSERT INTO `v2_system` VALUES (1, '<p>AI智服您身边的智能客服系统，以在线人工客服和智能机器人两大系统为基础，融合ACD（Automatic Call Distribution）技术和大数据分析，为各行业企业提供云端和系统自建的应用产品，以及整体在线营销与服务解决方案。</p><p><span style=\"font-size: 14px; color: rgb(127, 127, 127);\">AI智服不得用于任何违法犯罪目的，包括非法言论、网络黄赌毒和诈骗等违法行为，一旦发现将采取关停账号并移交相关司法机构等措施！</span></p>', 1, '5c6cbcb7d55ca', 1, 1, 1, 5, 1, 0, 0);
INSERT INTO `v2_system` VALUES (2, '您好，客服为您服务', 2, '612f39421f022', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (3, '您好，客服为您服务', 3, '61303d4fc17d9', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (4, '<p>您好，大龙云智能客服为您服务</p>', 4, '62e72dc6c4adc', 0, 0, 1, 30, 0, 0, 0);
INSERT INTO `v2_system` VALUES (5, '您好，智能客服为您服务', 5, '63f72af817f79', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (6, '您好，智能客服为您服务', 6, '64422d270335a', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (7, '您好，智能客服为您服务', 7, '680f3a9483d73', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (8, '<p>您好，智能客服为您服务121321321231</p>', -10, '68199f8a44acd', 1, 1, 1, 30, 1, 0, 1);
INSERT INTO `v2_system` VALUES (9, '<p>您好，智能客服为您服务</p>', 11, '6819a6481472d', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (10, '您好，DBIM 智能客服为您服务', 10, '68199f8a44acd', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (11, '您好，DBIM 智能客服为您服务', 13, '681d95d50cd2c', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (12, '您好，DBIM 智能客服为您服务', 14, '684fdda43f2f5', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (13, '您好，DBIM 智能客服为您服务', 15, '68528421b0574', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (14, '您好，DBIM 智能客服为您服务', 16, '6853a268e2f6e', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (15, '您好，DBIM 智能客服为您服务', 17, '6853a4fb05990', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (16, '您好，DBIM 智能客服为您服务', 18, '6853a52039e74', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (17, '您好，DBIM 智能客服为您服务', 19, '6853a9bae86fb', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (18, '您好，DBIM 智能客服为您服务', 20, '6853ab5abf706', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (19, '您好，DBIM 智能客服为您服务', 21, '6853ab8d0c5ec', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (20, '您好，DBIM 智能客服为您服务', 22, '6853abc9c9fd2', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (21, '您好，DBIM 智能客服为您服务', 23, '6853ac1f84f8d', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (22, '您好，DBIM 智能客服为您服务', 24, '6853acbb8563b', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (23, '您好，DBIM 智能客服为您服务', 25, '6853ad110d744', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (24, '您好，DBIM 智能客服为您服务', 26, '6853ad59af214', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (25, '您好，DBIM 智能客服为您服务', 27, '6853adb9eb03c', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (26, '您好，DBIM 智能客服为您服务', 28, '6853adf305f7d', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (27, '您好，DBIM 智能客服为您服务', 29, '6853ae40eb3f8', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (28, '您好，DBIM 智能客服为您服务', 30, '6853ae8749622', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (29, '您好，DBIM 智能客服为您服务', 31, '6853af66af2c9', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (30, '您好，DBIM 智能客服为您服务', 32, '6853b1e26d110', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (31, '您好，DBIM 智能客服为您服务', 33, '6853b24968409', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (32, '您好，DBIM 智能客服为您服务', 34, '6853dea892a83', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (33, '您好，DBIM 智能客服为您服务', 35, '685919a3d40d8', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (34, '您好，DBIM 智能客服为您服务', 36, '686f877d77ff1', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (35, '您好，DBIM 智能客服为您服务', 37, '686f8b7eca6c5', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (36, '您好，DBIM 智能客服为您服务', 38, '686f8d1f67186', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (37, '您好，DBIM 智能客服为您服务', 39, '686f8d877358d', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (38, '您好，DBIM 智能客服为您服务', 40, '686f92fc969ae', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (39, '您好，DBIM 智能客服为您服务', 41, '686f93b7f2c7b', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (40, '您好，DBIM 智能客服为您服务', 42, '686f93f2dc3f8', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (41, '您好，DBIM 智能客服为您服务', 43, '686f95d8a4045', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (42, '您好，DBIM 智能客服为您服务', 44, '686f980030e49', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (43, '您好，DBIM 智能客服为您服务', 45, '686f9d0443771', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (44, '您好，DBIM 智能客服为您服务', 46, '686f9e0915013', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (45, '您好，DBIM 智能客服为您服务', 47, '686f9e6d2b327', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (46, '您好，DBIM 智能客服为您服务', 48, '6870747724d28', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (47, '您好，DBIM 智能客服为您服务', 49, '687074fd41786', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (48, '您好，DBIM 智能客服为您服务', 50, '687075575b2ce', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (49, '您好，DBIM 智能客服为您服务', 51, '6870758d17dac', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (50, '您好，DBIM 智能客服为您服务', 52, '6877170710c3d', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (51, '您好，DBIM 智能客服为您服务', 53, '68771b8c0bdf3', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (52, '您好，DBIM 智能客服为您服务', 54, '68788ad5e54f3', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (53, '您好，DBIM 智能客服为您服务', 55, '6879ae8f60e84', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (54, '您好，DBIM 智能客服为您服务', 56, '6879e22ea4341', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (55, '您好，DBIM 智能客服为您服务', 57, '6879e4a9c9a22', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (56, '您好，DBIM 智能客服为您服务', 58, '687a1ae639057', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (57, '您好，DBIM 智能客服为您服务', 59, '687e010d96f18', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (58, '您好，DBIM 智能客服为您服务', 60, '68818d64824a9', 1, 1, 0, 30, 0, 0, 1);
INSERT INTO `v2_system` VALUES (59, '您好，DBIM 智能客服为您服务', 61, '68818f7dca4db', 1, 1, 0, 30, 0, 0, 1);

INSERT INTO `v2_word_cate` VALUES (1, '咨询问题', 1, 1);
INSERT INTO `v2_word_cate` VALUES (2, '付费问题', 1, 1);
INSERT INTO `v2_word_cate` VALUES (3, '常用语分类1', 10, 1);
INSERT INTO `v2_word_cate` VALUES (4, '常用语分类2', 10, 1);
INSERT INTO `v2_word_cate` VALUES (5, '11', 33, 1);









