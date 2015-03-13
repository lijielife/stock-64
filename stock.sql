SHOW ENGINES;

USE information_schema;
SELECT * FROM TABLES;
SELECT * FROM COLUMNS WHERE TABLE_NAME ='stock';

SELECT version();

SHOW VARIABLES;
SHOW VARIABLES LIKE 'datadir%';

SHOW TABLE STATUS FROM `stock`;

DESC `stock`;
SHOW CREATE TABLE `stock`;


USE stock;

DROP TABLE ``;
DESC `MarketHistory`;
SHOW CREATE TABLE `MarketHistory`;
SHOW TABLE STATUS LIKE 'MarketHistory';
SHOW TABLE STATUS LIKE 'nanhuacrabstore';
SHOW COLUMNS FROM `stock`;



CREATE TABLE `StockPriceStage`
(
	`Id` BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT COMMENT 'Key',
	`StockCode` CHAR(8) NOT NULL COMMENT 'StockCode',
	`Price` DECIMAL(18,2) NOT NULL COMMENT 'Price',
	`PriceDate` Date NOT NULL COMMENT 'PriceDate',
	`CalculateDate` Date NOT NULL COMMENT 'CalculateDate'
);

CREATE TABLE Stock
(
	`StockCode` CHAR(8) PRIMARY KEY NOT NULL COMMENT 'Key',
	`StockName` VARCHAR(10) NOT NULL
);
ALTER TABLE Stock MODIFY COLUMN `Industry` NVARCHAR(10) NOT NULL COMMENT '行业';
ALTER TABLE Stock MODIFY COLUMN `TradableShares` BIGINT NOT NULL COMMENT '流通股本';
ALTER TABLE Stock MODIFY COLUMN `NegotiableMarket` BIGINT NOT NULL COMMENT '流通市值';
/* http://hq.sinajs.cn/list=sh601006 */
/* FDC_DC.nextPage(0) FDC_DC.previousPage(0) FDC_DC.lastPage(0) FDC_DC.firstPage(0) */
/* http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/601006.phtml?year=2014&jidu=4 */
UPDATE Stock SET `NegotiableMarket` = 0;
SELECT COUNT(1) FROM Stock WHERE `Industry` = '' OR `TradableShares` = 0 OR `NegotiableMarket` = 0;
SELECT * FROM Stock WHERE `Industry` = '' OR `TradableShares` = 0 OR `NegotiableMarket` = 0;
SELECT COUNT(1) FROM Stock; -- 2588
SELECT COUNT(1) FROM Stock WHERE `StockCode` LIKE 'sh%'; -- 985
SELECT COUNT(1) FROM Stock WHERE `StockCode` LIKE 'sz%'; -- 1603
SELECT * FROM stock ORDER BY StockCode;
SELECT * FROM stock ORDER BY StockCode DESC;

SELECT * FROM Stock WHERE `StockCode` = 'sz000166';
INSERT INTO Stock( `StockCode`, `StockName`, `Industry`, `TradableShares`, `NegotiableMarket` ) 
VALUES( 'sh601069', N'N黄金', N'有色金属', 126000000, 648000000 );

ALTER TABLE `MarketHistory` engine = myisam;

CREATE TABLE MarketHistory
(
	`StockId` 		INT NOT NULL COMMENT 'Key',
    `MarketDate` 	Date COMMENT '日期',
	`Open` 			DECIMAL(18,2) COMMENT '开盘价',
	`Close` 		DECIMAL(18,2) COMMENT '收盘价',
	`Hign` 			DECIMAL(18,2) COMMENT '最高价',
	`Low` 			DECIMAL(18,2) COMMENT '最低价',
	`Volume` 		BIGINT COMMENT '交易量',
	`Amount` 		DECIMAL(18,2) COMMENT '交易金额'
);
ALTER TABLE MarketHistory MODIFY COLUMN `Id` BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT COMMENT 'Key';
ALTER TABLE MarketHistory ADD `HignRate` DECIMAL(18,2) NULL COMMENT '最高涨幅';
ALTER TABLE MarketHistory ADD `LowRate` DECIMAL(18,2) NULL COMMENT '最低涨幅';
ALTER TABLE MarketHistory ADD `PreClose` DECIMAL(18,2) NULL COMMENT '昨日收盘价';
ALTER TABLE MarketHistory MODIFY COLUMN `VolumeRate` DECIMAL(18,4) NULL COMMENT '量比';
ALTER TABLE MarketHistory MODIFY COLUMN `Rate` DECIMAL(18,4) NULL COMMENT '价比';
ALTER TABLE MarketHistory MODIFY COLUMN `StockCode` CHAR(8) NOT NULL COMMENT 'StockCode';
ALTER TABLE MarketHistory DROP COLUMN `StockId`;
ALTER TABLE MarketHistory ADD `PreVolume` BIGINT NULL COMMENT '上次交易量';
ALTER TABLE MarketHistory ADD `Turnover` DECIMAL(18,2) NULL COMMENT '换手率%';
ALTER TABLE MarketHistory ADD `PreRate` DECIMAL(18,4) NULL COMMENT '上一交易日的价比';

