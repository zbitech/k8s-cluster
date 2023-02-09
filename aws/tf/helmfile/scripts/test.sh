#!/bin/bash

echo "Running test scripts"

echo ACME URL: {{ tpl .Environment.Values.certs.acmeDriverURL}}
echo ISSUER EMAIL: {{ tpl .Environment.Values.certs.issuerEmail}}
