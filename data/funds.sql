fund_id, asset_class
'1', 'equity'
'2', 'fixed income' themes: commercial, residential
'3', 'real estate'
'4', 'commodities'
'5', 'futures'
'6', 'cryto'

INSERT INTO fund (fund_id, asset_class) 
VALUES 
(1, 'equity'),
(2, 'fixed income'),
(3, 'real estate'),
(4, 'commodities'),
(5, 'futures'),
(6, 'cryto');

INSERT INTO fund_theme (
    `fund_id`,
    `theme_name`,
	`allocation_start_dt`,
	`allocation_pct`
)
VALUES
(1, 'growth', now(), 20),
(1, 'utilities', now(), 20),
(1, 'dividend stocks', now(), 60),
(2, 'AA corp bonds', now(), 30),
(2, 'junk bonds', now(), 30),
(2, 'minucipal bonds', now(), 40),
(3, 'commercial real estate', now(), 50),
(3, 'residential real estate', now(), 50),
(4, 'industrial commodities', now(), 40),
(4, 'agricultural commodities', now(), 60),
(6, 'bitcoin', now(), 50),
(6, 'alt coins', now(), 25),
(6, 'shit coins', now(), 25);



INSERT INTO `investor` (`investor_id`, `taxid`)
VALUES
(1, '123-456-7890'),
(2, '123-456-7891'),
(3, '123-456-7892'),
(4, '123-456-7893'),
(5, '123-456-7894'),
(6, '123-456-7895'),
(7, '123-456-7896'),
(8, '123-456-7897'),
(9, '123-456-7898'),
(10, '123-456-7899');


INSERT INTO `bank_info` (
	`investor_id`,
	`start_date`,
	`bank_name`,
	`account_num`,
	`routing_num`)
VALUES
(1, '2020-01-01', 'bank1', 'account1', 'routing1'),
(2, '2020-01-02', 'bank2', 'account2', 'routing2'),
(3, '2020-01-03', 'bank3', 'account3', 'routing3'),
(4, '2020-01-04', 'bank4', 'account4', 'routing4'),
(5, '2020-01-05', 'bank5', 'account5', 'routing5'),
(6, '2020-01-06', 'bank6', 'account6', 'routing6'),
(7, '2020-01-07', 'bank7', 'account7', 'routing7'),
(8, '2020-01-08', 'bank8', 'account8', 'routing8'),
(9, '2020-01-09', 'bank9', 'account9', 'routing9'),
(10, '2020-01-10', 'bank10', 'account10', 'routing10');

INSERT INTO `investor_address` (
	`investor_id`,
	`start_dt`,
	`address`,
	`state`,
	`country`)
VALUES
(1, '2020-01-01', 'address1', 'CT', 'US'),
(2, '2020-01-02', 'address2', 'NY', 'US'),
(3, '2020-01-03', 'address3', 'NJ', 'US'),
(4, '2020-01-04', 'address4', 'MA', 'US'),
(5, '2020-01-05', 'address5', null, 'JP'),
(6, '2020-01-06', 'address6', 'FL', 'US'),
(7, '2020-01-07', 'address7', null, 'ES'),
(8, '2020-01-08', 'address8', null, 'RU'),
(9, '2020-01-09', 'address9', null, 'JP'),
(10, '2020-01-10', 'address10', null, 'GB');


INSERT INTO `investor_return` (
	`fund_id`,
	`investor_id`,
	`expected_return`,
	`investment_start_dt`,
	`investment_end_dt`,
	`invested_amount`,
	`actual_return_datetm`,
	`actual_return`,
	`actual_value`)
VALUES
(1, 1, 1.0, '2020-01-01', null, 100, '2020-01-01 04:00:00', 1.5, 150),
(1, 2, 2.0, '2020-01-01', null, 200, '2020-01-01 04:00:00', 2.5, 250),
(2, 3, 3.0, '2020-01-01', null, 300, '2020-01-01 04:00:00', 3.5, 350),
(3, 4, 4.0, '2020-01-01', null, 400, '2020-01-01 04:00:00', 4.5, 450),
(4, 5, 5.0, '2020-01-01', null, 500, '2020-01-01 04:00:00', 5.5, 550),
(4, 6, 6.0, '2020-01-01', null, 600, '2020-01-01 04:00:00', 6.5, 650),
(5, 7, 7.0, '2020-01-01', null, 700, '2020-01-01 04:00:00', 7.5, 750),
(5, 8, 8.0, '2020-01-01', null, 800, '2020-01-01 04:00:00', 8.5, 850),
(6, 9, 9.0, '2020-01-01', null, 900, '2020-01-01 04:00:00', 9.5, 1000),
(6, 10, 10.0, '2020-01-01', null, 1000, '2020-01-01 04:00:00', 10.5, 1100);
