# Security

The runtime component renders SVG markup from a pinned, generated, embedded catalog. Do not pass arbitrary untrusted SVG markup into the library.

The repository verifier rejects script elements, inline event-handler attributes, `javascript:` URLs, and `foreignObject` in generated icon bodies.

For a private security report, use the security contact mechanism of the repository that hosts this source.
