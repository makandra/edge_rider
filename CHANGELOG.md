# Changelog
All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased

### Breaking changes
- Drop support for Ruby < 2.7

### Compatible changes
- Add support for Ruby 4.0
- Add support for Rails 8.1


## 2.4.0 - 2025-01-29

### Breaking changes

- Drop support for Rails < 6.1. This also drops support for MySQL, which had only been present for Rails < 6.

### Compatible changes

- Add support for Rails 7.1, 7.2 and Ruby 3.3
- Add support for Rails 8.0 and Ruby 3.4


## 2.3.1 - 2024-10-18

### Compatible changes

- Follow recommended way to extend Railties

## 2.3.0 - 2023-05-26

### Compatible changes

- `collect_ids` is now capable of parsing "string arrays" like `['1', '2', '3']`. This can be handy when handling params with ID arrays.

## 2.2.0 - 2023-03-01

### Compatible changes

- Add support for Ruby 3.2


## 2.1.0 - 2022-02-24

### Compatible changes
- Add support for Rails 7.0
- Activate Rubygems MFA


## 2.0.0 - 2021-08-24

### Breaking changes
- Drop support for Ruby < 2.5.0
- Drop support for Rails < 3.2

### Compatible changes
- Add support for Rails 6.1


## 1.1.0 - 2019-12-13

### Compatible changes
- Add `preload_association` at instance level. Example: `user.preload_associations(:posts)`
- Add support for polymorphic associations in `traverse_association`.


## 1.0.0- 2019-06-12

### Breaking changes
- Remove support for Ruby 2.2
- Remove support for Rails 2.3

### Compatible changes
- Add support for Ruby 2.5.3
- Add support for Rails 6.0.0.rc1


## 0.3.3 - 2018-08-29

### Compatible changes

- Fix for deprecation warning in Rails 5.2 in `collect_id`
- Added this CHANGELOG file.
