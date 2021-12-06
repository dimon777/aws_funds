CREATE TABLE `investor_return` (
	`fund_id` INT NOT NULL,
	`investor_id` INT NOT NULL,
	`expected_return` DECIMAL NOT NULL,
	`investment_start_dt` DATE NOT NULL,
	`investment_end_dt` DATE,
	`invested_amount` DECIMAL NOT NULL,
	`actual_return_datetm` DATETIME NOT NULL,
	`actual_return` DECIMAL NOT NULL,
	`actual_value` DECIMAL NOT NULL,
	PRIMARY KEY (`fund_id`,`investor_id`)
);

CREATE TABLE `investor` (
	`investor_id` INT NOT NULL,
	`taxid` VARCHAR(255) NOT NULL UNIQUE,
	PRIMARY KEY (`investor_id`)
);

CREATE TABLE `fund` (
	`fund_id` INT NOT NULL UNIQUE,
	`asset_class` VARCHAR(255) NOT NULL UNIQUE,
	PRIMARY KEY (`fund_id`)
);

CREATE TABLE `fund_theme` (
	`theme_name` VARCHAR(255) NOT NULL,
	`fund_id` INT NOT NULL,
	`allocation_start_dt` DATE NOT NULL,
	`allocation_pct` DECIMAL NOT NULL,
	PRIMARY KEY (`theme_name`,`fund_id`,`allocation_start_dt`)
);

CREATE TABLE `bank_info` (
	`investor_id` INT NOT NULL,
	`start_date` DATE NOT NULL,
	`bank_name` VARCHAR(255) NOT NULL,
	`account_num` VARCHAR(255) NOT NULL,
	`routing_num` VARCHAR(255) NOT NULL,
	PRIMARY KEY (`investor_id`,`start_date`)
);

CREATE TABLE `investor_address` (
	`investor_id` INT NOT NULL,
	`start_dt` DATE NOT NULL,
	`address` VARCHAR(255) NOT NULL,
	`state` VARCHAR(255) NOT NULL,
	`country` VARCHAR(255) NOT NULL,
	PRIMARY KEY (`investor_id`,`start_dt`)
);

ALTER TABLE `investor_return` ADD CONSTRAINT `investor_return_fk0` FOREIGN KEY (`fund_id`) REFERENCES `fund`(`fund_id`);

ALTER TABLE `investor_return` ADD CONSTRAINT `investor_return_fk1` FOREIGN KEY (`investor_id`) REFERENCES `investor`(`investor_id`);

ALTER TABLE `fund_theme` ADD CONSTRAINT `fund_theme_fk0` FOREIGN KEY (`fund_id`) REFERENCES `fund`(`fund_id`);

ALTER TABLE `bank_info` ADD CONSTRAINT `bank_info_fk0` FOREIGN KEY (`investor_id`) REFERENCES `investor`(`investor_id`);

ALTER TABLE `investor_address` ADD CONSTRAINT `investor_address_fk0` FOREIGN KEY (`investor_id`) REFERENCES `investor`(`investor_id`);
