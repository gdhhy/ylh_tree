/*
 Navicat Premium Data Transfer

 Source Server         : mysql-5.6
 Source Server Type    : MySQL
 Source Server Version : 50640
 Source Host           : 127.0.0.1:3306
 Source Schema         : ylh_tree

 Target Server Type    : MySQL
 Target Server Version : 50640
 File Encoding         : 65001

 Date: 31/07/2018 00:47:58
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for member
-- ----------------------------
DROP TABLE IF EXISTS member_tree;
CREATE TABLE member_tree_0731  (
  member_id int(11) NOT NULL AUTO_INCREMENT,
  member_no varchar(26) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  user_name varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  real_name varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  id_card varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  phone varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  member_info varchar(1023) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  parent_no varchar(26) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  cur_level int(11) NULL DEFAULT 0,
  child_total int(11) NULL DEFAULT 0,
  child_depth int(11) NULL DEFAULT 0,
  direct_count int(11) NULL DEFAULT 0,
  PRIMARY KEY (member_id) USING BTREE,
  INDEX ix_user_name(user_name) USING BTREE,
  INDEX ix_memberno(member_no) USING BTREE,
  INDEX ix_realname(real_name) USING BTREE,
  INDEX ix_idcard(id_card) USING BTREE,
  INDEX ix_phone(phone) USING BTREE,
  INDEX ix_parentno(parent_no) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

SET FOREIGN_KEY_CHECKS = 1;
