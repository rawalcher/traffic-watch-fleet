let
  arch_pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/2r/UUYwIhL/LCNzNNCuK0U7eWSreXe2P7j4WXTFsQ rawalcher@desktop";
  pi1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBM7qyt6V6vklLNMsRmMohCK+0uSCqe6qqg1RYIYNSkl root@nixos";

  users = [ arch_pc ];
  systems = [ pi1 ];
in
{
  "secrets/deploy-key.age".publicKeys = users ++ systems;
  "secrets/wifi-password.age".publicKeys = users ++ systems;
}