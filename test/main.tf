# definitions for initial import
# commented fields cover all required fields for import ID, and additional fields required to adopt test container without restarting
# image hash is likely to change, copy from script as needed

resource "docker_network" "testservicenetwork" {
  # name = "testservicenetwork"
}

resource "docker_volume" "testservicevolume" {
  # name = "testservicevolume"
}

resource "docker_container" "testservice" {
  # name = "testservice"
  # image = "sha256:bc649bab30d150c10a84031a7f54c99a8c31069c7bc324a7899d7125d59cc973"

  # env = []
  
  # ports {
  #   internal = 80
  #   external = 8080
  #   ip       = "0.0.0.0"
  # }

  # mounts {
  #     read_only = false
  #     source    = "testservicevolume"
  #     target    = "/testdata"
  #     type      = "volume"
  # }

  # network_mode      = "testservicenetwork"
}
