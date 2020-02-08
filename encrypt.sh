#!/bin/bash

password="$1" plaintext="$2"
echo "$plaintext" | \
	openssl aes-256-ctr -e -base64 -pass "pass:$password"