UPDATE MarketHistory SET `StockCode` = CONCAT('sh', `StockId`);
SELECT CONCAT('sh', CAST(`StockId` AS CHAR(6))) FROM MarketHistory;
SELECT CONCAT('sh', `StockId`) FROM MarketHistory;

SELECT * FROM MarketHistory WHERE `Volume` = 0 OR `Amount` = 0;
DELETE FROM MarketHistory WHERE `Volume` = 0 OR `Amount` = 0;

SELECT DISTINCT `MarketDate`, COUNT(1) FROM MarketHistory WHERE `MarketDate` >= '2014-12-31' GROUP BY `MarketDate` ORDER BY `MarketDate` DESC;
SELECT DISTINCT `MarketDate`, MAX(`StockCode`) FROM MarketHistory WHERE `MarketDate` >= '2014-12-31' GROUP BY `MarketDate` ORDER BY `MarketDate` DESC;

UPDATE `MarketHistory` SET `VolumeRate` = `Volume` / `PreVolume` WHERE `VolumeRate` IS NULL AND `PreVolume` IS NOT NULL;
UPDATE `MarketHistory` SET `Rate` = `Close` / `PreClose`;
UPDATE `MarketHistory` SET `Rate` = `Close` / `PreClose` WHERE `Rate` IS NULL;
/*
*/

SELECT MAX(id) FROM MarketHistory; -- 87123 87159 87402 90699
SELECT * FROM `MarketHistory` WHERE `id` IN( 87159, 93357 );

UPDATE `MarketHistory` SET `Rate` = `Close` / `PreClose` WHERE `Rate` IS NULL;

/* 最新没有抓取的 */
SELECT DISTINCT(`StockCode`), MIN(`MarketDate`) FROM `MarketHistory` WHERE `PreClose` = -1;

SELECT COUNT(1) FROM `MarketHistory` WHERE `PreClose` = -1;
SELECT `Id`, `Close`, `PreClose`, `Rate` FROM `MarketHistory` WHERE `StockCode` = 'sh600004' ORDER BY `MarketDate`;
SELECT * FROM MarketHistory WHERE `StockCode` = 'sz300081' ORDER BY `MarketDate`;
SELECT COUNT(1) FROM MarketHistory WHERE `StockCode` = 'sh600056';
SELECT COUNT(1) FROM `MarketHistory`;
SELECT DISTINCT `MarketDate`, COUNT(1) FROM MarketHistory GROUP BY `MarketDate`;
SELECT DISTINCT `MarketDate`, COUNT(1) FROM MarketHistory GROUP BY `MarketDate` ORDER BY `MarketDate` DESC;
SELECT COUNT(1) FROM MarketHistory WHERE `MarketDate` = '2014-12-31';

SELECT COUNT(1) FROM `MarketHistory` WHERE `PreClose` IS NULL OR `PreClose` = -1;
SELECT COUNT(1) FROM `MarketHistory` WHERE `PreVolume` IS NULL AND `PreClose` != -1;
SELECT MIN(`StockCode`) FROM `MarketHistory` WHERE `PreVolume` IS NULL AND `PreClose` != -1;
/*
SELECT * FROM `MarketHistory` WHERE `id` IN ( 283028, 283286 );
UPDATE `MarketHistory` SET `PreVolume` = `Volume`, `VolumeRate` = 1, `PreRate` = 1 WHERE `id` IN ( 283028, 283286 );
*/
SELECT COUNT(1) FROM `MarketHistory` WHERE `Rate` IS NULL;
SELECT COUNT(1) FROM `MarketHistory` WHERE `VolumeRate` IS NULL;
SELECT MIN(`StockCode`) FROM `MarketHistory` WHERE `VolumeRate` IS NULL;
SELECT COUNT(1) FROM `MarketHistory` WHERE `PreRate` IS NULL;
SELECT MIN(`StockCode`) FROM `MarketHistory` WHERE `PreRate` IS NULL;

