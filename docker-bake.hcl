variable "TAG" {
  default = "latest"
}

variable "REPO" {
  default = "ghcr.io/k8ieone"
}

group "default" {
  targets = ["meta", "hub", "git", "hg"]
}

target "base" {
  dockerfile = "Dockerfile"
  context = "./base"
  platforms = ["linux/amd64", "linux/arm64"]
}

target "meta" {
  dockerfile = "Dockerfile"
  context = "./services/meta.sr.ht"
  contexts = {
    base = "target:base"
  }
  tags = ["${REPO}/srht-meta:${TAG}"]
  platforms = ["linux/amd64", "linux/arm64"]
}

target "hub" {
  dockerfile = "Dockerfile"
  context = "./services/hub.sr.ht"
  contexts = {
    base = "target:base"
  }
  tags = ["${REPO}/srht-hub:${TAG}"]
  platforms = ["linux/amd64", "linux/arm64"]
}

target "git" {
  dockerfile = "Dockerfile"
  context = "./services/git.sr.ht"
  contexts = {
    base = "target:base"
  }
  tags = ["${REPO}/srht-git:${TAG}"]
  platforms = ["linux/amd64", "linux/arm64"]
}

target "hg" {
  dockerfile = "Dockerfile"
  context = "./services/hg.sr.ht"
  contexts = {
    base = "target:base"
  }
  tags = ["${REPO}/srht-hg:${TAG}"]
  platforms = ["linux/amd64", "linux/arm64"]
}
