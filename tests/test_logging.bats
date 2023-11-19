#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "Test log_info high verbosity" {
    VERBOSITY=1
    run log_info "test"
    assert_output --partial "test"
}

@test "Test log_info low verbosity" {
    VERBOSITY=0
    run log_info "test"
    refute_output --partial "test"
}

@test "Test log_debug high verbosity" {
    VERBOSITY=2
    run log_debug "test"
    assert_output --partial "test"
}

@test "Test log_debug low verbosity" {
    VERBOSITY=0
    run log_debug "test"
    refute_output --partial "test"
}

@test "Test log_error high verbosity" {
    VERBOSITY=2
    run log_error "test"
    assert_output --partial "test"
    assert_failure 1
}

@test "Test log_error low verbosity exit code" {
    VERBOSITY=-1
    run log_error "test" 2
    refute_output --partial "test"
    assert_failure 2
}

@test "Test log_warning high verbosity" {
    VERBOSITY=1
    run log_warning "test"
    assert_output --partial "test"
}

@test "Test log_warning low verbosity" {
    VERBOSITY=0
    run log_warning "test"
    refute_output --partial "test"
}
