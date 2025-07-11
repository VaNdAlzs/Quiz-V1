CREATE TABLE IF NOT EXISTS `quiz_ranking` (
  `identifier` VARCHAR(100) PRIMARY KEY,
  `name` VARCHAR(100),
  `points` INT DEFAULT 0
);
