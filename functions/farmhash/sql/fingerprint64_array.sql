create or replace function `GCP_PROJECT_ID`.farmhash.fingerprint64_array(strs array<string>)
returns array<string>
language js
options (
  library=[
    "GCS_JS_FILE"
  ]
)
as '''
  return farmhash.fingerprint64_array(strs);
''';
