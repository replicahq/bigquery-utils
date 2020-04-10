create or replace function `GCP_PROJECT_ID`.farmhash.int64ToUint64String(num int64)
returns string
language js
options (
  library=[
    "GCS_JS_FILE"
  ]
)
as '''
  return int64ToUint64String(num);
''';
