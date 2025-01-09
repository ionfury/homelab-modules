variables {
  localfiles = {
    "file1.txt" = {
      filename         = "file1.txt"
      content          = "Hello, world!"
      file_permissions = "0644"
    }
    "file2.txt" = {
      filename         = "file2.txt"
      content          = "Goodbye, world!"
      file_permissions = "0644"
    }
  }
}

run "test" {
  assert {
    condition     = file(local_file.this["file1.txt"].filename) == "Hello, world!"
    error_message = "File content does not match expected value."
  }
  assert {
    condition     = file(local_file.this["file2.txt"].filename) == "Goodbye, world!"
    error_message = "File content does not match expected value."
  }
}
