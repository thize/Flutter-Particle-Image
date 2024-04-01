#include "include/particle_image/particle_image_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "particle_image_plugin.h"

void ParticleImagePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  particle_image::ParticleImagePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
