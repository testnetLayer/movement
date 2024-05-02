// Copyright 2024 RISC Zero, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0

// This file is automatically generated by:
// cargo xtask bootstrap-groth16

pragma solidity ^0.8.13;

library TestReceipt {
    bytes public constant SEAL =
        hex"16542a20d91154d977fb6215f8366e48f9034afb2c71c20b6b3080dc30e981252e9fa9660f4a378686b14afb1e0092180bef679a07752939f832283929011eb006796cca253ca629c6d5b2852b30370427d19c32f5a0fa7b791f68db789b775b20308dc1c19af9f2198e1d99c85be7771d63779bea244c7cf097bb90902601a601dc9c4464c797022372c3c3e9be96ff4cfec8a2a33161eae9e62c9d9175bbdc27839ff9bfbd03554980bec8affc43b4dba3e06e9ce201d0269fa3fd82157d5b091f9f0971190b276a4038f182855fc5f67ba806cdd2760d90d3eb4ef57e090f02ca9ee4e7120f6ca7ce7f5b901dfc2aa1df72aaeb78c44353d449134c363efa";
    bytes32 public constant POST_DIGEST = bytes32(0x41b150d6ac003f55763d57ee5512652b0446d6c7bd2789e8c0c1f4a5bb3e87d8);
    bytes public constant JOURNAL = hex"";
    bytes32 public constant IMAGE_ID = bytes32(0x790b91e4c2efa939aea3ee4989c82564d82047977970d014e53d95e44c3230db);
}