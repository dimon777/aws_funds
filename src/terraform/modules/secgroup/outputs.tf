# Output the public DNS address so we know where to connect to using WinRM.
output "sg-winrm-enabled_id" {
	value = "${aws_security_group.winrm-allow.id}"
}

output "sg-rdp-data-subnet-enabled" {
  value = "${aws_security_group.rdp-data-subnet-allow.id}"
}


# sec group for linux instance
output "ec2-instance-id" {
  value = "${aws_security_group.ec2-instance-all.id}"
}

# sec group for ssh access
output "ec2-ssh-allow-id" {
  value = "${aws_security_group.ec2-ssh-allow.id}"
}

