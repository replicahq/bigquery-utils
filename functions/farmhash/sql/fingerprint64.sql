create or replace function `GCP_PROJECT_ID`.farmhash.fingerprint64(str string)
returns string
language js
options (
  library=[
    "GCS_JS_FILE"
  ]
)
as '''
  return farmhash.fingerprint64(str);
''';
