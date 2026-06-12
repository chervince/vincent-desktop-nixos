# SSH — serveur (clés uniquement) + client 11 hosts via Home Manager
{ ... }:
{
  # Serveur SSH — authentification par clé uniquement
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Firewall : autoriser SSH entrant
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Client SSH via Home Manager
  home-manager.users.vincent.programs.ssh = {
    enable = true;

    # On ne laisse plus home-manager injecter ses défauts implicites dans le
    # bloc `Host *` (comportement déprécié) : on les déclare nous-mêmes ci-dessous.
    enableDefaultConfig = false;

    matchBlocks = {
      # Anciens défauts home-manager conservés explicitement pour tous les hosts.
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
      "mailserver-neith" = {
        hostname = "172.232.44.63";
        user = "root";
        identityFile = "~/.ssh/id_ed25519_mailserver";
        extraOptions = { ServerAliveInterval = "60"; ServerAliveCountMax = "3"; };
      };
      "wordpress-syd" = {
        hostname = "172.105.179.160";
        user = "vincent";
        port = 2222;
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = { ServerAliveInterval = "60"; ServerAliveCountMax = "3"; StrictHostKeyChecking = "no"; };
      };
      "wordpress-syd-ipv6" = {
        hostname = "2400:8907::2000:44ff:fe7c:ac9e";
        user = "vincent";
        port = 2222;
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = { ServerAliveInterval = "60"; ServerAliveCountMax = "3"; StrictHostKeyChecking = "no"; };
      };
      "wordpress-usa" = {
        hostname = "172.233.158.124";
        user = "wpadmin";
        port = 2222;
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = { ServerAliveInterval = "60"; ServerAliveCountMax = "3"; StrictHostKeyChecking = "no"; };
      };
      "wordpress-usa-ipv6" = {
        hostname = "2a01:7e03::2000:56ff:fef2:42e5";
        user = "wpadmin";
        port = 2222;
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = { ServerAliveInterval = "60"; ServerAliveCountMax = "3"; StrictHostKeyChecking = "no"; };
      };
      "apps-usa" = {
        hostname = "172.233.130.182";
        user = "dokploy-admin";
        identityFile = "~/.ssh/id_ed25519_apps_usa";
      };
      "groupama-siteground" = {
        hostname = "c76233.sgvps.net";
        user = "u47-hf1gfyihkyiy";
        port = 18765;
        identityFile = "~/.ssh/groupama_rgaa_key";
        extraOptions = { StrictHostKeyChecking = "no"; };
      };
      "groupama-pf" = {
        hostname = "c76233.sgvps.net";
        user = "u55-8lor0pcyrxum";
        port = 18765;
        identityFile = "~/.ssh/groupama_rgaa_key";
        extraOptions = { StrictHostKeyChecking = "no"; };
      };
      "groupama-paiement-nc" = {
        hostname = "c1119238.sgvps.net";
        user = "u3-nzd4ybokbwzs";
        port = 18765;
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = { StrictHostKeyChecking = "no"; };
      };
      "apps-syd" = {
        hostname = "194.195.120.251";
        user = "vincent";
        port = 2222;
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = { ServerAliveInterval = "60"; ServerAliveCountMax = "3"; };
      };
      "forge-shell" = {
        hostname = "forge-shell.neithforge.dev";
        user = "vincent";
        identityFile = "~/.ssh/neith-forge";
        # IdentitiesOnly: forge-shell sshd is fail2ban-hardened (24h ban + recidive
        # jail 7d, per ADR-0019). Without this, ssh-agent would try every loaded
        # key in order, racking up failed auth attempts that could ban the operator.
        extraOptions = { IdentitiesOnly = "yes"; ServerAliveInterval = "60"; ServerAliveCountMax = "3"; };
      };
      # Track C App-VPS — facturation-neith (Linode Sydney, ADR-0017).
      # Operator user, key-only auth. IdentitiesOnly: host sshd is fail2ban-hardened,
      # so we offer only the operator key instead of every agent-loaded key.
      "neith-fact" = {
        hostname = "172.105.177.107";
        user = "vincent";
        identityFile = "~/.ssh/neith-forge";
        extraOptions = { IdentitiesOnly = "yes"; ServerAliveInterval = "60"; ServerAliveCountMax = "3"; };
      };
    };
  };
}