SELECT COUNT(1) FROM MarketHistory WHERE `Turnover` IS NULL OR `Turnover` = 0;
SELECT COUNT(1) FROM MarketHistory WHERE `PreVolume` IS NULL;
SELECT COUNT(1) FROM MarketHistory WHERE `PreRate` IS NULL;
SELECT * FROM MarketHistory WHERE `StockCode` = 'sh600829';
SELECT COUNT(1) FROM MarketHistory WHERE `PreVolume` IS NOT NULL AND `PreRate` IS NULL;
SELECT COUNT(1) FROM MarketHistory WHERE `PreRate` IS NOT NULL AND `PreVolume` IS NULL;
SELECT COUNT(1) FROM MarketHistory WHERE `VolumeRate` IS NULL;
UPDATE `MarketHistory` SET `VolumeRate` = `Volume` / `PreVolume` WHERE `VolumeRate` IS NULL AND `PreVolume` IS NOT NULL;
SELECT * FROM MarketHistory ORDER BY `StockCode`, `MarketDate`;
SELECT * FROM MarketHistory ORDER BY `StockCode`, `MarketDate` DESC;
SELECT * FROM MarketHistory ORDER BY `StockCode` DESC, `MarketDate`;
SELECT * FROM MarketHistory ORDER BY `StockCode` DESC, `MarketDate` DESC;

SELECT *
FROM `Stock`
WHERE `StockCode` IN ( 
	SELECT `StockCode` FROM MarketHistory WHERE `Turnover` IS NULL OR `Turnover` = 0
);

SELECT COUNT(1) FROM MarketHistory WHERE ( `PreVolume` IS NULL OR `PreRate` IS NULL );
SELECT `MarketDate`, COUNT(1) FROM MarketHistory WHERE `PreVolume` IS NULL OR `PreRate` IS NULL GROUP BY `MarketDate`;
SELECT * FROM `MarketHistory` WHERE `PreVolume` IS NULL;

SELECT * FROM `MarketHistory` WHERE `StockCode` IN (
	SELECT `StockCode` FROM `MarketHistory` WHERE `PreVolume` IS NULL
);

SELECT * FROM `Stock` WHERE `StockCode` IN (
	SELECT `StockCode` FROM `MarketHistory` WHERE `PreVolume` IS NULL
);


SELECT * FROM MarketHistory WHERE `Turnover` IS NULL OR `Turnover` = 0 ORDER BY StockCode;
DELETE FROM MarketHistory WHERE ( `Turnover` IS NULL OR `Turnover` = 0 ) AND StockCode = 'sh601444';

SELECT COUNT(1) FROM MarketHistory WHERE `Rate` > 1 AND `MarketDate` = '2014-12-31' ORDER BY `Rate`;
SELECT `StockCode`, `PreClose`, `Close`, `Rate` FROM MarketHistory WHERE `Rate` > 1 AND `MarketDate` = '2014-12-31' ORDER BY `Rate`, `StockCode`;

SELECT * FROM `MarketHistory` WHERE `PreVolume` IS NULL AND `MarketDate` = '2015-02-09'

SELECT * FROM `PriceMovements` WHERE `StockCode` = 'sh600000' ORDER BY DateEnd;
SELECT * FROM `MarketHistory` WHERE `StockCode` = 'sh600000' AND `MarketDate` >= '2014-12-01' ORDER BY `MarketDate`;
SELECT * FROM `PriceMovements` WHERE `StockCode` = 'sh600000' AND `DateStart` = '2014-12-31';

-- 连续X天下跌
CREATE TABLE PriceMovements
(
	`Id` BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT COMMENT 'Key',
	`StockCode` CHAR(8) NOT NULL COMMENT 'StockCode',
	`DateStart` DATE NOT NULL COMMENT '日期',
	`DateEnd` DATE NOT NULL COMMENT '日期',
	`Rate` DECIMAL(18,4) NOT NULL COMMENT '日期',
	`DateStartPrice` DECIMAL(18,2) NOT NULL COMMENT '日期',
	`DateEndPrice` DECIMAL(18,2) NOT NULL COMMENT '日期'
);
ALTER TABLE `PriceMovements` ADD `Duration` INT NOT NULL COMMENT '时长';
SELECT COUNT(1) FROM PriceMovements; -- 7034
SELECT * FROM PriceMovements ORDER BY `Rate`;
SELECT * FROM MarketHistory WHERE `StockCode` = 'sh600005' ORDER BY `MarketDate`;
SELECT * FROM `PriceMovements` WHERE `StockCode` = 'sh600000' ORDER BY DateEnd;

/* ---------------------------------------------------------------------------------------------------------------- */

/*

*/
-- choice
-- 量价同时反弹
SELECT `MarketHistory`.`StockCode`, `Stock`.`StockName`, `Stock`.`Industry`, `MarketDate`, `PreClose`, `Close`, `PreVolume`, `Volume`, `Turnover`, `PreRate`, `Rate`, `VolumeRate`
FROM `MarketHistory` INNER JOIN `Stock` ON `MarketHistory`.`StockCode` = `Stock`.`StockCode`
WHERE `PreRate` < 1 AND `Rate` > 1 AND `VolumeRate` > 1 AND
		`MarketDate` = '2014-01-10' -- 2015-01-05
		/*AND `Turnover` > 10*/
		/*AND `Volume` > 30000000*/
		/*AND `Turnover` BETWEEN 2 AND 3*/
		/*AND `Close` < 10*/
		/*AND `MarketHistory`.`StockCode` LIKE 'sh%'*/
