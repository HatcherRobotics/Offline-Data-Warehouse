//DIM：基于维度建模理论进行构建，存放维度模型中的维度表，保存一致性维度信息。
//DIM层的设计依据是维度建模理论，该层存储维度模型的维度表。
//DIM层的数据存储格式为 orc 列式存储+snappy 压缩。
//DIM层表名的命名规范为 dim_表名_全量表或者拉链表标识（full/zip）
//轨道车辆信息维度表
//1.建表语句
DROP TABLE IF EXISTS dim_rolling_stock_info_full;
CREATE EXTERNAL TABLE dim_rolling_stock_info_full(
    id STRING COMMENT '主键',
    line_code STRING COMMENT '线路编号',
    line_type TINYINT COMMENT '行别',
    vehicle_no TINYINT COMMENT '车辆编号'
)   COMMENT '轨道车辆信息维度表'
    PARTITIONED BY (`dt` STRING COMMENT '统计日期')
    STORED AS ORC
    LOCATION '/warehouse/rolling_stock/dim/dim_rolling_stock_info_full'
    TBLPROPERTIES ('orc.compress' = 'snappy');
//2.数据装载
INSERT OVERWRITE TABLE dim_rolling_stock_info_full PARTITION (dt = '2024-01-24')
SELECT id,
       line_code,
       line_type,
       vehicle_no
FROM rolling_stock.ods_rolling_stock_info_full o
WHERE o.dt = '2024-01-24';
//日志编码维度表
//1.建表语句
DROP TABLE IF EXISTS dim_code_full;
CREATE EXTERNAL TABLE dim_code_full(
    `type` STRING COMMENT '编码类型',
    `code_id` STRING COMMENT '编码ID',
    `code_name` STRING COMMENT '编码名称'
)   COMMENT '日志编码维度表'
    STORED AS ORC
    LOCATION '/warehouse/rolling_stock/dim/dim_code_full'
    TBLPROPERTIES ('orc.compress'='snappy');
//2.数据装载
DROP TABLE IF EXISTS tmp_code_full;
CREATE EXTERNAL TABLE tmp_code_full(
    `type` STRING COMMENT '编码类型',
    `code_id` STRING COMMENT '编码ID',
    `code_name` STRING COMMENT '编码名称'
)   COMMENT '日志编码维度表'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/warehouse/rolling_stock/tmp/tmp_code_full';
INSERT INTO dim_code_full SELECT * FROM tmp_code_full;
