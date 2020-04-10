create or replace function `GCP_PROJECT_ID`.farmhash.fingerprint64_array(strs array<string>)
returns array<string>
as (
  (
    select array_agg(`GCP_PROJECT_ID`.farmhash.int64ToUint64String(farm_fingerprint(s)))
    from unnest(strs) s
  )
);
