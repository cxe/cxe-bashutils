#!/usr/bin/env bash

source "${BASH_SOURCE[0]%/*}/../lib/testing"
source "${BASH_SOURCE[0]%/*}/../lib/core"

# Example Tests
describe "typeof"
    describe "bar"
        it "should detect strings"
            expect "$( typeof foo )" toBe "string"
        ti
    describe
describe

describe "stream_into"
    it "should be red"
        expect "foo" toBe "bar"
    ti
describe
