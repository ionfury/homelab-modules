resource "local_file" "this" {
  for_each = var.localfiles

  content         = each.value.content
  filename        = pathexpand(each.value.filename)
  file_permission = each.value.file_permissions
}
