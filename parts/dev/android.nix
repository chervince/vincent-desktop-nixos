# Android Studio + SDK + émulateur                                                                                                        
  { pkgs, ... }:                                                                                                                            
  {                                                                                                                                         
    home-manager.users.vincent.home.packages = with pkgs; [                                                                                 
      android-studio                                                                                                                        
      jdk                                                                                                                                   
    ];                                                                                                                                      
                                                                                                                                          
    # SDK géré par Android Studio dans ~/Android/Sdk                                                                                        
    home-manager.users.vincent.home.sessionVariables = {                                                                                  
      ANDROID_HOME = "$HOME/Android/Sdk";                                                                                                   
      ANDROID_SDK_ROOT = "$HOME/Android/Sdk";
    };                                                                                                                                      
                                                                                                                                          
    # Binaires emulator + adb dans le PATH                                                                                                  
    home-manager.users.vincent.home.sessionPath = [
      "$HOME/Android/Sdk/emulator"                                                                                                          
      "$HOME/Android/Sdk/platform-tools"                                                                                                  
    ];                                                                                                                                      
   
    # KVM pour l'émulateur Android                                                                                                          
    users.users.vincent.extraGroups = [ "kvm" ];                                                                                          
  }