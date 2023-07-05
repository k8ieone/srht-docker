variable "TAG" {
  default = "test"
}

variable "REPO" {
  default = "git.mcld.eu/a13xie"
}

group "default" {
  targets = ["meta", "hub", "git"]
}

target "base" {
  dockerfile = "Dockerfile"
  context = "./base"
  platforms = ["linux/amd64"]
}

target "meta" {
  dockerfile = "Dockerfile"
  context = "./services/meta.sr.ht"
  contexts = {
    "sr.ht-base" = "target:base"
  }
  tags = ["${REPO}/srht-meta:${TAG}"]
  platforms = ["linux/amd64"]
}

target "hub" {
  dockerfile = "Dockerfile"
  context = "./services/hub.sr.ht"
  contexts = {
    "sr.ht-base" = "target:base"
  }
  tags = ["${REPO}/srht-hub:${TAG}"]
  platforms = ["linux/amd64"]
}

target "git" {
  dockerfile = "Dockerfile"
  context = "./services/git.sr.ht"
  contexts = {
    "sr.ht-base" = "target:base"
  }
  tags = ["${REPO}/srht-git:${TAG}"]
  platforms = ["linux/amd64"]
}
