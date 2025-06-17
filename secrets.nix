let
  arch_pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/2r/UUYwIhL/LCNzNNCuK0U7eWSreXe2P7j4WXTFsQ rawalcher@desktop";

  nuc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK/4fJWyfiu4la4EW36sBgQICgWxZ0PEPTQSy0TRwntv root@nixos";
  pi4_1gb = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBM7qyt6V6vklLNMsRmMohCK+0uSCqe6qqg1RYIYNSkl root@traffic-pi4-1gb";
  pi4_2gb = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBM7qyt6V6vklLNMsRmMohCK+0uSCqe6qqg1RYIYNSkl root@traffic-pi4-2gb";
  pi4_8gb = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBM7qyt6V6vklLNMsRmMohCK+0uSCqe6qqg1RYIYNSkl root@traffic-pi4-8gb";

  users = [ arch_pc ];
  systems = [ nuc pi4_1gb pi4_2gb pi4_8gb ];
in
{
  "secrets/deploy-key.age".publicKeys = users ++ systems;
  "secrets/deploy-key-traffic.age".publicKeys = users ++ systems;
}