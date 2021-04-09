create or replace function `GCP_PROJECT_ID`.farmhash.fingerprint64(str string)
returns string
as (
  CASE WHEN farm_fingerprint(str) < 0 THEN `GCP_PROJECT_ID`.farmhash.int64ToUint64String(farm_fingerprint(str)) ELSE farm_fingerprint(str) END
);
