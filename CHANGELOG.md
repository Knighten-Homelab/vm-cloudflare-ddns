## [1.2.0](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/compare/1.1.0...1.2.0) (2025-02-02)

### Features

* gha deploy prod tf on main push ([#3](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/issues/3)) ([daf8c72](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/daf8c727591bc7c83ea1eec9232f1ac8e56254ff))

## [1.1.0](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/compare/1.0.0...1.1.0) (2025-02-02)

### Features

* gha terraform lint and sec scan ([#2](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/issues/2)) ([5ed8c49](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/5ed8c4979f0a23bf523c5dd5b0ddaf6e3600a90c))

## [1.0.0](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/compare/...1.0.0) (2025-02-01)

### Bug Fixes

* cleaned up devcontainer by removing extensions and boilerplate comments ([c942cec](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/c942cec535bcc287b718148e96f07999a05f8ae1))
* corrected missing user field in docker compose: ([f2a2ec8](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/f2a2ec8c332ba876b5a261db01a2875baf1e15c6))
* corrected module name from bad copy-paste ([740eecf](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/740eecf94b2f14fa7de9f8ee688895d754ff2a68))
* moved boolean value from yes to true ([c0cdb92](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/c0cdb928ac0e3152313dd04b72f1f6ff3e9699c9))
* moved from local tf backend to s3 ([1b1bb8c](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/1b1bb8c4961ae3d2f86824b94c6b46d1381f7c95))
* moved job template credentials to a variable in awx resource playbook ([e10940c](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/e10940c6f9dab67d5b12af437a8767ec559aa85c))
* moved target_fqdn var to hostname var and introduced host var ([88cbe24](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/88cbe2409a02dd3cff483a0c5777cf03aae58826))
* removed all awx references and vars from tf ([c72eaa6](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/c72eaa6a7edba6264db607ca21a4c8c6bb7feec1))
* removed cloudflare_ddns_records default role value and renamed main_dir to app_path ([da70b6f](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/da70b6f75a604d43f99d07ebd126d999a5c8c4c1))
* removed fqdn variable and used hostname instead ([2a9761d](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/2a9761d3734d9a17863f880a1afe0a2ce0361e2e))
* removed inventory and org existance check since they are auto handled ([5dc8aa5](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/5dc8aa59094d39efcf0f2716e47b7e4964eb3eed))
* removed references to ipaadmin vars ([a4bdae4](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/a4bdae4e43de6b5661523ffa0c4e4f111f31f9c9))
* renamed ddns-user to cloudflare ([5bdff7e](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/5bdff7e563a762b337bc64fcbdcd8d3852f5736c))
* renamed terraform dir to infra ([7fe3e14](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/7fe3e1458b6f3f67b4a3c09e99739939ec2ad146))
* updated awx inventory and host groups ([1643623](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/164362314b9ce9e4a6570262e2699a0af31f89c1))
* updated handler to use app_path var ([a036df9](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/a036df924a2e84808682e6d305229eda77915235))
* updated permissions on token file and add uid to docker compose ([a9ad3d0](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/a9ad3d047536f336e2c82c93dd8bb78f0bc895ae))
* updated tf versions supported ([ad60f60](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/ad60f604a43f0e8925cf44df9d9eb0e2b374a196))

### Features

* added awx inventory group membership to awx resource playbook ([e9bd98d](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/e9bd98d8b7231f967094f110cc3486c3068ee12e))
* added awx project and deployment template resources to tf ([fee164a](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/fee164acfe841d96c1ebcfe906bf1924cfb81f7a))
* added devcontainer to project ([efe2000](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/efe2000b4150968a1d6a8d29bf231726285c4332))
* added freeipa client ([83b426f](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/83b426f4f6cce017c70ff0cef79e70ef066d03b4))
* added prod vars for ansible ([7654f04](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/7654f04a65268b48512ff3ca7eb36cc412c06385))
* added variable checks for both playbooks and moved ipaclient vars to job template vars ([4eb00d4](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/4eb00d4a15dd8bf4923fc25458d6e82df2d7e9f1))
* cleaned up hostname and ipa related vars for deploy playbook ([6e58426](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/6e584261f73272c0b9d80e261ff5568ef96d8910))
* created ansible role for cloudflare ddns and playbook to deploy ([d2c55fc](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/d2c55fc1f64878560a3f6f4baf5e8c3d78bd17a4))
* created dns_zone tf variable to handle pdns zone ([865d0a6](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/865d0a6bf5075aabbcae2974f24f9dc4247c8aa2))
* created tf module to create vm for cloduflare ddns ([1c5b954](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/1c5b9547cda3e3747fe3641b236d68ff1e114d3a))
* gha release workflow ([bd2be07](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/bd2be0711753f7472baa80964255f23345055a93))
* moved awx resource creation to a ansible playbook ([9ed5fac](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/9ed5fac863f35abe1bf40b2cb336625e98978636))
* moved to the favonia/cloudflare-ddns image ([4760bce](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/4760bcefee61b1e3face7ae635c74edcc1d88405))
* removed tfvars from gitignore and added env folder to repo ([9e1aa69](https://github.com/Knighten-Homelab/vm-cloudflare-ddns/commit/9e1aa69aabfdf68a3a2e8829160ba9387ad3713e))
