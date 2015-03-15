
-- copy 历史数据 2014 662513
SELECT COUNT(1) FROM `test`.`stocktransactiondetail` 
WHERE `TransactionDate` >= '2013-12-01' AND `TransactionDate` < '2015-02-01';
-- TRUNCATE `stock`.`MarketHistory_2014`;
INSERT INTO `stock`.`MarketHistory_2014` ( `StockCode`, `MarketDate`, `PreClose`, `Open`, `Close`, `Hign`, `Low`, `Volume`, `Amount` )
SELECT `Code`, `TransactionDate`, -999, `BeginPrice`, `EndPrice`, `HighestPrice`, `LowestPrice`, `Volume`, `TransactionMoney`
FROM `test`.`stocktransactiondetail` 
WHERE `TransactionDate` >= '2013-12-01' AND `TransactionDate` < '2015-02-01';

SELECT COUNT(1) FROM `stock`.`MarketHistory_2014`;

SELECT MIN(`StockCode`), MAX(`StockCode`) FROM `stock`.`MarketHistory_2014` WHERE `StockCode` >= '600000';

UPDATE `stock`.`MarketHistory_2014`
SET `StockCode` = CONCAT('sh', `StockCode` )
WHERE `StockCode` >= '600000';

SELECT MIN(`StockCode`), MAX(`StockCode`) FROM `stock`.`MarketHistory_2014` WHERE `StockCode` < '600000';

UPDATE `stock`.`MarketHistory_2014`
SET `StockCode` = CONCAT('sz', `StockCode` )
WHERE `StockCode` < '600000';

SELECT MIN(`StockCode`), MAX(`StockCode`) FROM `stock`.`MarketHistory_2014`;

-- 239582
SELECT COUNT(1) FROM `stock`.`MarketHistory_2014`;

SELECT MIN(`MarketDate`), MAX(`MarketDate`) FROM `stock`.`MarketHistory_2014`;

-- 查询结果 2585
SELECT DISTINCT(`StockCode`) FROM `stock`.`MarketHistory_2014`;
SELECT COUNT(1) FROM ( SELECT DISTINCT(`StockCode`) FROM `stock`.`MarketHistory_2014` ) AS T;

-- 更新 PreClose / PreVolume spend 185 seconds
SELECT `StockCode`, `MarketDate`, `Close`, `PreClose`, `Volume`, `PreVolume`, `Rate`, `PreRate`, `VolumeRate` 
FROM `stock`.`MarketHistory_2014` WHERE `StockCode` = 'sz000678' 
ORDER BY `MarketDate`;

SELECT COUNT(1) FROM `stock`.`MarketHistory_2014` WHERE `PreClose` = -999;

-- 更新 Rate
SELECT COUNT(1) FROM `stock`.`MarketHistory_2014` WHERE `Rate` IS NULL;

UPDATE `stock`.`MarketHistory_2014` 
SET `Rate` = `Close` / `PreClose` 
WHERE `PreClose` != -999;

-- 更新 VolumeRate
SELECT COUNT(1) FROM `stock`.`MarketHistory_2014` WHERE `VolumeRate` IS NULL;

UPDATE `stock`.`MarketHistory_2014` 
SET `VolumeRate` = `Volume` / `PreVolume` 
WHERE `VolumeRate` IS NULL AND `PreVolume` IS NOT NULL;

-- 5170 spend 208 seconds
SELECT COUNT(1) FROM `stock`.`MarketHistory_2014` WHERE `PreRate` IS NULL;

SELECT `StockCode` 
FROM `stock`.`MarketHistory_2014` 
WHERE `PreRate` IS NULL
GROUP BY `StockCode`
HAVING COUNT(1) < 2
ORDER BY `StockCode`, `MarketDate`;

SELECT * FROM `stock`.`MarketHistory_2014` WHERE `StockCode` IN ( 'sh600313' ) ORDER BY `MarketDate`;

-- 历史纪录的天数 287
SELECT COUNT(1) FROM ( SELECT DISTINCT(`MarketDate`) FROM `stock`.`MarketHistory_2014` ) AS T;

-- 历史纪录中有效的天数 285
SELECT DISTINCT(`MarketDate`)
FROM `stock`.`MarketHistory_2014` 
WHERE `PreRate` < 1 AND `Rate` > 1 AND `VolumeRate` > 1
ORDER BY `MarketDate`;

SELECT COUNT(1) FROM (
SELECT DISTINCT(`MarketDate`)
FROM `stock`.`MarketHistory_2014` 
WHERE `PreRate` < 1 AND `Rate` > 1 AND `VolumeRate` > 1
ORDER BY `MarketDate`
) AS T;

SELECT `StockCode`, `MarketDate`, `Close`, `PreClose`, `Volume`, `PreVolume`, `Rate`, `PreRate`, `VolumeRate` 
FROM `stock`.`MarketHistory_2014` WHERE `StockCode` = 'sz000678' 
ORDER BY `MarketDate`;

-- 历史纪录中有效的天数 1425 5X
SELECT COUNT(1) FROM `stock`.`nanhuacrabstore_2014`;

-- 2666
SELECT * FROM `stock`.`stock`;
SELECT COUNT(1) FROM `stock`.`stock`;

SELECT * FROM ( SELECT DISTINCT(`StockCode`) FROM `stock`.`MarketHistory_2014` ) AS t1
WHERE t1.`StockCode` NOT IN ( SELECT `StockCode` FROM `stock`.`stock` );

