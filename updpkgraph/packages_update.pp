#    Copyright 2016 Mirantis, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#
#
#    Update packages with versions from the hiera as a source (override/common)
#    Keys of group_versions dict should have a form of regexp
#
#    For example:
#    static_versions:
#      openssh-client: '1:6.6p1-2ubuntu2.8'
#      libcurl3 : '7.35.0-1ubuntu2.8'
#      mc : latest
#    group_versions:
#      ^.*apache2.*$ : '2.4.7_1ubuntu4.13'
#      ^grub-[b,d].*$ : latest

$ensure_attribute = "ensure" # This is a parameter for package_resource
$static_packages  = hiera_hash("static_versions")
$group_packages   = hiera_hash("group_versions")
validate_hash($static_packages)
validate_hash($group_packages)


notice("Proceed with the following hash of packages: ")
notice($static_packages)
notice($group_packages)

# Create a hash for static_packages
$static_packages_hash = hash(zip(keys($static_packages), getarrayhash("$ensure_attribute",values($static_packages))))
notice("Resulted static_packages_hash to implement:")
notice($static_packages_hash)
validate_hash($static_packages_hash)

# Create a hash for package groups
$initial_group_hash = getpackagegrouphash($group_packages, keys($static_packages))
$group_packages_hash = hash(zip(keys($initial_group_hash), getarrayhash("$ensure_attribute",values($initial_group_hash))))
notice("Resulted groups_packages_hash to implement:")
notice($group_packages_hash)
validate_hash($group_packages_hash)

create_resources(package, $static_packages_hash)
create_resources(package, $group_packages_hash)

