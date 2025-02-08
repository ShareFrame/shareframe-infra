output "instance_id" {
  value = aws_instance.shareframe_pds.id
}

output "public_ip" {
  value = aws_instance.shareframe_pds.public_ip
}

output "private_ip" {
  value = aws_instance.shareframe_pds.private_ip
}

output "volume_id" {
  value = aws_volume_attachment.ebs_attachment.volume_id
}
