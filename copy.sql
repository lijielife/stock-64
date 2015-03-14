use test;

DESCRIBE `stocktransactiondetail`;

SELECT MIN(`TransactionDate`) FROM `stocktransactiondetail`;

ALTER TABLE `stocktransactiondetail` engine = myisam;

-- 656559
SELECT COUNT(1) FROM `stocktransactiondetail` WHERE `TransactionDate` >= '2012-12-01' AND `TransactionDate` < '2014-02-01';

DESCRIBE `MarketHistory`;

-- DROP TABLE `MarketHistory`;
SELECT MIN(`MarketDate`), MAX(`MarketDate`) FROM `test`.`MarketHistory`;

-- 2479
SELECT DISTINCT(`StockCode`) FROM `MarketHistory`;
SELECT COUNT(1) FROM (
SELECT DISTINCT(`StockCode`) FROM `MarketHistory` ) AS T;

-- 2370 spend 453 seconds
SELECT COUNT(1) FROM `MarketHistory` WHERE `MarketDate` = '2012-12-03';
-- 2479
SELECT COUNT(1) FROM `MarketHistory` WHERE `PreVolume` IS NULL;
SELECT `MarketDate`, COUNT(1) FROM `MarketHistory` WHERE `PreVolume` IS NULL GROUP BY `MarketDate` ORDER BY `MarketDate`;
UPDATE `MarketHistory` SET `VolumeRate` = `Volume` / `PreVolume` WHERE `VolumeRate` IS NULL AND `PreVolume` IS NOT NULL;
SELECT COUNT(1) FROM `MarketHistory` WHERE `VolumeRate` IS NULL;

SELECT `MarketDate`, `Close`, `PreClose`, `Volume`, `PreVolume` 
FROM `MarketHistory` WHERE `StockCode` = 'sz300353' ORDER BY `MarketDate`;

-- 2479
SELECT COUNT(1) FROM `MarketHistory` WHERE `PreClose` = -999;
SELECT COUNT(1) FROM `MarketHistory` WHERE `Rate` IS NULL;
UPDATE `MarketHistory` SET `Rate` = `Close` / `PreClose` WHERE `PreClose` != -999;

-- 4958 spend 407 seconds
SELECT COUNT(1) FROM `MarketHistory` WHERE `PreRate` IS NULL;

SELECT `MarketDate`, `Close`, `PreClose`, `Volume`, `PreVolume`, `Rate`, `PreRate`, `VolumeRate`
FROM `MarketHistory` WHERE `StockCode` = 'sz300353' ORDER BY `MarketDate`;

SELECT COUNT(1) FROM `MarketHistory` WHERE `PreClose` = -999;
SELECT COUNT(1) FROM `nanhuacrabstore`;

-- 2666
SELECT * FROM `stock`.`stock`;
SELECT COUNT(1) FROM `stock`.`stock`;
SELECT * FROM `test`.`stock`;
SELECT COUNT(1) FROM `test`.`stock`;

SELECT * FROM (
SELECT DISTINCT(`MarketDate`) FROM `MarketHistory` ) AS t1
WHERE t1.`MarketDate` NOT IN ( SELECT `StockCode` FROM `stock` );

SELECT COUNT(1) * 5 FROM (
SELECT DISTINCT(`MarketDate`) FROM `MarketHistory` ) AS t1
WHERE t1.`MarketDate` NOT IN ( SELECT `StockCode` FROM `stock` );

INSERT INTO `test`.`stock`( `StockCode`, `StockName`, `Industry`, `TradableShares`, `NegotiableMarket` )
SELECT `StockCode`, `StockName`, `Industry`, `TradableShares`, `NegotiableMarket` FROM `stock`.`stock`;

-- 关注日期 1390 spend 73 seconds
SELECT COUNT(1) FROM `test`.`nanhuacrabstore`;
SELECT * FROM `nanhuacrabstore` ORDER BY `FocusDate` DESC, `StockCode`;
SELECT `focusdate` FROM `nanhuacrabstore` GROUP BY `focusdate` HAVING COUNT(1) < 5;

SELECT COUNT(1) * 5 FROM (
SELECT DISTINCT( `MarketDate` ) FROM `MarketHistory` ) AS T;

SELECT *, COUNT(1) FROM (
SELECT DISTINCT(`MarketDate`) FROM `markethistory` ) AS t1
WHERE t1.`MarketDate` NOT IN ( SELECT `focusdate` FROM `nanhuacrabstore` );

SELECT * FROM `MarketHistory` WHERE `MarketDate` NOT IN ( SELECT `MarketDate` FROM `nanhuacrabstore` );

SELECT `MarketHistory`.`StockCode`, `Stock`.`StockName`, `Stock`.`Industry`, `MarketDate`, `PreClose`, `Close`, `Open`, `Low`, `Hign`, `VolumeRate`
FROM `MarketHistory` INNER JOIN `Stock` ON `MarketHistory`.`StockCode` = `Stock`.`StockCode`
WHERE `PreRate` < 1 AND `Rate` > 1 AND `VolumeRate` > 1
AND `MarketDate` = '2012-12-05' AND `MarketHistory`.`StockCode` NOT LIKE 'sz3%'
ORDER BY `VolumeRate` DESC, `MarketHistory`.`StockCode`
LIMIT 0, 1;

-- spend 110 seconds
-- spend 73 seconds
SELECT `BuyRate`, `SellRate`, COUNT(1), COUNT(`BuyDate`), COUNT(`SellDate`), COUNT(`SellDate`) / COUNT(`BuyDate`)
FROM `nanhuacrabstore` GROUP BY `BuyRate`, `SellRate`;

SELECT COUNT(1), COUNT(`Close`) FROM `test`.`nanhuacrabstore`;
SELECT * FROM `nanhuacrabstore` WHERE `Close` IS NULL;
SELECT * FROM `nanhuacrabstore` WHERE `Close` IS NULL;

SELECT * FROM `MarketHistory_2013` WHERE `StockCode` = 'sh600651' ORDER BY `MarketDate` DESC LIMIT 0, 1;