-- 历史纪录中有效的天数 1425 10+
SELECT * FROM (
SELECT DISTINCT(`MarketDate`) FROM `stock`.`MarketHistory_2014` ) AS t1
WHERE t1.`MarketDate` NOT IN ( SELECT DISTINCT( `FocusDate` ) FROM `stock`.`nanhuacrabstore_2014` );

SELECT COUNT(1) * 5 FROM (
SELECT DISTINCT(`MarketDate`) FROM `stock`.`MarketHistory_2014` ) AS t1
WHERE t1.`MarketDate` NOT IN ( SELECT DISTINCT( `FocusDate` ) FROM `stock`.`nanhuacrabstore_2014` );

SELECT `StockCode`, `MarketDate`, `Close`, `PreClose`, `Volume`, `PreVolume`, `Rate`, `PreRate`, `VolumeRate` 
FROM `stock`.`MarketHistory_2014`
WHERE `Rate` > 1 AND `VolumeRate` > 1 AND `MarketDate` = '2003-01-14';

SELECT * FROM `stock`.`nanhuacrabstore_2014` WHERE `BuyRate` = 0 AND `SellRate` = 0 ORDER BY `FocusDate`;
SELECT * FROM `stock`.`nanhuacrabstore` WHERE `BuyRate` = 0 AND `SellRate` = 0 ORDER BY `FocusDate`;
SELECT * FROM `stock`.`MarketHistory_2014` WHERE `MarketDate` = '2014-01-02' AND `StockCode` IN ( 'sh600345', 'sh600038' );
SELECT * FROM `stock`.`MarketHistory` WHERE `MarketDate` = '2014-01-02' AND `StockCode` IN ( 'sh600345', 'sh600038' );

SELECT * FROM `stock`.`nanhuacrabstore` WHERE `FocusDate` < '2014-12-01';
DELETE FROM `stock`.`nanhuacrabstore` WHERE `FocusDate` < '2014-12-01';

SELECT * FROM `stock`.`MarketHistory` WHERE `MarketDate` < '2014-12-01';
DELETE FROM `stock`.`MarketHistory` WHERE `MarketDate` < '2014-12-01';

SELECT * FROM `stock`.`MarketHistory` WHERE `StockCode` = 'sh600066' ORDER BY `MarketDate`;


SELECT `Stock`.`StockCode`, `Stock`.`StockName`, `Stock`.`Industry`, `MarketDate`, 
		`PreClose`, `Close`, `Open`, `Low`, `Hign`, `VolumeRate`
FROM `stock`.`MarketHistory_2014` AS `MarketHistory` INNER JOIN `stock`.`Stock` ON `MarketHistory`.`StockCode` = `Stock`.`StockCode`
WHERE `PreRate` < 1 AND `Rate` > 1 AND `VolumeRate` > 1
AND `MarketDate` = '2014-01-02' AND `Stock`.`StockCode` NOT LIKE 'sz3%'
ORDER BY `VolumeRate` DESC, `Stock`.`StockCode`
LIMIT 0, 1;

SELECT `Stock`.`StockCode`, `Stock`.`StockName`, `Stock`.`Industry`, `MarketDate`, 
		`PreClose`, `Close`, `Open`, `Low`, `Hign`, `VolumeRate`
FROM `stock`.`MarketHistory` AS `MarketHistory` INNER JOIN `stock`.`Stock` ON `MarketHistory`.`StockCode` = `Stock`.`StockCode`
WHERE `PreRate` < 1 AND `Rate` > 1 AND `VolumeRate` > 1
AND `MarketDate` = '2014-01-02' AND `Stock`.`StockCode` NOT LIKE 'sz3%'
ORDER BY `VolumeRate` DESC, `Stock`.`StockCode`
LIMIT 0, 1;

-- 关注日期 1415 spend 85 seconds
SELECT COUNT(1) FROM `stock`.`nanhuacrabstore_2014`;
SELECT * FROM `stock`.`nanhuacrabstore_2014` ORDER BY `FocusDate` DESC, `StockCode`;
SELECT `focusdate` FROM `stock`.`nanhuacrabstore_2014` GROUP BY `focusdate` HAVING COUNT(1) < 5;

SELECT COUNT(1) * 5 FROM (
SELECT DISTINCT( `MarketDate` ) FROM `stock`.`MarketHistory_2014` ) AS T;

SELECT *, COUNT(1) FROM (
SELECT DISTINCT(`MarketDate`) FROM `markethistory` ) AS t1
WHERE t1.`MarketDate` NOT IN ( SELECT `focusdate` FROM `nanhuacrabstore` );

SELECT * FROM `MarketHistory` WHERE `MarketDate` NOT IN ( SELECT `MarketDate` FROM `nanhuacrabstore` );

-- init spend 68 seconds
-- buy spend 100 seconds
-- sell spend 95 seconds
-- close spend 26 seconds
-- out spend 60 seconds
SELECT `BuyRate`, `SellRate`, COUNT(1), COUNT(`BuyDate`) / COUNT(1), COUNT(`BuyDate`), COUNT(`SellDate`), COUNT(`SellDate`) / COUNT(`BuyDate`), COUNT(`Close`)
FROM `stock`.`nanhuacrabstore_2014` GROUP BY `BuyRate`, `SellRate`;

-- spend 40 seconds
SELECT COUNT(1), COUNT(`Close`) FROM `test`.`nanhuacrabstore`;
SELECT * FROM `nanhuacrabstore` WHERE `Close` IS NULL;
SELECT * FROM `nanhuacrabstore` WHERE `Close` IS NULL;

SELECT * FROM `MarketHistory_2014` WHERE `StockCode` = 'sh600651' ORDER BY `MarketDate` DESC LIMIT 0, 1;















