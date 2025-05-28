locals {
  vm_names = [for i in range(var.vm_count) : "${var.name}-talos-vm-${format("%s", i + 1)}"]
}

resource "kubernetes_namespace" "this" {
  metadata {
    generate_name = "${var.name}-"
  }

  wait_for_default_service_account = true
}

resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode(
    {
      customization = {
        secureboot = {
          enabled = false
        }
      }
    }
  )
}

data "talos_image_factory_urls" "this" {
  talos_version = var.talos_version
  schematic_id  = talos_image_factory_schematic.this.id
  platform      = "metal"
  architecture  = "amd64"
}

resource "kubernetes_manifest" "talos_vm" {
  for_each = toset(local.vm_names)

  manifest = {
    apiVersion = "kubevirt.io/v1"
    kind       = "VirtualMachine"
    metadata = {
      name = each.key
      labels = {
        "app.kubernetes.io/name"      = each.key
        "app.kubernetes.io/instance"  = each.key
        "app.kubernetes.io/component" = "talos"
        "app.kubernetes.io/part-of"   = var.name
        "kubevirt.io/domain"          = each.key
      }
      namespace = kubernetes_namespace.this.metadata[0].name
    }
    spec = {
      running = true
      template = {
        metadata = {
          creationTimestamp = null
          labels = {
            "talos-cluster" = var.name
          }
        }
        spec = {
          terminationGracePeriodSeconds = 0
          domain = {
            machine = {
              type = "q35"
            }
            cpu = {
              cores = var.cores
            }
            resources = {
              requests = {
                memory = var.memory
              }
            }
            devices = {
              disks = [
                {
                  name      = "${each.key}-disk-vda-root"
                  bootOrder = 1
                  disk = {
                    bus = "virtio"
                  }
                },
                {
                  name = "${each.key}-disk-vdb-data"
                  disk = {
                    bus = "virtio"
                  }
                }
              ]
            }
          }
          volumes = [
            {
              name = "${each.key}-disk-vda-root"
              dataVolume = {
                name = "${each.key}-volume-vda-root"
              }
            },
            {
              name = "${each.key}-disk-vdb-data"
              dataVolume = {
                name = "${each.key}-volume-vdb-data"
              }
            }
          ]
        }
      }
      dataVolumeTemplates = [
        {
          metadata = {
            creationTimestamp = null
            name              = "${each.key}-volume-vda-root"
          }
          spec = {
            pvc = {
              accessModes = ["ReadWriteOnce"]
              resources = {
                requests = {
                  storage = var.data_root_size
                }
              }
              storageClassName = var.data_root_storage_class
            }
            source = {
              http = {
                url = data.talos_image_factory_urls.this.urls.disk_image
              }
            }
          }
        },
        {
          metadata = {
            creationTimestamp = null
            name              = "${each.key}-volume-vdb-data"
          }
          spec = {
            pvc = {
              accessModes = ["ReadWriteOnce"]
              resources = {
                requests = {
                  storage = var.data_disk_size
                }
              }
              storageClassName = var.data_disk_storage_class
            }
            source = {
              blank = {}
            }
          }
        }
      ]
    }
  }

  wait {
    condition {
      type   = "Ready"
      status = "True"
    }
  }
}

resource "kubernetes_service" "this" {
  for_each = toset(local.vm_names)

  metadata {
    name      = each.key
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      "app.kubernetes.io/name"      = each.key
      "app.kubernetes.io/instance"  = each.key
      "app.kubernetes.io/component" = "talos"
      "app.kubernetes.io/part-of"   = var.name
    }
  }

  spec {
    selector = {
      "vm.kubevirt.io/name" : each.key
    }

    port {
      name        = "talos-api"
      port        = 50000
      target_port = 50000
      protocol    = "TCP"
    }

    port {
      name        = "talos-worker"
      port        = 50001
      target_port = 50001
      protocol    = "TCP"
    }

    port {
      name        = "https"
      port        = 443
      target_port = 443
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "lb" {
  metadata {
    name      = "${var.name}-lb"
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      "app.kubernetes.io/name"      = "${var.name}-lb"
      "app.kubernetes.io/component" = "talos-lb"
      "app.kubernetes.io/part-of"   = var.name
    }
  }

  spec {
    selector = {
      "talos-cluster" = var.name
    }

    port {
      name        = "talos-api"
      port        = 50000
      target_port = 50000
      protocol    = "TCP"
    }

    port {
      name        = "https"
      port        = 443
      target_port = 443
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}



# asdf
