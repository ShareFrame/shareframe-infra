resource "aws_instance" "shareframe_pds" {
  ami                  = var.ami
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  vpc_security_group_ids = [var.security_group]
  iam_instance_profile = var.iam_instance_profile

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp3"
    delete_on_termination = false
  }

  tags = {
    Name = var.instance_name
  }

  lifecycle {
    ignore_changes = [instance_state]
  }
}


resource "aws_volume_attachment" "ebs_attachment" {
  device_name = "/dev/sda1"
  volume_id   = var.ebs_volume_id
  instance_id = aws_instance.shareframe_pds.id
}

resource "aws_eip_association" "shareframe_pds_eip" {
  instance_id   = aws_instance.shareframe_pds.id
  allocation_id = var.eip_allocation_id
}
