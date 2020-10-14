variable "server_side_planning" {
  type = bool
  default = false
}

provider "kubernetes-alpha" {
  server_side_planning = var.server_side_planning
  config_path = "~/.kube/config"
}

resource "kubernetes_manifest" "test-crd" {
  provider = kubernetes-alpha

  manifest = {
    apiVersion = "apiextensions.k8s.io/v1"
    kind       = "CustomResourceDefinition"
    metadata = {
      name = "testcrds.hashicorp.com"
      labels = {
        app = "test"
      }
    }
    spec = {
      group = "hashicorp.com"
      names = {
        kind   = "TestCrd"
        plural = "testcrds"
        singular = "testcrd"
        listKind = "TestCrds"
      }
      scope = "Namespaced"
      conversion = {
        strategy = "None"
      }
      versions = [{
        name    = "v1"
        served  = true
        storage = true
        schema = {
          openAPIV3Schema = {
            type = "object"
            properties = {
              data = {
                type = "string"
              }
              refs = {
                type = "number"
              }
            }
          }
        }
      }]
    }
  }
}
