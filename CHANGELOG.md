# Changelog
All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased

### Breaking changes

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
