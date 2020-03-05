FROM rust:slim as compiled-wasm
WORKDIR /usr/src/app
RUN apt-get update && apt-get install -y curl && \
    curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
COPY rs/Cargo.toml rs/Cargo.lock ./
# For some reason, `wasm-pack build` is flakey about the Cargo.toml. Sometimes it'll error about a `crate-type` setting
# in the config file that is already set, but will work after a retry. If you see the below, just retry building:
#
#    Error: crate-type must be cdylib to compile to wasm32-unknown-unknown. Add the following to your Cargo.toml file:
#
#    [lib]
#    crate-type = ["cdylib", "rlib"]
RUN mkdir src && \
    touch src/lib.rs && \
    wasm-pack build --release --target no-modules && \
    rm -rf src
COPY rs/src src
# The rust compiler uses mtime to determine if it should re-compile (like make). So, bump the copied src mtime to
# trigger a rebuild with the actual lib.
RUN touch src/* && \
    wasm-pack build --release --target no-modules

FROM node:slim
WORKDIR /usr/src/app
RUN npm install -g browserify
COPY --from=compiled-wasm /usr/src/app/pkg/farmhash.js /usr/src/app/pkg/farmhash_bg.wasm wasm/
COPY js/convert.js js/package.json js/package-lock.json js/test.js ./
RUN npm install && \
    node convert.js \
      | browserify --bare --standalone farmhash - > farmhash.bundle.js && \
    rm -rf node_modules && \
    node test.js
CMD ["cat", "farmhash.bundle.js"]

# fh = require("./farmhash.bundle")
# fh.wasm_bindgen.fingerprint64('hi')
# var v = fh.wasm.then((bind) => {return bind.fingerprint64('hi');}).then((v) => console.log(v))
# fh.wasm.then(() => {fh.wasm_bindgen.fingerprint64('hi');}).then((v) => console.log(v))