ORDER BY `VolumeRate` DESC, `Volume` DESC, `Turnover` DESC, `MarketHistory`.`StockCode`
LiMIT 0, 10;

SELECT `StockCode`, `MarketDate`, `Hign`, `Low`
FROM `MarketHistory`
WHERE `StockCode` = 'sh600029' AND `MarketDate` > '2015-02-17'
ORDER BY `MarketDate`;

-- 还手率
SELECT `MarketHistory`.`StockCode`, `Stock`.`StockName`, `Stock`.`Industry`, `MarketDate`, `Close`, `Volume`, `Turnover`, `PreRate`, `Rate`, `VolumeRate`
FROM `MarketHistory` INNER JOIN `Stock` ON `MarketHistory`.`StockCode` = `Stock`.`StockCode`
WHERE `MarketDate` = '2015-01-05' -- 2015-01-05
		AND `MarketHistory`.`StockCode` LIKE 'sh%'
ORDER BY `Turnover` DESC;

SELECT * FROM `MarketHistory` WHERE `StockCode` = 'sh600000' ORDER BY `MarketDate`;
SELECT COUNT(1) FROM `StockPriceStage`;
SELECT * FROM `StockPriceStage`;
SELECT * FROM `StockPriceStage` WHERE `StockCode` = 'sh600005' ORDER BY `StockCode`, `PriceDate`;

-- 连续跌X天
SELECT `Stock`.`StockName`, `Stock`.`Industry`, `PriceMovements`.*
FROM `PriceMovements` INNER JOIN `Stock` ON `PriceMovements`.`StockCode` = `Stock`.`StockCode`
ORDER BY `Duration` DESC, `Rate`;

-- 连续涨X天
SELECT `Stock`.`StockName`, `Stock`.`Industry`, `PriceMovements`.*
FROM `PriceMovements` INNER JOIN `Stock` ON `PriceMovements`.`StockCode` = `Stock`.`StockCode`
ORDER BY `Duration` DESC, `Rate` DESC;

/* ---------------------------------------------------------------------------------------------------------------- */

-- update rate
UPDATE MarketHistory SET `Rate` = `Close` / `PreClose` WHERE `Rate` IS NULL;
SELECT `StockCode`, `MarketDate`, `PreClose`, `Close`, `Rate` 
FROM MarketHistory 
ORDER BY `StockCode`, `MarketDate`;

SELECT `StockCode`, `MarketDate`, `PreRate`, `Rate`
FROM MarketHistory 
ORDER BY `StockCode`, `MarketDate`;

-- update volume rate
UPDATE `MarketHistory` SET `VolumeRate` = `Volume` / `PreVolume` WHERE `VolumeRate` IS NULL AND `PreVolume` IS NOT NULL;
SELECT `StockCode`, `MarketDate`, `PreVolume`, `Volume`, `VolumeRate` 
FROM `MarketHistory`
ORDER BY `StockCode`, `MarketDate`;

SELECT COUNT(1)
FROM `MarketHistory`
WHERE `PreVolume` IS NOT NULL AND `VolumeRate` IS NULL;

SELECT `StockCode`, `MarketDate`, `PreVolume`, `Volume`, `VolumeRate` 
FROM `MarketHistory` 
WHERE `MarketDate` = '2015-01-05' AND `PreVolume` IS NULL
ORDER BY `StockCode`, `MarketDate`;

SELECT COUNT(1)
FROM MarketHistory 
WHERE `MarketDate` = '2015-01-05' AND `PreVolume` IS NULL
ORDER BY `StockCode`, `MarketDate`;

SELECT COUNT(1) FROM MarketHistory WHERE `PreClose` < `Close` AND `PreVolume` < `Volume` AND `MarketDate` = '2014-12-31'; -- 量价齐升
SELECT * FROM MarketHistory WHERE `PreClose` < `Close` AND `PreVolume` < `Volume` AND `MarketDate` = '2014-12-31'; -- 量价齐升

DELETE FROM MarketHistory WHERE `MarketDate` = '2014-12-31';
DELETE FROM MarketHistory;

SELECT COUNT(1) FROM MarketHistory;
SELECT COUNT(1) FROM MarketHistory WHERE stockid = 600030;
SELECT MIN(MarketDate), MAX(MarketDate), MAX(Id) FROM MarketHistory WHERE stockid = 600030;
SELECT * FROM MarketHistory WHERE stockid = 600030 ORDER BY `MarketDate` DESC;
SELECT `Id`, `MarketDate`, `Close`, `PreClose` FROM MarketHistory WHERE stockid = 600030 ORDER BY `MarketDate` DESC;

/*
[buyRate]0.92-[sellRate]0.98-[focus]592-[buy]178-[sell]112
*/

USE test;
SHOW TABLES;
DESC `stocktransactiondetail`;

