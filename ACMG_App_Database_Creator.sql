CREATE TABLE `acmg_genes` (
  `ag_gene_id` int NOT NULL AUTO_INCREMENT,
  `ag_gene_name` varchar(255) DEFAULT 'NA',
  `ag_archive` varchar(255) DEFAULT 'false',
  `ag_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `ag_date_lastupdated` datetime DEFAULT CURRENT_TIMESTAMP,
  `ag_description` varchar(255) DEFAULT 'NA',
  PRIMARY KEY (`ag_gene_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into acmg_genes(ag_gene_name)
select distinct atgdi10_gene_id_name
from acmg_temp_gene_disease_icd_10;

CREATE TABLE `acmg_diseases` (
  `ad_disease_id` int NOT NULL AUTO_INCREMENT,
  `ad_disease_name` varchar(255) DEFAULT 'NA',
  `ad_archive` varchar(255) DEFAULT 'false',
  `ad_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `ad_date_lastupdated` datetime DEFAULT CURRENT_TIMESTAMP,
  `ad_description` varchar(255) DEFAULT 'NA',
  PRIMARY KEY (`ad_disease_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into acmg_diseases(ad_disease_name)
select distinct atgdi10_disease_id_name
from acmg_temp_gene_disease_icd_10;

CREATE TABLE `acmg_icd_9` (
  `ai9_icd_9_id` int NOT NULL AUTO_INCREMENT,
  `ai9_icd_9_name` varchar(255) DEFAULT 'NA',
  `ai9_description` varchar(255) DEFAULT 'NA',
  `ai9_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `ai9_date_lastupdated` datetime DEFAULT CURRENT_TIMESTAMP,
  `ai9_archive` varchar(255) DEFAULT 'false',
  PRIMARY KEY (`ai9_icd_9_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into acmg_icd_9(ai9_icd_9_name)
select distinct atgdi9_icd9_id_name
from temp_acmg_gene_disease_icd_9 
where temp_acmg_gene_disease_icd_9.atgdi9_icd9_id_name not like 'NA';

CREATE TABLE `acmg_icd_10` (
  `ai10_icd_10_id` int NOT NULL AUTO_INCREMENT,
  `ai10_icd_10_name` varchar(255) DEFAULT 'NA',
  `ai10_archive` varchar(255) DEFAULT 'false',
  `ai10_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `ai10_date_lastupdated` datetime DEFAULT CURRENT_TIMESTAMP,
  `ai10_description` varchar(255) DEFAULT 'NA',
  PRIMARY KEY (`ai10_icd_10_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into acmg_icd_10(ai10_icd_10_name)
select distinct atgdi10_icd10_id_name
from acmg_temp_gene_disease_icd_10
where acmg_temp_gene_disease_icd_10.atgdi10_icd10_id_name not like 'NA';

CREATE TABLE `acmg_gene_disease` (
  `agd_gene_disease_id` int NOT NULL AUTO_INCREMENT,
  `agd_gene_id_name` varchar(255) DEFAULT 'NA',
  `agd_disease_id_name` varchar(255) DEFAULT 'NA',
  `agd_archive` varchar(255) DEFAULT 'false',
  `agd_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `agd_date_lastupdated` datetime DEFAULT CURRENT_TIMESTAMP,
  `agd_description` varchar(255) DEFAULT 'NA',
  PRIMARY KEY (`agd_gene_disease_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into acmg_gene_disease(agd_gene_id_name, agd_disease_id_name)
select distinct CONCAT(gs.ag_gene_id, "_", gs.ag_gene_name),
concat(ds.ad_disease_id, "_", ds.ad_disease_name)
from acmg_genes gs, acmg_diseases ds, acmg_temp_gene_disease_icd_10 temp
where gs.ag_gene_name = temp.atgdi10_gene_id_name
and ds.ad_disease_name = temp.atgdi10_disease_id_name;

CREATE TABLE `acmg_gene_disease_icd_9` (
  `agdi9_id` int NOT NULL AUTO_INCREMENT,
  `agdi9_gene_id_name` varchar(255) DEFAULT 'NA',
  `agdi9_disease_id_name` varchar(255) DEFAULT 'NA',
  `agdi9_icd9_id_name` varchar(255) DEFAULT 'NA',
  `agdi9_archive` varchar(255) DEFAULT 'false',
  `agdi9_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `agdi9_date_lastupdated` datetime DEFAULT CURRENT_TIMESTAMP,
  `agdi9_description` varchar(255) DEFAULT 'NA',
  PRIMARY KEY (`agdi9_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into acmg_gene_disease_icd_9(agdi9_gene_id_name, agdi9_disease_id_name, agdi9_icd9_id_name)(
select agd.agd_gene_id_name, agd.agd_disease_id_name, IFNULL(concat(ai9.ai9_icd_9_ID, "_", ai9.ai9_icd_9_name), 'NA')
from acmg_gene_disease agd
inner join acmg_temp_gene_disease_icd_9 i9
on i9.atgdi9_gene_id_name = substring(agd.agd_gene_id_name, locate("_", agd.agd_gene_id_name)+1)
and i9.atgdi9_disease_id_name = substring(agd.agd_disease_id_name, locate("_", agd.agd_disease_id_name)+1)
left join acmg_icd_9 ai9
on i9.atgdi9_icd9_id_name = ai9.ai9_icd_9_name);

CREATE TABLE `acmg_gene_disease_icd_10` (
  `agdi10_id` int NOT NULL AUTO_INCREMENT,
  `agdi10_gene_id_name` varchar(255) DEFAULT 'NA',
  `agdi10_disease_id_name` varchar(255) DEFAULT 'NA',
  `agdi10_icd10_id_name` varchar(255) DEFAULT 'NA',
  `agdi10_archive` varchar(255) DEFAULT 'false',
  `agdi10_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `agdi10_date_lastupdated` datetime DEFAULT CURRENT_TIMESTAMP,
  `agdi10_description` varchar(255) DEFAULT 'NA',
  PRIMARY KEY (`agdi10_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into acmg_gene_disease_icd_10(agdi10_gene_id_name, agdi10_disease_id_name, agdi10_icd10_id_name)(
select agd.agd_gene_id_name, agd.agd_disease_id_name, IFNULL(concat(ai10.ai10_icd_10_ID, "_", ai10.ai10_icd_10_name), 'NA')
from acmg_gene_disease agd
inner join acmg_temp_gene_disease_icd_10 i10
on i10.atgdi10_gene_id_name = substring(agd.agd_gene_id_name, locate("_", agd.agd_gene_id_name)+1)
and i10.atgdi10_disease_id_name = substring(agd.agd_disease_id_name, locate("_", agd.agd_disease_id_name)+1)
left join acmg_icd_10 ai10
on i10.atgdi10_icd10_id_name = ai10.ai10_icd_10_name);

CREATE TABLE `acmg_gene_disease_icd_9_icd_10` (
  `agdi9i10_id` int NOT NULL AUTO_INCREMENT,
  `agdi9i10_gene_id_name` varchar(255) DEFAULT 'NA',
  `agdi9i10_disease_id_name` varchar(255) DEFAULT 'NA',
  `agdi9i10_icd9_id_name` varchar(255) DEFAULT 'NA',
  `agdi9i10_icd10_id_name` varchar(255) DEFAULT 'NA',
  `agdi9i10_archive` varchar(255) DEFAULT 'false',
  `agdi9i10_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `agdi9i10_date_lastupdated` datetime DEFAULT CURRENT_TIMESTAMP,
  `agdi9i10_description` varchar(255) DEFAULT 'NA',
  PRIMARY KEY (`agdi9i10_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
