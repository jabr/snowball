# A better time-based UUID format

> **Update:** [UUIDv7 has since been defined which uses the 48 most significant bits for time.](https://www.rfc-editor.org/rfc/rfc9562.html#section-5.7) You probably want to use that format instead, though the format described here does still have some advantages over it (e.g. 64 bits for time with versionable interpretations).

There are four defined variants of UUID (and one special case for all 0's). Type 2 is the variant commonly used today. While some versions of variant 2 encode the time, it does so in an unfortunate way: the most significant bits of the UUID are not the most significant bits of the time. The time has to be extracted before it can be compared. A UUID format that can be naturally sorted by time would be preferable for many applications.

The type 0 variant of UUIDs encodes time more sensibly, but has its own problems. It has no support for versioning or sequence counters, and only uses 48 bits for time (in a fixed 4 microsecond "unit"), resulting in a 35 year window.

Type 7 is reserved for future use, and type 6 is reserved for Microsoft as some of their core COM components had GUIDs that fell under that variant (e.g. IUnknown). However, there is no defined internal structure for variant 6, so they are effectively opaque identifiers with no meaning outside of Microsoft's COM. Therefore, if a system will never need to encode references to Microsoft COM components, it is free to reinterpret the meaning of variant 6 UUIDs without any worry of conflicts.

Snowball is a non-Microsoft interpretation of variant 6 UUIDs, which are effectively a 16 byte version of Twitter's 8 byte [Snowflake](https://github.com/twitter/snowflake).

The format in MSB order:

* 64 bits of time
* 3 bits for the UUID variant (110)
* 5 bits for the UUID version
* 48 bits for the node/spatial identifier
* 8 bits for the sequence counter

Version 0 of Snowball defines the time component as the number of microseconds since the Unix epoch, resulting in a ~292 thousand year window.

The sequence counter is incremented when more than one UUID needs to be generated for the same time value. If the counter would roll over, the implementation should wait until the time value increments. This gives us a maximum capacity of 256 million IDs per second per generating instance.

The internals of the node/spatial identifier are undefined in version 0, but implementations should attempt to provide a unique identifier for every generating instance.

## License

This project is licensed under the terms of the [MIT license](LICENSE.txt).