SELECT `Id`,
		`Code` AS 'StockCode', 
		`TransactionDate` AS 'MarketDate', 
		`BeginPrice` AS 'Open', 
		`EndPrice` AS 'Close', 
		`HighestPrice` AS 'Hign', 
		`LowestPrice` AS 'Low', 
		`Volume` AS 'Volume', 
		`TransactionMoney` AS 'Amount' ,
		-999 AS 'PreClose',
		-999 AS 'PreVolume',
		-999 AS 'VolumeRate',
		-999 AS 'Rate',
		-999 AS 'Turnover',
		-999 AS 'PreRate'
FROM `stocktransactiondetail` LIMIT 0, 1;

SELECT COUNT(1) 
FROM `stocktransactiondetail`
WHERE TransactionDate >= '2014-01-01' AND TransactionDate < '2015-01-01';

SELECT * 
FROM `stocktransactiondetail`
WHERE TransactionDate >= '2014-01-01' AND TransactionDate < '2015-01-01'
ORDER BY TransactionDate LIMIT 0, 1;

USE stock;
-- spend 10000 seconds
-- 565204, spend 3369 seconds, 565468,
SELECT COUNT(1) FROM MarketHistory WHERE `MarketDate` >= '2014-01-01' AND `MarketDate` < '2015-01-01'; 
SELECT * FROM MarketHistory WHERE `MarketDate` >= '2014-01-01' AND `MarketDate` < '2014-01-03'; 
SELECT COUNT(1) FROM MarketHistory WHERE `MarketDate` >= '2014-01-01' AND `MarketDate` < '2014-01-03' AND `PreClose` <> -999; 
SELECT * FROM MarketHistory WHERE `MarketDate` >= '2014-01-01' AND `MarketDate` < '2014-01-03' AND `PreClose` <> -999; 

-- 550131, 249083
SELECT COUNT(1) FROM `MarketHistory` WHERE `PreClose` = -999;
SELECT * FROM `MarketHistory` WHERE `PreClose` = -999;
SELECT COUNT(1) FROM ( SELECT `StockCode` FROM `MarketHistory` WHERE `PreClose` = -999 GROUP BY `StockCode` HAVING COUNT(1) > 1 ) AS t;
SELECT `StockCode` FROM `MarketHistory` WHERE `PreClose` = -999 GROUP BY `StockCode` HAVING COUNT(1) > 1 ORDER BY `StockCode`;

SELECT COUNT(1) FROM MarketHistory WHERE `StockCode` = 'sh600575' AND `PreClose` = -999;
SELECT * FROM MarketHistory WHERE `StockCode` = 'sh600575' ORDER BY `MarketDate`;

-- sz000430
SELECT `Id`, `StockCode`, `MarketDate`, `Open`, `Hign`, `Low`, `Close`, `PreClose`, `Volume`, `PreVolume`, `Rate`, `PreRate` 
FROM MarketHistory WHERE `StockCode` = 'sh600074' ORDER BY `MarketDate`;
SELECT `Id`, `StockCode`, `MarketDate`, `Open`, `Hign`, `Low`, `Close`, `PreClose`, `Volume`, `PreVolume`, `Rate`, `PreRate`  
FROM MarketHistory WHERE `StockCode` = 'sh600076' ORDER BY `StockCode`, `MarketDate` LIMIT 0, 5;
SELECT `Id`, `StockCode`, `MarketDate`, `Open`, `Hign`, `Low`, `Close`, `PreClose`, `Volume`, `PreVolume`, `Rate`, `PreRate` 
FROM MarketHistory WHERE `StockCode` = 'sh600077' ORDER BY `StockCode`, `MarketDate` LIMIT 0, 5;
SELECT `Id`, `StockCode`, `MarketDate`, `Open`, `Hign`, `Low`, `Close`, `PreClose`, `Volume`, `PreVolume`, `Rate`, `PreRate` 
FROM MarketHistory WHERE `StockCode` = 'sh600078' ORDER BY `StockCode`, `MarketDate` LIMIT 0, 5;
SELECT `Id`, `StockCode`, `MarketDate`, `Open`, `Hign`, `Low`, `Close`, `PreClose`, `Volume`, `PreVolume`, `Rate`, `PreRate` 
FROM MarketHistory WHERE `StockCode` = 'sh600079' ORDER BY `StockCode`, `MarketDate` LIMIT 0, 5;
SELECT `Id`, `StockCode`, `MarketDate`, `Open`, `Hign`, `Low`, `Close`, `PreClose`, `Volume`, `PreVolume`, `Rate`, `PreRate` 
FROM MarketHistory WHERE `StockCode` = 'sh600080' ORDER BY `StockCode`, `MarketDate` LIMIT 0, 5;

SELECT * FROM `MarketHistory` WHERE `StockCode` = 'sh600074' ORDER BY `MarketDate` LIMIT 0, 5;

