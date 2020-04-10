create or replace function `GCP_PROJECT_ID`.farmhash.fingerprint64(str string)
returns string
as (
  `GCP_PROJECT_ID`.farmhash.int64ToUint64String(farm_fingerprint(str))
);
