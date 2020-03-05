// Remove the node versions to test the bundled polyfill.
delete TextEncoder;
delete TextDecode;

const farmhash = require("./farmhash.bundle")
functions = [
    {
        expected: "7664334617921458936",
        fn: farmhash.fingerprint64,
        input: "hi",
        name: 'fingerprint64',
    },
    {
        expected: ["2333338297035482505", "5453616552587120769", "8449584838191175720"],
        fn: farmhash.fingerprint64_array,
        input: ["one", "two", "three"],
        name: 'fingerprint64_array',
    },
]

console.log(farmhash);
functions.forEach(({expected, fn, input, name}) => {
    fn(input).then((output) => {
        if (JSON.stringify(output) !== JSON.stringify(expected)) {
            console.log(`Expected ${expected}, got ${output}`);
            process.exit(1);
        };
        console.log(`${name}('${input}') -> ${output}`);
    });
});