-- 补充 上一交易日的 收盘价/交易量 2502
SELECT COUNT(1) FROM MarketHistory WHERE `Rate` = -999;
SELECT COUNT(1) FROM MarketHistory WHERE `PreClose` = -999;
SELECT COUNT(1) FROM MarketHistory WHERE `PreVolume` IS NULL;
-- 计算 价比/量比
UPDATE `MarketHistory` SET `Rate` = `Close` / `PreClose` WHERE `PreClose` != -999;
UPDATE `MarketHistory` SET `Rate` = -999 WHERE `PreClose` = -999;
SELECT COUNT(1) FROM MarketHistory WHERE `Rate` = -999 OR `Rate` IS NULL;
UPDATE `MarketHistory` SET `VolumeRate` = `Volume` / `PreVolume` WHERE `PreVolume` IS NOT NULL;
SELECT COUNT(1) FROM MarketHistory WHERE `VolumeRate` = -999 OR `VolumeRate` IS NULL;
-- 补充 上一交易日的 价比/量比 spend 9855 seconds
SELECT COUNT(1) FROM MarketHistory WHERE `PreRate` IS NULL;
SELECT COUNT(1) FROM MarketHistory WHERE `PreRate` = -999;
UPDATE `MarketHistory` SET `PreRate` = NULL WHERE `PreRate` = -999;
SELECT COUNT(1) FROM MarketHistory WHERE `PreRate` IS NULL AND `Rate` != -999;
SELECT `StockCode` FROM MarketHistory WHERE `PreRate` IS NULL GROUP BY `StockCode` HAVING COUNT(1) > 2;
SELECT COUNT(1) FROM ( SELECT `StockCode` FROM MarketHistory WHERE `PreRate` IS NULL GROUP BY `StockCode` HAVING COUNT(1) > 0 ) AS t;

SELECT COUNT(1) FROM ( SELECT `StockCode` FROM MarketHistory WHERE `PreRate` IS NULL GROUP BY `StockCode` HAVING COUNT(1) > 0 ) AS t0;
SELECT COUNT(1) FROM ( SELECT `StockCode` FROM MarketHistory WHERE `PreRate` IS NULL GROUP BY `StockCode` HAVING COUNT(1) > 1 ) AS t1;
SELECT COUNT(1) FROM ( SELECT `StockCode` FROM MarketHistory WHERE `PreRate` IS NULL GROUP BY `StockCode` HAVING COUNT(1) > 2 ) AS t1;

SELECT `StockCode` FROM ( 
SELECT `StockCode` FROM MarketHistory WHERE `PreRate` IS NULL GROUP BY `StockCode` HAVING COUNT(1) > 0 ) AS t0
WHERE `StockCode` NOT IN (
SELECT `StockCode` FROM MarketHistory WHERE `PreRate` IS NULL GROUP BY `StockCode` HAVING COUNT(1) > 1 );

SELECT `Id`, `StockCode`, `MarketDate`, `Open`, `Hign`, `Low`, `Close`, `PreClose`, `Volume`, `PreVolume`, `Rate`, `PreRate` 
FROM MarketHistory WHERE `StockCode` = 'sz002738' ORDER BY `StockCode`, `MarketDate` LIMIT 0, 5;

-- spend 683 seconds
CREATE TABLE `nanhuacrabstore`
(
	`Id` BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT COMMENT 'Key',
	`StockCode` CHAR(8) NOT NULL COMMENT 'Stock Code',
	`StockName` NVARCHAR(10) NOT NULL COMMENT 'Stock Name',
	`Industry` NVARCHAR(10) NOT NULL COMMENT 'Industry',

	`FocusDate` Date NOT NULL COMMENT 'Focus Date',
	`FocusOpen` DECIMAL(18,2) NOT NULL COMMENT 'Focus Open',
	`FocusClose` DECIMAL(18,2) NOT NULL COMMENT 'Focus Close',
	`FocusHign` DECIMAL(18,2) NOT NULL COMMENT 'Focus Hign',
	`FocusLow` DECIMAL(18,2) NOT NULL COMMENT 'Focus Low',
	`FocusVolumeRate` DECIMAL(18,2) NOT NULL COMMENT 'Focus Volume Rate',

	`BuyRate` DECIMAL(18,5) NOT NULL COMMENT 'Buy Rate',
	`ExpectedBuyPrice` DECIMAL(18,2) NOT NULL COMMENT 'Expected Buy Price',
	`SellRate` DECIMAL(18,5) NOT NULL COMMENT 'Sell Rate',	
	`ExpectedSellPrice` DECIMAL(18,2) NOT NULL COMMENT 'Expected Sell Price',	

	`BuyDate` Date NULL COMMENT 'Buy Date',
	`BuyOpen` DECIMAL(18,2) NULL COMMENT 'Buy Open',
	`BuyClose` DECIMAL(18,2) NULL COMMENT 'Buy Close',
	`BuyHign` DECIMAL(18,2) NULL COMMENT 'Buy Hign',
	`BuyLow` DECIMAL(18,2) NULL COMMENT 'Buy Low',
	`ActualBuyPrice` DECIMAL(18,2) NULL COMMENT 'Actual Buy Price',
	
	`SellDate` Date NULL COMMENT 'Sell Date',
	`SellOpen` DECIMAL(18,2) NULL COMMENT 'Sell Open',
	`SellClose` DECIMAL(18,2) NULL COMMENT 'Sell Close',
	`SellHign` DECIMAL(18,2) NULL COMMENT 'Sell Hign',
	`SellLow` DECIMAL(18,2) NULL COMMENT 'Sell Low',
	`ActualSellPrice` DECIMAL(18,2) NULL COMMENT 'Actual Sell Price',

	`Open` DECIMAL(18,2) NULL COMMENT 'Open',
	`Close` DECIMAL(18,2) NULL COMMENT 'Close',
	`Low` DECIMAL(18,2) NULL COMMENT 'Low',
	`Hign` DECIMAL(18,2) NULL COMMENT 'Hign'
);
ALTER TABLE `nanhuacrabstore` ADD `Hign` DECIMAL(18,2) NULL COMMENT 'Hign';

