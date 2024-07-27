resource "local_file" "this" {
  filename = "${path.module}/${local.env_config["folder"]}/${local.env_config["filename"]}"
  content  = "${local.env_config["content"]}"
}