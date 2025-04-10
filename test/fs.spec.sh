#!/usr/bin/env bash

source "${BASH_SOURCE[0]%/*}/../lib/testing"
source "${BASH_SOURCE[0]%/*}/../lib/fs"

describe "fs"
    describe "url_parse"
        it "should parse a valid URL"
            declare -A f; url_parse -n f "https://un:pw@Sup.Sub.EXAMPLE.COM:8443/path/File.ext#Anchor?q=1&l=en"
            expect "${f[query]}" toBe 'q=1&l=en'
            expect "${f[pass]}" toBe 'pw'
            expect "${f[file]}" toBe 'file.ext'
            expect "${f[scheme]}" toBe 'https'
            expect "${f[path]}" toBe '/path/file.ext'
            expect "${f[domain]}" toBe 'example.com'
            expect "${f[port]}" toBe '8443'
            expect "${f[hostname]}" toBe 'sup.sub.example.com'
            expect "${f[ext]}" toBe '.ext'
            expect "${f[tld]}" toBe '.com'
            expect "${f[frag]}" toBe 'Anchor'
            expect "${f[host]}" toBe 'sup.sub.example.com:8443'
            expect "${f[subdomain]}" toBe 'sup.sub'
            expect "${f[user]}" toBe 'un'
        ti
    describe
describe