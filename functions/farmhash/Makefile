GCS_JS_FILE="gs://${GCS_BUCKET}/farmhash.bundle.js"

all: generate upload

generate:
	docker build -t farmhash-wasm .
	mkdir -p generated
	docker run --rm farmhash-wasm > generated/farmhash.bundle.js

upload:
	gsutil cp generated/farmhash.bundle.js "${GCS_JS_FILE}"
	find sql/*.sql -print0 \
	  | xargs -0 -I {} \
	    sed \
	      -e "s/GCP_PROJECT_ID/${GCP_PROJECT_ID}/g" \
	      -e "s#GCS_JS_FILE#${GCS_JS_FILE}#g" \
	      {} \
	  | bq query

clean:
	rm -rf generated
