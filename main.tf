provider "aws" {
  region              = "eu-west-2"
}
resource "aws_instance" "windows_Administrator" {
  ami             = "ami-0816d4ac78551609e"
  instance_type   = "t2.micro"
  associate_public_ip_address = true
  key_name = "windows-key"
  get_password_data = "true"

}

resource "aws_ssm_parameter" "windows_Administrator_secret" {
  name  = "/testing/windows_Administrator_password"
  type  = "SecureString"
  value = "${rsadecrypt(aws_instance.windows_Administrator.password_data, "${data.aws_ssm_parameter.qlik-multi-node-private-key.value}")}"
  description = "Administrator Password for windows_Administrator"

  tags = {
    Name              = "ssm parameter for Administrator password"
  }
}
data "aws_ssm_parameter" "qlik-multi-node-private-key" {
  name = "/testing/windows/private-key"
}