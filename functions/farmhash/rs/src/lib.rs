use farmhash;
use js_sys::Array;
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn fingerprint64(string: &str) -> String {
    return farmhash::fingerprint64(string.as_bytes()).to_string();
}

#[wasm_bindgen]
pub fn fingerprint64_array(strings: Array) -> Array {
    return strings.iter().map(|s| JsValue::from(fingerprint64(&s.as_string().unwrap()))).collect()
}
