provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}" 
}
resource "aws_iam_user" "satya" {
    name = "satya"
    path = "/system/"
}

resource "aws_iam_access_key" "accesskey" {
    user = "${aws_iam_user.satya.name}"
}


output "user" {
    value = "${aws_iam_user.satya.name}"
}