SELECT * FROM `nanhuacrabstore` WHERE `FocusVolumeRate` IS NULL;

SELECT * FROM `nanhuacrabstore` WHERE `FocusDate` = '2014-01-06' AND `BuyRate` = 0.89 AND `SellRate` = 1.01;

SELECT COUNT(1) FROM `nanhuacrabstore` WHERE `BuyDate` IS NULL;
SELECT * FROM `nanhuacrabstore` WHERE `BuyDate` IS NULL;

SELECT * FROM `nanhuacrabstore` WHERE `SellDate` = NULL AND `FocusDate` = '%1$s' AND `BuyRate` = %2$s AND `SellRate` = %3$s;
-- 1144
SELECT COUNT(1) FROM `nanhuacrabstore`;
SELECT * FROM `nanhuacrabstore` ORDER BY `FocusDate`, `StockCode`;
SELECT * FROM `nanhuacrabstore` WHERE `BuyRate` = 0.89 AND `SellRate` = 1.01 ORDER BY `FocusDate`, `StockCode`;

-- 已经卖出
SELECT `BuyRate`, `SellRate`, COUNT(1) AS `TotalCount`, COUNT( `BuyDate` ) AS `BuyCount`, COUNT( `SellDate` ) AS `SellCount`
FROM `nanhuacrabstore` 
GROUP BY `BuyRate`, `SellRate`;

SELECT `Close` FROM `MarketHistory` WHERE `StockCode` = 'sz002184' ORDER BY `MarketDate` DESC LIMIT 0, 1;

SELECT `MarketHistory`.`StockCode`, `Stock`.`StockName`, `Stock`.`Industry`, `MarketDate`, `PreClose`, `Close`, `Open`, `Low`, `Hign`
FROM `MarketHistory` INNER JOIN `Stock` ON `MarketHistory`.`StockCode` = `Stock`.`StockCode`
WHERE `PreRate` < 1 AND `Rate` > 1 AND `VolumeRate` > 1
AND `MarketDate` = '2015-03-09' AND `MarketHistory`.`StockCode` NOT LIKE 'sz3%'
ORDER BY `VolumeRate` DESC, `MarketHistory`.`StockCode`
LIMIT 0, 1;

SELECT * FROM `nanhuacrabstore` WHERE `StockCode` = '%1$s' AND `FocusDate` = '%2$s' AND `BuyRate` = %3$s AND `SellRate` = %4$s;
INSERT INTO `nanhuacrabstore`( `StockCode`, `StockName`, `Industry`, `FocusDate`, `FocusOpen`, `FocusClose`, `FocusHign`, `FocusLow`, `BuyRate`, `ExpectedBuyPrice`, `SellRate`, `ExpectedSellPrice` )
VALUES( '%1$s', '%2$s', '%3$s', '%4$s', '%5$s', '%6$s', '%7$s', '%8$s', '%9$s', '%10$s', '%11$s', '%12$s' );

INSERT INTO `nanhuacrabstore`( `StockCode`, `StockName`, `Industry`, `FocusDate`, `FocusOpen`, `FocusClose`, `FocusHign`, `FocusLow`, `BuyRate`, `ExpectedBuyPrice`, `SellRate`, `ExpectedSellPrice` )
VALUES( 'sh600038', '中直股份', '航天航空', '2014-01-02', '27.6', '28.4', '28.58', '27.37', '0.89', '25.28', '1.0', '28.4' );

