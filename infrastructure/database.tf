resource "aws_db_instance" "pantry_database" {
   allocated_storage      = var.settings.database.allocated_storage
   max_allocated_storage  = var.settings.database.max_allocated_storage
   engine                 = var.settings.database.engine
   engine_version         = var.settings.database.engine_version
   instance_class         = var.settings.database.instance_class
   username               = "tarantini_admin"
   manage_master_user_password = true
   db_name                = var.settings.database.db_name
   db_subnet_group_name   = aws_db_subnet_group.pantry_db_subnet_group.id
   vpc_security_group_ids = [aws_security_group.pantry_db_sg.id]
   skip_final_snapshot    = var.settings.database.skip_final_snapshot
}
