-- Example usage:
-- SELECT bqutils.string.decode_openlr('CwNhbCU+jzPLAwD0/34zGw==') as decoded_location;
CREATE OR REPLACE FUNCTION bqutils.string.decode_openlr(openLRString STRING)
RETURNS JSON
LANGUAGE js
OPTIONS (
  library=["https://storage.googleapis.com/bqutils.replicahq.com/openlr-js.min.js"]
)
AS r"""
  try {
    const binaryDecoder = new OpenLR.BinaryDecoder();
    const openLrBinary = OpenLR.Buffer.from(openLRString, 'base64');
    const locationReference = OpenLR.LocationReference.fromIdAndBuffer('binary', openLrBinary);
    const rawLocationReference = binaryDecoder.decodeData(locationReference);
    return OpenLR.Serializer.serialize(rawLocationReference);
  } catch (error) {
    return {
      error: 'Failed to decode OpenLR: ' + error.message
    };
  }
""";