-- ----------------------------------------------------------------------------------------------------------------------------------------
USE stock;
-- 2666
SELECT COUNT(1) FROM `stock`;
SELECT * FROM `MarketHistory` WHERE `StockCode` = 'sz000416' ORDER BY `MarketDate` DESC;

-- 查询下载了多少数据 spend 427 seconds
SELECT DISTINCT `MarketDate`, COUNT(1) FROM MarketHistory GROUP BY `MarketDate` ORDER BY `MarketDate` DESC;
SELECT COUNT(1) FROM `MarketHistory` WHERE `Rate` IS NULL;
SELECT COUNT(1) FROM `MarketHistory` WHERE `Volume` = 0;

-- 更新 PreRate 2502 spend 199 seconds
SELECT * FROM `MarketHistory` ORDER BY `MarketDate` DESC;
SELECT COUNT(1) FROM `MarketHistory` WHERE `PreRate` IS NULL AND `Rate` != -999; 
SELECT * FROM `MarketHistory` WHERE `PreRate` IS NULL AND `Rate` != -999 ORDER BY `MarketDate` DESC;

-- 更新 PreVolume 2502 spend 191 seconds
SELECT COUNT(1) FROM `MarketHistory` WHERE `PreVolume` IS NULL;
UPDATE `MarketHistory` SET `VolumeRate` = `Volume` / `PreVolume` WHERE `VolumeRate` IS NULL AND `PreVolume` IS NOT NULL;
SELECT COUNT(1) FROM `MarketHistory` WHERE `VolumeRate` IS NULL;

-- 关注日期 1450
SELECT * FROM `nanhuacrabstore` ORDER BY `FocusDate` DESC, `StockCode`;

SELECT `MarketHistory`.`StockCode`, `Stock`.`StockName`, `Stock`.`Industry`, `MarketDate`, `PreClose`, `Close`, `Open`, `Low`, `Hign`, `VolumeRate`
FROM `MarketHistory` INNER JOIN `Stock` ON `MarketHistory`.`StockCode` = `Stock`.`StockCode`
WHERE `PreRate` < 1 AND `Rate` > 1 AND `VolumeRate` > 1
AND `MarketDate` = '2015-03-10' AND `MarketHistory`.`StockCode` NOT LIKE 'sz3%'
ORDER BY `VolumeRate` DESC, `MarketHistory`.`StockCode`
LIMIT 0, 10;

-- 买入日期 681 spend 56 seconds
SELECT COUNT(1), COUNT(`BuyDate`) FROM `nanhuacrabstore`;

-- 卖出日期 643 spend 6 seconds
SELECT COUNT(1), COUNT(`BuyDate`), COUNT(`SellDate`) FROM `nanhuacrabstore`;
SELECT `BuyRate`, `SellRate` FROM `nanhuacrabstore` GROUP BY `BuyRate`, `SellRate`;
SELECT `BuyRate`, `SellRate`, COUNT(1) FROM `nanhuacrabstore` WHERE `BuyDate` IS NOT NULL AND `SellDate` IS NULL GROUP BY `BuyRate`, `SellRate`;

-- 最新价格 spend 55 seconds


-- output spend 81 seconds
SELECT * FROM `MarketHistory` WHERE `StockCode` = 'sz002114' AND `MarketDate` > '2014-10-08' ORDER BY `MarketDate` DESC;
UPDATE `nanhuacrabstore` SET `Close` = 0 WHERE `SellDate` IS NOT NULL;
SELECT * FROM `nanhuacrabstore` WHERE `StockCode` IN ( 'sz002114' );
SELECT `BuyRate`, `SellRate` FROM `nanhuacrabstore` GROUP BY `BuyRate`, `SellRate`;

-- -------------------------------------------------------------------------------------------------

SELECT `Month`, COUNT(1) FROM (
SELECT *, DATE_FORMAT(`BuyDate`, '%Y-%m') AS `Month` FROM `nanhuacrabstore` WHERE `BuyRate` = 0.9 AND `SellRate` = 1 AND `BuyDate` IS NOT NULL ) AS T
GROUP BY `Month`
ORDER BY `Month`;

SELECT `Month`, COUNT(1) FROM (
SELECT *, DATE_FORMAT(`SellDate`, '%Y-%m') AS `Month` FROM `nanhuacrabstore` WHERE `BuyRate` = 0.9 AND `SellRate` = 1 AND `SellDate` IS NOT NULL ) AS T
GROUP BY `Month`
ORDER BY `Month`;

SELECT `FocusMonth`, COUNT(`BuyDate`), COUNT(`SellDate`) FROM (
SELECT *, DATE_FORMAT(`FocusDate`, '%Y-%m') AS `FocusMonth` FROM `nanhuacrabstore` WHERE `BuyRate` = 0.9 AND `SellRate` = 1 ) AS T
GROUP BY `FocusMonth`
ORDER BY `FocusMonth`;
